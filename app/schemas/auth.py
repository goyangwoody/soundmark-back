"""
Authentication related Pydantic schemas
"""
from typing import Optional
from pydantic import BaseModel, EmailStr
from datetime import datetime


class SpotifyAuthRequest(BaseModel):
    """Request model for Spotify OAuth callback"""
    code: str


class TokenResponse(BaseModel):
    """Response model for authentication token"""
    access_token: str
    token_type: str = "bearer"
    expires_in: int  # seconds


class UserResponse(BaseModel):
    """Response model for user information"""
    id: int
    spotify_id: str
    display_name: Optional[str] = None
    email: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True


class SpotifyLoginResponse(BaseModel):
    """Response model for Spotify login URL"""
    authorization_url: str


class SpotifyCallbackRequest(BaseModel):
    """Request model for Spotify OAuth callback"""
    code: str
    state: Optional[str] = None
