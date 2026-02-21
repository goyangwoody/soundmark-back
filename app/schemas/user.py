"""
User and Follow related Pydantic schemas
"""
from __future__ import annotations
from typing import Optional, TYPE_CHECKING
from pydantic import BaseModel, Field
from datetime import datetime

if TYPE_CHECKING:
    pass


class UserBase(BaseModel):
    """Base user information"""
    spotify_id: str
    display_name: Optional[str] = None
    email: Optional[str] = None


class UserPublic(BaseModel):
    """Public user information (for followers/following lists)"""
    id: int
    spotify_id: str
    display_name: Optional[str] = None
    profile_image: int = 1
    status_message: str = ""
    
    class Config:
        from_attributes = True


class UserDetail(UserPublic):
    """Detailed user information"""
    email: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True


class FollowStats(BaseModel):
    """User follow statistics"""
    follower_count: int
    following_count: int


class UserWithStats(UserDetail):
    """User with follow statistics and recommendation feed"""
    follower_count: int
    following_count: int
    recommendation_count: int = 0  # Number of recommendations created by this user
    is_following: bool = False  # Whether current user is following this user
    is_followed_by: bool = False  # Whether this user is following current user
    recommendations: list = []  # List of RecommendationSummary


class UserUpdateRequest(BaseModel):
    """Request model for updating user profile"""
    display_name: Optional[str] = Field(None, max_length=255, description="Display name")
    profile_image: Optional[int] = Field(None, ge=1, le=9, description="Profile image number (1-9)")
    status_message: Optional[str] = Field(None, max_length=20, description="Status message (max 20 chars)")


class FollowResponse(BaseModel):
    """Response for follow/unfollow actions"""
    success: bool
    message: str
    follower_count: int


class FollowersResponse(BaseModel):
    """Response for followers list"""
    followers: list[UserPublic]
    total: int


class FollowingResponse(BaseModel):
    """Response for following list"""
    following: list[UserPublic]
    total: int
