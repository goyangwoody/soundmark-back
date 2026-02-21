"""
Map related Pydantic schemas
"""
from typing import List, Optional, Dict
from pydantic import BaseModel, Field

from app.schemas.track import TrackResponse
from app.schemas.auth import UserResponse


class ActiveRecommendation(BaseModel):
    """Individual active recommendation (within 200m)"""
    id: int
    lat: float
    lng: float
    distance_meters: float
    track: TrackResponse
    user: UserResponse
    message: Optional[str] = None
    reactions: Dict[str, int] = Field(default_factory=dict, description="Emoji reactions with counts")
    user_reaction: Optional[str] = Field(None, description="Current user's reaction emoji")


class InactiveCluster(BaseModel):
    """Cluster of inactive recommendations (beyond 200m)"""
    lat: float = Field(..., description="Center latitude of cluster")
    lng: float = Field(..., description="Center longitude of cluster")
    count: int = Field(..., description="Number of recommendations in cluster")


class MapResponse(BaseModel):
    """Map view response with active and inactive recommendations"""
    active_recommendations: List[ActiveRecommendation] = Field(
        default_factory=list,
        description="Recommendations within 200m radius"
    )
    inactive_counts: List[InactiveCluster] = Field(
        default_factory=list,
        description="Clustered counts for distant recommendations"
    )
