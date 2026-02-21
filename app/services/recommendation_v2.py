"""
LLM-based recommendation service (v2)

Flow:
1. Collect all of the current user's recommendations (track + message + place)
2. Send to LLM → get taste keywords + 10 recommended tracks
3. Search DB for those recommended tracks
4. Find recommendations/places where those tracks are planted
5. Collect messages from those recommendations
6. Send messages back to LLM → extract keywords per place group
7. Return final result
"""
import logging
from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, func, or_
from sqlalchemy.orm import selectinload

from app.models.recommendation import Recommendation
from app.models.track import Track
from app.models.place import Place
from app.models.user import User
from app.services.llm import llm_service

logger = logging.getLogger(__name__)


async def _collect_user_recommendations(
    db: AsyncSession,
    user_id: int,
) -> list[dict]:
    """
    Gather all of a user's non-deleted recommendations into a simple JSON-friendly list.
    """
    result = await db.execute(
        select(Recommendation)
        .options(
            selectinload(Recommendation.track),
            selectinload(Recommendation.place),
        )
        .where(
            and_(
                Recommendation.user_id == user_id,
                Recommendation.deleted_at.is_(None),
            )
        )
        .order_by(Recommendation.created_at.desc())
    )
    recommendations = result.scalars().all()

    items: list[dict] = []
    for rec in recommendations:
        item = {
            "title": rec.track.title,
            "artist": rec.track.artist,
            "album": rec.track.album,
            "genres": rec.track.genres or [],
            "message": rec.message,
            "place_name": rec.place.place_name if rec.place else None,
        }
        items.append(item)

    return items


async def _find_tracks_in_db(
    db: AsyncSession,
    recommended_tracks: list[dict],
) -> dict[str, Track]:
    """
    Try to match LLM-recommended tracks (title + artist) against our DB.

    Returns a dict keyed by "title|||artist" (lowered) → Track.
    We use ILIKE for fuzzy case-insensitive matching.
    """
    if not recommended_tracks:
        return {}

    # Build OR conditions for each track
    conditions = []
    for t in recommended_tracks:
        conditions.append(
            and_(
                func.lower(Track.title) == func.lower(t["title"]),
                func.lower(Track.artist) == func.lower(t["artist"]),
            )
        )

    result = await db.execute(
        select(Track).where(or_(*conditions))
    )
    tracks = result.scalars().all()

    matched: dict[str, Track] = {}
    for track in tracks:
        key = f"{track.title.lower()}|||{track.artist.lower()}"
        matched[key] = track

    return matched


async def _find_recommendations_for_tracks(
    db: AsyncSession,
    track_ids: list[int],
) -> list[Recommendation]:
    """
    Find all non-deleted recommendations that reference the given track IDs.
    Eagerly loads track, place, and user.
    """
    if not track_ids:
        return []

    result = await db.execute(
        select(Recommendation)
        .options(
            selectinload(Recommendation.track),
            selectinload(Recommendation.place),
            selectinload(Recommendation.user),
        )
        .where(
            and_(
                Recommendation.track_id.in_(track_ids),
                Recommendation.deleted_at.is_(None),
            )
        )
        .order_by(Recommendation.created_at.desc())
    )
    return list(result.scalars().all())


async def get_llm_recommendations(
    db: AsyncSession,
    user: User,
) -> dict:
    """
    Main orchestrator for the LLM-based recommendation algorithm (v2).

    Returns a dict matching LLMRecommendationResponse schema.
    """
    # ── Step 1: Collect user's recommendations as JSON ──
    user_recs_json = await _collect_user_recommendations(db, user.id)

    if not user_recs_json:
        return {
            "user_taste_keywords": [],
            "places": [],
        }

    # ── Step 2: Ask LLM for taste analysis + 10 recommended tracks ──
    llm_result = await llm_service.analyze_user_taste_and_recommend(user_recs_json)
    taste_keywords: list[str] = llm_result.get("keywords", [])
    llm_tracks: list[dict] = llm_result.get("recommended_tracks", [])

    if not llm_tracks:
        return {
            "user_taste_keywords": taste_keywords,
            "places": [],
        }

    # ── Step 3: Search our DB for the recommended tracks ──
    matched_tracks = await _find_tracks_in_db(db, llm_tracks)

    if not matched_tracks:
        return {
            "user_taste_keywords": taste_keywords,
            "places": [],
        }

    # ── Step 4: Find recommendations/places for matched tracks ──
    track_ids = [t.id for t in matched_tracks.values()]
    all_recs = await _find_recommendations_for_tracks(db, track_ids)

    # ── Step 5: Group by place (deduplicate by lat/lng) & collect messages ──
    # place_key -> { place info + messages + matched track ids }
    places_map: dict[str, dict] = {}
    total_matched_track_count = len(matched_tracks)

    for rec in all_recs:
        place_key = f"{rec.lat:.6f},{rec.lng:.6f}"
        if place_key not in places_map:
            places_map[place_key] = {
                "place_name": rec.place.place_name if rec.place else None,
                "address": rec.place.address if rec.place else None,
                "lat": rec.lat,
                "lng": rec.lng,
                "messages": [],
                "matched_track_ids": set(),
            }
        if rec.message:
            places_map[place_key]["messages"].append(rec.message)
        places_map[place_key]["matched_track_ids"].add(rec.track_id)

    # ── Step 6: Batch keyword extraction — single LLM call for all places ──
    messages_by_place = {k: v["messages"] for k, v in places_map.items()}
    keywords_by_place = await llm_service.extract_keywords_batch(messages_by_place)

    # Assemble final places list
    places = []
    for place_key, info in places_map.items():
        # likelihood = matched tracks at this place / total matched tracks
        likelihood = len(info["matched_track_ids"]) / total_matched_track_count if total_matched_track_count > 0 else 0
        places.append({
            "place_name": info["place_name"],
            "address": info["address"],
            "lat": info["lat"],
            "lng": info["lng"],
            "keywords": keywords_by_place.get(place_key, []),
            "likelihood": round(likelihood, 2),
        })

    # Sort by likelihood descending
    places.sort(key=lambda p: p["likelihood"], reverse=True)

    return {
        "user_taste_keywords": taste_keywords,
        "places": places,
    }
