"""
Map API routes
"""
import logging
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.schemas.map import MapResponse, RecommendationItem
from app.schemas.track import TrackResponse
from app.schemas.auth import UserResponse
from app.services.location import get_map_data
from app.services.recommendation import get_reactions, get_user_reaction
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
    Get all recommendations within 2km radius
    
    **Active**: Within 200m radius (is_active=True)
    **Inactive**: Beyond 200m but within 2km (is_active=False)
    
    Requires authentication.
    
    Args:
        lat: User's current latitude
        lng: User's current longitude
        current_user: Authenticated user
        db: Database session
        
    Returns:
        All recommendations within 2km with active/inactive status
    """
    # Get all recommendations within 2km
    recommendations_with_distance = await get_map_data(
        db, lat, lng, radius_meters=2000
    )
    
    # Build response
    response_items = []
    for recommendation, distance in recommendations_with_distance:
        # Get total reactions count
        reactions = await get_reactions(db, recommendation.id)
        total_reactions = sum(reactions.values())
        
        response_items.append(
            RecommendationItem(
                id=recommendation.id,
                lat=recommendation.lat,
                lng=recommendation.lng,
                distance_meters=distance,
                is_active=(distance <= 200),
                track=TrackResponse.model_validate(recommendation.track),
                user=UserResponse.model_validate(recommendation.user),
                total_reactions=total_reactions
            )
        )
    
    return MapResponse(
        recommendations=response_items
    )
