"""
Map API routes
"""
import logging
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.schemas.map import MapResponse, ActiveRecommendation, InactiveCluster
from app.schemas.track import TrackResponse
from app.services.location import get_map_data
from app.services.recommendation import get_like_count, check_user_liked
from app.core.security import get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/map", tags=["Map"])


@router.get("/nearby", response_model=MapResponse)
async def get_nearby_map_data(
    lat: float = Query(..., description="User's current latitude", ge=-90, le=90),
    lng: float = Query(..., description="User's current longitude", ge=-180, le=180),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get map data with active and inactive recommendations
    
    **Active recommendations**: Within 200m radius, returns full details
    **Inactive counts**: Beyond 200m, returns clustered counts
    
    Requires authentication.
    
    Args:
        lat: User's current latitude
        lng: User's current longitude
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Map data with active recommendations and inactive clusters
    """
    # Get map data
    active_recommendations, inactive_clusters = await get_map_data(
        db, lat, lng, active_radius_meters=200, grid_size_meters=400
    )
    
    # Build response for active recommendations
    active_response = []
    for recommendation, distance in active_recommendations:
        # Get like count and liked status
        like_count = await get_like_count(db, recommendation.id)
        liked = await check_user_liked(db, recommendation.id, current_user.id)
        
        active_response.append(
            ActiveRecommendation(
                id=recommendation.id,
                lat=recommendation.lat,
                lng=recommendation.lng,
                distance_meters=distance,
                track=TrackResponse.model_validate(recommendation.track),
                message=recommendation.message,
                like_count=like_count,
                liked=liked
            )
        )
    
    # Build response for inactive clusters
    inactive_response = [
        InactiveCluster(
            lat=cluster["lat"],
            lng=cluster["lng"],
            count=cluster["count"]
        )
        for cluster in inactive_clusters
    ]
    
    return MapResponse(
        active_recommendations=active_response,
        inactive_counts=inactive_response
    )
