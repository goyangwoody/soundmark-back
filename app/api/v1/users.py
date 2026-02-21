"""
Users and Follow API routes
"""
import logging
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_, or_
from sqlalchemy.orm import selectinload

from app.database import get_db
from app.models.user import User
from app.models.follow import Follow
from app.models.recommendation import Recommendation
from app.models.track import Track
from app.models.place import Place
from app.schemas.user import (
    UserPublic,
    UserDetail,
    UserWithStats,
    UserUpdateRequest,
    FollowResponse,
    FollowersResponse,
    FollowingResponse
)
from app.schemas.recommendation import RecommendationSummary
from app.schemas.track import RecentlyPlayedResponse, RecentlyPlayedTrack
from app.models.oauth import OAuthAccount
from app.services.spotify import spotify_service
from app.core.security import get_current_user, get_current_user_optional

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/users", tags=["Users & Follow"])


@router.get("/me", response_model=UserWithStats)
async def get_my_profile(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get current user's profile with statistics
    
    Returns:
        Current user profile with follower/following counts and recommendation count
    """
    # Get follower count
    follower_count_query = select(func.count(Follow.id)).where(Follow.following_id == current_user.id)
    follower_count_result = await db.execute(follower_count_query)
    follower_count = follower_count_result.scalar() or 0
    
    # Get following count
    following_count_query = select(func.count(Follow.id)).where(Follow.follower_id == current_user.id)
    following_count_result = await db.execute(following_count_query)
    following_count = following_count_result.scalar() or 0
    
    # Get recommendations with track and place info
    recommendations_query = (
        select(Recommendation, Track, Place)
        .join(Track, Recommendation.track_id == Track.id)
        .outerjoin(Place, Recommendation.place_id == Place.id)
        .where(
            Recommendation.user_id == current_user.id,
            Recommendation.deleted_at.is_(None)
        )
        .order_by(Recommendation.created_at.desc())
    )
    recommendations_result = await db.execute(recommendations_query)
    recommendations_rows = recommendations_result.all()
    recommendation_count = len(recommendations_rows)
    
    recommendations = [
        RecommendationSummary(
            id=rec.id,
            track_title=track.title,
            track_artist=track.artist,
            album_cover_url=track.album_cover_url,
            message=rec.message,
            place_name=place.place_name if place else None,
            created_at=rec.created_at
        )
        for rec, track, place in recommendations_rows
    ]
    
    return UserWithStats(
        id=current_user.id,
        spotify_id=current_user.spotify_id,
        display_name=current_user.display_name,
        email=current_user.email,
        profile_image=current_user.profile_image,
        status_message=current_user.status_message,
        created_at=current_user.created_at,
        follower_count=follower_count,
        following_count=following_count,
        recommendation_count=recommendation_count,
        is_following=False,
        is_followed_by=False,
        recommendations=recommendations
    )


@router.patch("/me", response_model=UserPublic)
async def update_my_profile(
    request: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Update current user's profile
    
    Only provided (non-null) fields will be updated.
    
    Args:
        request: Fields to update (display_name, profile_image, status_message)
    
    Returns:
        Updated user profile
    """
    update_data = request.model_dump(exclude_unset=True)
    
    if not update_data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )
    
    for field, value in update_data.items():
        setattr(current_user, field, value)
    
    from datetime import datetime
    current_user.updated_at = datetime.utcnow()
    
    await db.commit()
    await db.refresh(current_user)
    
    logger.info(f"User {current_user.id} updated profile: {list(update_data.keys())}")
    
    return current_user


