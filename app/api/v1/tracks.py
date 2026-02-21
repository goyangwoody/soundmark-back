"""
Track API routes
"""
import logging
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.track import Track
from app.models.recommendation import Recommendation
from app.schemas.track import PopularTracksResponse, PopularTrackItem

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/tracks", tags=["Tracks"])


@router.get("/popular", response_model=PopularTracksResponse, status_code=status.HTTP_200_OK)
async def get_popular_tracks(
    db: AsyncSession = Depends(get_db),
):
    """
    Get the top 5 most recommended tracks.

    Returns tracks ordered by how many times they have been recommended (excluding soft-deleted recommendations).

    No authentication required.
    """
    stmt = (
        select(
            Track.spotify_track_id,
            Track.title,
            Track.artist,
            func.count(Recommendation.id).label("recommendation_count"),
        )
        .join(Recommendation, Recommendation.track_id == Track.id)
        .where(Recommendation.deleted_at.is_(None))
        .group_by(Track.id, Track.spotify_track_id, Track.title, Track.artist)
        .order_by(func.count(Recommendation.id).desc())
        .limit(5)
    )

    result = await db.execute(stmt)
    rows = result.all()

    tracks = [
        PopularTrackItem(
            spotify_track_id=row.spotify_track_id,
            title=row.title,
            artist=row.artist,
            recommendation_count=row.recommendation_count,
        )
        for row in rows
    ]

    return PopularTracksResponse(tracks=tracks, total=len(tracks))
