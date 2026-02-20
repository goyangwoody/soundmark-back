"""
Recommendation related Pydantic schemas
"""
from typing import Optional
from pydantic import BaseModel, Field, field_validator
from datetime import datetime

from app.schemas.track import TrackResponse
from app.schemas.auth import UserResponse


class PlaceInput(BaseModel):
    """Place information input (Google or manual)"""
    source: str = Field(..., description="'google' or 'manual'")
    google_place_id: Optional[str] = None
    place_name: str
    address: Optional[str] = None
    
    @field_validator('source')
    @classmethod
    def validate_source(cls, v):
        if v not in ['google', 'manual']:
            raise ValueError("source must be 'google' or 'manual'")
        return v
    
    @field_validator('google_place_id')
    @classmethod
    def validate_google_place_id(cls, v, info):
        if info.data.get('source') == 'google' and not v:
            raise ValueError("google_place_id is required when source is 'google'")
        return v


class RecommendationCreateRequest(BaseModel):
    """Request model for creating a recommendation"""
    lat: float = Field(..., ge=-90, le=90, description="Latitude")
    lng: float = Field(..., ge=-180, le=180, description="Longitude")
    place: Optional[PlaceInput] = None
    spotify_track_id: str = Field(..., description="Spotify track ID")
    message: Optional[str] = Field(None, max_length=500, description="Short message about the track")
    note: Optional[str] = Field(None, description="Longer note about the track")


class RecommendationResponse(BaseModel):
    """Basic recommendation response (used in list views)"""
    id: int
    lat: float
    lng: float
    distance_meters: Optional[float] = None
    track: TrackResponse
    user: UserResponse
    message: Optional[str] = None
    created_at: datetime
    like_count: int = 0
    liked: bool = False
    
    class Config:
        from_attributes = True


class RecommendationDetailResponse(RecommendationResponse):
    """Detailed recommendation response (used in detail view)"""
    user: UserResponse
    note: Optional[str] = None
    place_name: Optional[str] = None
    address: Optional[str] = None


class RecommendationLikeResponse(BaseModel):
    """Response for like toggle operation"""
    liked: bool
    like_count: int