@router.get("/me/recently-played", response_model=RecentlyPlayedResponse)
async def get_my_recently_played(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get current user's 3 most recently played tracks from Spotify
    
    Requires the user to have a linked Spotify account with a valid access token.
    The Spotify access token must have the `user-read-recently-played` scope.
    
    Returns:
        List of 3 most recently played tracks with metadata and played_at timestamp
    """
    # Get user's Spotify OAuth account
    oauth_result = await db.execute(
        select(OAuthAccount).where(
            OAuthAccount.user_id == current_user.id,
            OAuthAccount.provider == "spotify"
        )
    )
    oauth_account = oauth_result.scalar_one_or_none()
    
    if not oauth_account:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Spotify account not linked"
        )
    
    # Check if token is expired and refresh if needed
    from datetime import datetime, timedelta
    if oauth_account.expires_at and oauth_account.expires_at < datetime.utcnow():
        if not oauth_account.refresh_token:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Spotify token expired and no refresh token available"
            )
        
        token_info = spotify_service.refresh_access_token(oauth_account.refresh_token)
        if not token_info:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Failed to refresh Spotify token"
            )
        
        oauth_account.access_token = token_info["access_token"]
        if token_info.get("refresh_token"):
            oauth_account.refresh_token = token_info["refresh_token"]
        oauth_account.expires_at = datetime.utcnow() + timedelta(
            seconds=token_info.get("expires_in", 3600)
        )
        oauth_account.updated_at = datetime.utcnow()
        await db.commit()
    
    # Fetch recently played tracks from Spotify
    tracks = spotify_service.get_recently_played(oauth_account.access_token, limit=3)
    
    if tracks is None:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Failed to fetch recently played tracks from Spotify"
        )
    
    return RecentlyPlayedResponse(
        tracks=[
            RecentlyPlayedTrack(**track)
            for track in tracks
        ],
        total=len(tracks)
    )


@router.get("/{user_id}", response_model=UserWithStats)
async def get_user_profile(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user_optional)
):
    """
    Get user profile with follow statistics
    
    Args:
        user_id: ID of the user to retrieve
        current_user: Currently authenticated user (optional)
    
    Returns:
        User profile with follower/following counts and relationship status
    """
    # Get user
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Get follower count
    follower_count_query = select(func.count(Follow.id)).where(Follow.following_id == user_id)
    follower_count_result = await db.execute(follower_count_query)
    follower_count = follower_count_result.scalar() or 0
    
    # Get following count
    following_count_query = select(func.count(Follow.id)).where(Follow.follower_id == user_id)
    following_count_result = await db.execute(following_count_query)
    following_count = following_count_result.scalar() or 0
    
    # Get recommendations with track and place info
    recommendations_query = (
        select(Recommendation, Track, Place)
        .join(Track, Recommendation.track_id == Track.id)
        .outerjoin(Place, Recommendation.place_id == Place.id)
        .where(
            Recommendation.user_id == user_id,
            Recommendation.deleted_at.is_(None)
        )
        .order_by(Recommendation.created_at.desc())
    )
    recommendations_result = await db.execute(recommendations_query)
    recommendations_rows = recommendations_result.all()
    recommendation_count = len(recommendations_rows)
    
    recommendations = [
        RecommendationSummary(
            id=rec.id,
            track_title=track.title,
            track_artist=track.artist,
            album_cover_url=track.album_cover_url,
            message=rec.message,
            place_name=place.place_name if place else None,
            created_at=rec.created_at
        )
        for rec, track, place in recommendations_rows
    ]
    
    # Check relationship with current user
    is_following = False
    is_followed_by = False
    
    if current_user and current_user.id != user_id:
        # Check if current user is following this user
        is_following_query = select(Follow).where(
            and_(
                Follow.follower_id == current_user.id,
                Follow.following_id == user_id
            )
        )
        is_following_result = await db.execute(is_following_query)
        is_following = is_following_result.scalar_one_or_none() is not None
        
        # Check if this user is following current user
        is_followed_by_query = select(Follow).where(
            and_(
                Follow.follower_id == user_id,
                Follow.following_id == current_user.id
            )
        )
        is_followed_by_result = await db.execute(is_followed_by_query)
        is_followed_by = is_followed_by_result.scalar_one_or_none() is not None
    
    return UserWithStats(
        id=user.id,
        spotify_id=user.spotify_id,
        display_name=user.display_name,
        email=user.email,
        profile_image=user.profile_image,
        status_message=user.status_message,
        created_at=user.created_at,
        follower_count=follower_count,
        following_count=following_count,
        recommendation_count=recommendation_count,
        is_following=is_following,
        is_followed_by=is_followed_by,
        recommendations=recommendations
    )


@router.post("/{user_id}/follow", response_model=FollowResponse)
async def follow_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Follow a user
    
    Args:
        user_id: ID of the user to follow
        current_user: Currently authenticated user
    
    Returns:
        Success status and updated follower count
    """
    # Can't follow yourself
    if current_user.id == user_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot follow yourself"
        )
    
    # Check if target user exists
    result = await db.execute(select(User).where(User.id == user_id))
    target_user = result.scalar_one_or_none()
    
    if not target_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Check if already following
    existing_follow_query = select(Follow).where(
        and_(
            Follow.follower_id == current_user.id,
            Follow.following_id == user_id
        )
    )
    existing_follow_result = await db.execute(existing_follow_query)
    existing_follow = existing_follow_result.scalar_one_or_none()
    
    if existing_follow:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Already following this user"
        )
    
    # Create follow relationship
    new_follow = Follow(
        follower_id=current_user.id,
        following_id=user_id
    )
    db.add(new_follow)
    await db.commit()
    
    # Get updated follower count
    follower_count_query = select(func.count(Follow.id)).where(Follow.following_id == user_id)
    follower_count_result = await db.execute(follower_count_query)
    follower_count = follower_count_result.scalar() or 0
    
    logger.info(f"User {current_user.id} followed user {user_id}")
    
    return FollowResponse(
        success=True,
        message="Successfully followed user",
        follower_count=follower_count
    )


