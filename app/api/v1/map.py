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
    my_lat: float = Query(..., description="User's actual latitude (for distance/active calculation)", ge=-90, le=90),
    my_lng: float = Query(..., description="User's actual longitude (for distance/active calculation)", ge=-180, le=180),
    lat: float = Query(..., description="Map center latitude (for fetching recommendations)", ge=-90, le=90),
    lng: float = Query(..., description="Map center longitude (for fetching recommendations)", ge=-180, le=180),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get all recommendations within 10km radius of (lat, lng)
    
    Recommendations are fetched based on (lat, lng) center.
    distance_meters and is_active are calculated from (my_lat, my_lng).
    
    **Active**: Within 200m from user's actual position (is_active=True)
    **Inactive**: Beyond 200m from user's actual position (is_active=False)
    
    Requires authentication.
    
    Args:
        my_lat: User's actual latitude
        my_lng: User's actual longitude
        lat: Map center latitude
        lng: Map center longitude
        current_user: Authenticated user
        db: Database session
        
    Returns:
        All recommendations within 2km with active/inactive status
    """
    # Get all recommendations within 10km of (lat, lng), distance from (my_lat, my_lng)
    recommendations_with_distance = await get_map_data(
        db, center_lat=lat, center_lng=lng,
        my_lat=my_lat, my_lng=my_lng, radius_meters=10000
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
