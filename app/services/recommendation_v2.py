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
            "llm_recommended_tracks": [],
            "results": [],
            "unmatched_tracks": [],
        }

    # ── Step 2: Ask LLM for taste analysis + 10 recommended tracks ──
    llm_result = await llm_service.analyze_user_taste_and_recommend(user_recs_json)
    taste_keywords: list[str] = llm_result.get("keywords", [])
    llm_tracks: list[dict] = llm_result.get("recommended_tracks", [])

    if not llm_tracks:
        return {
            "user_taste_keywords": taste_keywords,
            "llm_recommended_tracks": [],
            "results": [],
            "unmatched_tracks": [],
        }

    # ── Step 3: Search our DB for the recommended tracks ──
    matched_tracks = await _find_tracks_in_db(db, llm_tracks)

    # Separate matched vs unmatched
    matched_results = []
    unmatched_tracks = []

    for lt in llm_tracks:
        key = f"{lt['title'].lower()}|||{lt['artist'].lower()}"
        if key in matched_tracks:
            matched_results.append({
                "llm_track": lt,
                "db_track": matched_tracks[key],
            })
        else:
            unmatched_tracks.append(lt)

    # ── Step 4: Find recommendations/places for matched tracks ──
    track_ids = [m["db_track"].id for m in matched_results]
    all_recs = await _find_recommendations_for_tracks(db, track_ids)

    # Group recommendations by track_id
    recs_by_track: dict[int, list[Recommendation]] = {}
    for rec in all_recs:
        recs_by_track.setdefault(rec.track_id, []).append(rec)

    # ── Step 5: For each matched track, build recommendation list & collect messages ──
    # track_key -> list of matched_recommendation dicts
    built_results: dict[str, dict] = {}
    # track_key -> list of messages (for batch keyword extraction)
    messages_by_track: dict[str, list[str]] = {}

    for m in matched_results:
        db_track: Track = m["db_track"]
        track_key = f"{db_track.title}|||{db_track.artist}"
        track_recs = recs_by_track.get(db_track.id, [])

        matched_recommendations = []
        messages: list[str] = []

        for rec in track_recs:
            matched_recommendations.append({
                "recommendation_id": rec.id,
                "track": {
                    "id": db_track.id,
                    "spotify_track_id": db_track.spotify_track_id,
                    "title": db_track.title,
                    "artist": db_track.artist,
                    "album": db_track.album,
                    "album_cover_url": db_track.album_cover_url,
                    "track_url": db_track.track_url,
                    "preview_url": db_track.preview_url,
                    "genres": db_track.genres,
                    "created_at": rec.track.created_at.isoformat(),
                },
                "message": rec.message,
                "place_name": rec.place.place_name if rec.place else None,
                "address": rec.place.address if rec.place else None,
                "lat": rec.lat,
                "lng": rec.lng,
                "created_by": {
                    "id": rec.user.id,
                    "spotify_id": rec.user.spotify_id,
                    "display_name": rec.user.display_name,
                    "profile_image_url": rec.user.profile_image_url,
                    "status_message": getattr(rec.user, "status_message", None),
                },
            })
            if rec.message:
                messages.append(rec.message)

        built_results[track_key] = {
            "llm_track": m["llm_track"],
            "matched_recommendations": matched_recommendations,
        }
        messages_by_track[track_key] = messages

    # ── Step 6: Batch keyword extraction — single LLM call for all tracks ──
    keywords_by_track = await llm_service.extract_keywords_batch(messages_by_track)

    # Assemble final results list
    results = []
    for track_key, data in built_results.items():
        results.append({
            "llm_track": data["llm_track"],
            "matched_recommendations": data["matched_recommendations"],
            "place_keywords": keywords_by_track.get(track_key, []),
        })

    return {
        "user_taste_keywords": taste_keywords,
        "llm_recommended_tracks": llm_tracks,
        "results": results,
        "unmatched_tracks": unmatched_tracks,
    }