@router.delete("/{user_id}/follow", response_model=FollowResponse)
async def unfollow_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Unfollow a user
    
    Args:
        user_id: ID of the user to unfollow
        current_user: Currently authenticated user
    
    Returns:
        Success status and updated follower count
    """
    # Check if following
    follow_query = select(Follow).where(
        and_(
            Follow.follower_id == current_user.id,
            Follow.following_id == user_id
        )
    )
    follow_result = await db.execute(follow_query)
    follow = follow_result.scalar_one_or_none()
    
    if not follow:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Not following this user"
        )
    
    # Delete follow relationship
    await db.delete(follow)
    await db.commit()
    
    # Get updated follower count
    follower_count_query = select(func.count(Follow.id)).where(Follow.following_id == user_id)
    follower_count_result = await db.execute(follower_count_query)
    follower_count = follower_count_result.scalar() or 0
    
    logger.info(f"User {current_user.id} unfollowed user {user_id}")
    
    return FollowResponse(
        success=True,
        message="Successfully unfollowed user",
        follower_count=follower_count
    )


@router.get("/{user_id}/followers", response_model=FollowersResponse)
async def get_user_followers(
    user_id: int,
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: AsyncSession = Depends(get_db)
):
    """
    Get list of users following this user
    
    Args:
        user_id: ID of the user
        limit: Maximum number of results (1-100)
        offset: Number of results to skip
    
    Returns:
        List of followers and total count
    """
    # Check if user exists
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Get followers
    followers_query = (
        select(User)
        .join(Follow, Follow.follower_id == User.id)
        .where(Follow.following_id == user_id)
        .order_by(Follow.created_at.desc())
        .limit(limit)
        .offset(offset)
    )
    followers_result = await db.execute(followers_query)
    followers = followers_result.scalars().all()
    
    # Get total count
    total_query = select(func.count(Follow.id)).where(Follow.following_id == user_id)
    total_result = await db.execute(total_query)
    total = total_result.scalar() or 0
    
    return FollowersResponse(
        followers=[
            UserPublic(
                id=follower.id,
                spotify_id=follower.spotify_id,
                display_name=follower.display_name
            )
            for follower in followers
        ],
        total=total
    )


@router.get("/{user_id}/following", response_model=FollowingResponse)
async def get_user_following(
    user_id: int,
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: AsyncSession = Depends(get_db)
):
    """
    Get list of users this user is following
    
    Args:
        user_id: ID of the user
        limit: Maximum number of results (1-100)
        offset: Number of results to skip
    
    Returns:
        List of users being followed and total count
    """
    # Check if user exists
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Get following
    following_query = (
        select(User)
        .join(Follow, Follow.following_id == User.id)
        .where(Follow.follower_id == user_id)
        .order_by(Follow.created_at.desc())
        .limit(limit)
        .offset(offset)
    )
    following_result = await db.execute(following_query)
    following = following_result.scalars().all()
    
    # Get total count
    total_query = select(func.count(Follow.id)).where(Follow.follower_id == user_id)
    total_result = await db.execute(total_query)
    total = total_result.scalar() or 0
    
    return FollowingResponse(
        following=[
            UserPublic(
                id=user.id,
                spotify_id=user.spotify_id,
                display_name=user.display_name
            )
            for user in following
        ],
        total=total
    )
