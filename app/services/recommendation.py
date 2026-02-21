"""
Recommendation business logic service
"""
import logging
from typing import Optional, List, Tuple, Dict
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from geoalchemy2.functions import ST_MakePoint

from app.models.user import User
from app.models.track import Track
from app.models.place import Place
from app.models.recommendation import Recommendation
from app.models.like import RecommendationLike
from app.services.spotify import spotify_service
from app.schemas.recommendation import PlaceInput
from app.core.database_utils import (
    filter_by_radius,
    add_distance_column,
    create_point_geom,
    calculate_distance_meters
)

logger = logging.getLogger(__name__)


async def get_or_create_track(
    db: AsyncSession,
    spotify_track_id: str
) -> Optional[Track]:
    """
    Get existing track or fetch from Spotify and create new one
    
    Args:
        db: Database session
        spotify_track_id: Spotify track ID
        
    Returns:
        Track object or None if failed
    """
    # Check if track already exists
    result = await db.execute(
        select(Track).where(Track.spotify_track_id == spotify_track_id)
    )
    track = result.scalar_one_or_none()
    
    if track:
        return track
    
    # Fetch from Spotify
    track_metadata = spotify_service.get_track_metadata(spotify_track_id)
    if not track_metadata:
        logger.error(f"Failed to fetch track metadata from Spotify: {spotify_track_id}")
        return None
    
    # Create new track
    track = Track(
        spotify_track_id=track_metadata["spotify_track_id"],
        title=track_metadata["title"],
        artist=track_metadata["artist"],
        album=track_metadata.get("album"),
        album_cover_url=track_metadata.get("album_cover_url"),
        track_url=track_metadata.get("track_url"),
        preview_url=track_metadata.get("preview_url")
    )
    
    db.add(track)
    await db.flush()
    
    return track


async def get_or_create_place(
    db: AsyncSession,
    lat: float,
    lng: float,
    place_input: Optional[PlaceInput]
) -> Optional[Place]:
    """
    Get existing place or create new one
    
    Args:
        db: Database session
        lat: Latitude
        lng: Longitude
        place_input: Optional place information
        
    Returns:
        Place object or None if no place_input provided
    """
    if not place_input:
        return None
    
    # If Google place, check if it already exists
    if place_input.source == "google" and place_input.google_place_id:
        result = await db.execute(
            select(Place).where(Place.google_place_id == place_input.google_place_id)
        )
        place = result.scalar_one_or_none()
        
        if place:
            return place
    
    # Create new place
    geom_expr = ST_MakePoint(lng, lat, type_='POINT', srid=4326)
    
    place = Place(
        google_place_id=place_input.google_place_id if place_input.source == "google" else None,
        place_name=place_input.place_name,
        address=place_input.address,
        lat=lat,
        lng=lng,
        geom=geom_expr
    )
    
    db.add(place)
    await db.flush()
    
    return place


async def create_recommendation(
    db: AsyncSession,
    user: User,
    lat: float,
    lng: float,
    spotify_track_id: str,
    message: Optional[str],
    note: Optional[str],
    place_input: Optional[PlaceInput]
) -> Optional[Recommendation]:
    """
    Create a new recommendation
    
    Args:
        db: Database session
        user: User creating the recommendation
        lat: Latitude
        lng: Longitude
        spotify_track_id: Spotify track ID
        message: Short message
        note: Longer note
        place_input: Optional place information
        
    Returns:
        Created recommendation or None if failed
    """
    # Get or create track
    track = await get_or_create_track(db, spotify_track_id)
    if not track:
        return None
    
    # Get or create place
    place = await get_or_create_place(db, lat, lng, place_input)
    
    # Create recommendation
    geom_expr = ST_MakePoint(lng, lat, type_='POINT', srid=4326)
    
    recommendation = Recommendation(
        user_id=user.id,
        track_id=track.id,
        place_id=place.id if place else None,
        lat=lat,
        lng=lng,
        geom=geom_expr,
        message=message,
        note=note
    )
    
    db.add(recommendation)
    await db.commit()
    await db.refresh(recommendation)
    
    # Log potential duplicate (not blocking, just warning)
    await _log_potential_duplicate(db, user.id, track.id, lat, lng, recommendation.id)
    
    return recommendation


async def _log_potential_duplicate(
    db: AsyncSession,
    user_id: int,
    track_id: int,
    lat: float,
    lng: float,
    new_rec_id: int
):
    """
    Check and log if there's a potential duplicate recommendation
    (same user, same track, nearby location within 50m)
    """
    try:
        # Query for similar recommendations
        query = select(Recommendation).where(
            and_(
                Recommendation.user_id == user_id,
                Recommendation.track_id == track_id,
                Recommendation.deleted_at.is_(None),
                Recommendation.id != new_rec_id
            )
        )
        
        # Apply distance filter (50m radius)
        query = filter_by_radius(query, lat, lng, 50)
        
        result = await db.execute(query)
        similar_recs = result.scalars().all()
        
        if similar_recs:
            logger.warning(
                f"Potential duplicate recommendation detected: "
                f"rec_id={new_rec_id}, user_id={user_id}, track_id={track_id}, "
                f"similar_count={len(similar_recs)}"
            )
    except Exception as e:
        logger.error(f"Failed to check for duplicate recommendations: {str(e)}")


