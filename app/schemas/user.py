"""
User and Follow related Pydantic schemas
"""
from typing import Optional
from pydantic import BaseModel
from datetime import datetime


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
    """User with follow statistics"""
    follower_count: int
    following_count: int
    is_following: bool = False  # Whether current user is following this user
    is_followed_by: bool = False  # Whether this user is following current user


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
