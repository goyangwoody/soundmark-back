"""
Track related Pydantic schemas
"""
from typing import Optional
from pydantic import BaseModel
from datetime import datetime


class TrackBase(BaseModel):
    """Base track information"""
    spotify_track_id: str
    title: str
    artist: str
    album: Optional[str] = None
    album_cover_url: Optional[str] = None
    track_url: Optional[str] = None
    preview_url: Optional[str] = None


class TrackResponse(TrackBase):
    """Track response model"""
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True


class TrackSearchResult(BaseModel):
    """Track search result from Spotify"""
    spotify_track_id: str
    title: str
    artist: str
    album: str
    album_cover_url: Optional[str] = None
    track_url: str
    preview_url: Optional[str] = None