async def check_distance_access(
    db: AsyncSession,
    recommendation_id: int,
    user_lat: float,
    user_lng: float,
    max_distance_meters: float = 200
) -> Tuple[bool, Optional[float]]:
    """
    Check if user is within access distance of recommendation
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        user_lat: User's latitude
        user_lng: User's longitude
        max_distance_meters: Maximum allowed distance (default 200m)
        
    Returns:
        Tuple of (is_within_range: bool, distance_meters: Optional[float])
    """
    # Get recommendation
    result = await db.execute(
        select(Recommendation).where(
            and_(
                Recommendation.id == recommendation_id,
                Recommendation.deleted_at.is_(None)
            )
        )
    )
    recommendation = result.scalar_one_or_none()
    
    if not recommendation:
        return (False, None)
    
    # Calculate distance
    distance = await calculate_distance_meters(
        db,
        user_lat,
        user_lng,
        recommendation.lat,
        recommendation.lng
    )
    
    is_within_range = distance <= max_distance_meters
    
    return (is_within_range, distance)


async def add_or_update_reaction(
    db: AsyncSession,
    recommendation_id: int,
    user_id: int,
    emoji: str
) -> Tuple[Dict[str, int], Optional[str]]:
    """
    Add or update user's emoji reaction to a recommendation
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        user_id: User ID
        emoji: Emoji reaction (unicode or name)
        
    Returns:
        Tuple of (reactions: Dict[str, int], user_reaction: Optional[str])
    """
    # Check if reaction already exists
    result = await db.execute(
        select(RecommendationLike).where(
            and_(
                RecommendationLike.recommendation_id == recommendation_id,
                RecommendationLike.user_id == user_id
            )
        )
    )
    existing_reaction = result.scalar_one_or_none()
    
    if existing_reaction:
        # Update existing reaction
        existing_reaction.emoji = emoji
    else:
        # Add new reaction
        new_reaction = RecommendationLike(
            recommendation_id=recommendation_id,
            user_id=user_id,
            emoji=emoji
        )
        db.add(new_reaction)
    
    await db.commit()
    
    # Get updated reactions
    reactions = await get_reactions(db, recommendation_id)
    
    return (reactions, emoji)


async def remove_reaction(
    db: AsyncSession,
    recommendation_id: int,
    user_id: int
) -> Dict[str, int]:
    """
    Remove user's reaction from a recommendation
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        user_id: User ID
        
    Returns:
        Updated reactions dict
    """
    # Find and delete reaction
    result = await db.execute(
        select(RecommendationLike).where(
            and_(
                RecommendationLike.recommendation_id == recommendation_id,
                RecommendationLike.user_id == user_id
            )
        )
    )
    reaction = result.scalar_one_or_none()
    
    if reaction:
        await db.delete(reaction)
        await db.commit()
    
    # Get updated reactions
    reactions = await get_reactions(db, recommendation_id)
    
    return reactions


async def get_reactions(
    db: AsyncSession,
    recommendation_id: int
) -> Dict[str, int]:
    """
    Get emoji reactions with counts for a recommendation
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        
    Returns:
        Dict mapping emoji to count, e.g. {"❤️": 5, "👍": 3}
    """
    result = await db.execute(
        select(
            RecommendationLike.emoji,
            func.count(RecommendationLike.id).label('count')
        )
        .where(RecommendationLike.recommendation_id == recommendation_id)
        .group_by(RecommendationLike.emoji)
    )
    
    reactions = {row.emoji: row.count for row in result}
    return reactions


async def get_user_reaction(
    db: AsyncSession,
    recommendation_id: int,
    user_id: int
) -> Optional[str]:
    """
    Get user's current reaction emoji for a recommendation
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        user_id: User ID
        
    Returns:
        Emoji string or None if no reaction
    """
    result = await db.execute(
        select(RecommendationLike.emoji).where(
            and_(
                RecommendationLike.recommendation_id == recommendation_id,
                RecommendationLike.user_id == user_id
            )
        )
    )
    emoji = result.scalar_one_or_none()
    return emoji


# Legacy function for backward compatibility (deprecated)
async def toggle_like(
    db: AsyncSession,
    recommendation_id: int,
    user_id: int
) -> Tuple[bool, int]:
    """
    Toggle like on a recommendation (deprecated - use add_or_update_reaction)
    
    Args:
        db: Database session
        recommendation_id: Recommendation ID
        user_id: User ID
        
    Returns:
        Tuple of (liked: bool, like_count: int)
    """
    # Check if reaction already exists
    result = await db.execute(
        select(RecommendationLike).where(
            and_(
                RecommendationLike.recommendation_id == recommendation_id,
                RecommendationLike.user_id == user_id
            )
        )
    )
    existing_reaction = result.scalar_one_or_none()
    
    if existing_reaction:
        # Unlike - remove the reaction
        await db.delete(existing_reaction)
        liked = False
    else:
        # Like - add default heart reaction
        new_reaction = RecommendationLike(
            recommendation_id=recommendation_id,
            user_id=user_id,
            emoji="❤️"
        )
        db.add(new_reaction)
        liked = True
    
    await db.commit()
    
    # Get updated like count (total reactions)
    count_result = await db.execute(
        select(func.count(RecommendationLike.id)).where(
            RecommendationLike.recommendation_id == recommendation_id
        )
    )
    like_count = count_result.scalar() or 0
    
    return (liked, like_count)


async def get_like_count(db: AsyncSession, recommendation_id: int) -> int:
    """Get like count for a recommendation (deprecated - use get_reactions)"""
    result = await db.execute(
        select(func.count(RecommendationLike.id)).where(
            RecommendationLike.recommendation_id == recommendation_id
        )
    )
    return result.scalar() or 0


async def check_user_liked(
    db: AsyncSession,
    recommendation_id: int,
    user_id: int
) -> bool:
    """Check if user has liked a recommendation"""
    result = await db.execute(
        select(RecommendationLike).where(
            and_(
                RecommendationLike.recommendation_id == recommendation_id,
                RecommendationLike.user_id == user_id
            )
        )
    )
    return result.scalar_one_or_none() is not None
