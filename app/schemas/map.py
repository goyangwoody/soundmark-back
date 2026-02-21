"""
Map related Pydantic schemas
"""
from typing import List
from pydantic import BaseModel, Field

from app.schemas.track import TrackResponse
from app.schemas.auth import UserResponse


class RecommendationItem(BaseModel):
    """Individual recommendation item"""
    id: int
    lat: float
    lng: float
    distance_meters: float
    is_active: bool = Field(..., description="True if within 200m, False otherwise")
    track: TrackResponse
    user: UserResponse
    total_reactions: int = Field(default=0, description="Total count of all reactions")


class MapResponse(BaseModel):
    """Map view response with all recommendations within 10km"""
    recommendations: List[RecommendationItem] = Field(
        default_factory=list,
        description="All recommendations within 10km radius"
    )
