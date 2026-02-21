"""
Recommendation related Pydantic schemas
"""
from typing import Optional, Dict
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


class RecommendationSummary(BaseModel):
    """Lightweight recommendation summary (used in profile feeds)"""
    id: int
    track_title: str
    track_artist: str
    album_cover_url: Optional[str] = None
    message: Optional[str] = None
    place_name: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


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
    reactions: Dict[str, int] = Field(default_factory=dict, description="Emoji reactions with counts")
    user_reaction: Optional[str] = Field(None, description="Current user's reaction emoji")
    
    class Config:
        from_attributes = True


class RecommendationDetailResponse(RecommendationResponse):
    """Detailed recommendation response (used in detail view)"""
    user: UserResponse
    place_name: Optional[str] = None
    address: Optional[str] = None


class RecommendationReactionRequest(BaseModel):
    """Request model for adding/updating emoji reaction"""
    emoji: str = Field(..., min_length=1, max_length=50, description="Emoji reaction (unicode or name)")


class RecommendationReactionResponse(BaseModel):
    """Response for reaction operation"""
    reactions: Dict[str, int] = Field(..., description="Updated emoji reactions with counts")
    user_reaction: Optional[str] = Field(None, description="Current user's reaction emoji")


class RecommendationLikeResponse(BaseModel):
    """Response for legacy like toggle operation (deprecated)"""
    liked: bool
    like_count: int


# ========================================
# Place Recommendation (Genre-based)
# ========================================

class TrackWithGenres(BaseModel):
    """Recently played track with artist genres"""
    spotify_track_id: str
    title: str
    artist: str
    album: Optional[str] = None
    album_cover_url: Optional[str] = None
    track_url: Optional[str] = None
    genres: list[str]


class PlaceInfo(BaseModel):
    """Place information for genre-based recommendation"""
    place_id: int
    place_name: str
    address: Optional[str] = None
    lat: float
    lng: float


class TrackPlaceCard(BaseModel):
    """A single recommendation card: track + matched genre + recommended place"""
    track: TrackWithGenres
    matched_genre: Optional[str] = Field(None, description="The genre used to find the recommended place")
    place: Optional[PlaceInfo] = Field(None, description="Recommended place for this track's genre (null if no match)")
    recommendation_count: int = Field(0, description="Number of recommendations of that genre at the place")


class PlaceRecommendationResponse(BaseModel):
    """Response for genre-based place recommendation — one card per track"""
    cards: list[TrackPlaceCard] = Field(..., description="One card per recently played track")


# ========================================
# LLM-based Recommendation (v2)
# ========================================

class LLMRecommendedTrack(BaseModel):
    """A track recommended by the LLM"""
    title: str
    artist: str


class MatchedRecommendation(BaseModel):
    """A recommendation from our DB that matches an LLM-recommended track"""
    recommendation_id: int
    track: TrackResponse
    message: Optional[str] = None
    place_name: Optional[str] = None
    address: Optional[str] = None
    lat: float
    lng: float
    created_by: UserResponse


class LLMPlaceResult(BaseModel):
    """A place where LLM-recommended tracks have been planted, with extracted keywords"""
    llm_track: LLMRecommendedTrack = Field(..., description="The track LLM recommended")
    matched_recommendations: list[MatchedRecommendation] = Field(
        ..., description="Recommendations in our DB matching this track"
    )
    place_keywords: list[str] = Field(
        default_factory=list,
        description="Keywords extracted from recommendation messages at these places"
    )


class LLMRecommendationResponse(BaseModel):
    """Full response for LLM-based recommendation (v2)"""
    user_taste_keywords: list[str] = Field(
        ..., description="Keywords describing the user's music taste"
    )
    llm_recommended_tracks: list[LLMRecommendedTrack] = Field(
        ..., description="All 10 tracks recommended by the LLM"
    )
    results: list[LLMPlaceResult] = Field(
        ..., description="Matched results with places and keywords (only tracks found in DB)"
    )
    unmatched_tracks: list[LLMRecommendedTrack] = Field(
        default_factory=list,
        description="LLM-recommended tracks not found in our DB"
    )
