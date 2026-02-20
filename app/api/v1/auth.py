"""
Authentication API routes
"""
import logging
from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.user import User
from app.models.oauth import OAuthAccount
from app.schemas.auth import (
    SpotifyLoginResponse,
    SpotifyCallbackRequest,
    TokenResponse,
    UserResponse
)
from app.services.spotify import spotify_service
from app.core.security import create_access_token, get_current_user
from app.core.config import settings

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.get("/spotify/login", response_model=SpotifyLoginResponse)
async def spotify_login():
    """
    Get Spotify authorization URL for user to login
    
    Returns:
        URL to redirect user to Spotify login page
    """
    authorization_url = spotify_service.get_authorization_url()
    return SpotifyLoginResponse(authorization_url=authorization_url)


@router.post("/spotify/callback", response_model=TokenResponse)
async def spotify_callback(
    code: str = Query(..., description="Authorization code from Spotify"),
    db: AsyncSession = Depends(get_db)
):
    """
    Handle Spotify OAuth callback
    
    Exchange authorization code for tokens, create or update user,
    and return our service JWT token
    
    Args:
        code: Authorization code from Spotify OAuth
        db: Database session
        
    Returns:
        JWT access token for our service
    """
    # Exchange code for Spotify tokens
    token_info = spotify_service.exchange_code_for_token(code)
    if not token_info:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to exchange authorization code"
        )
    
    access_token = token_info.get("access_token")
    refresh_token = token_info.get("refresh_token")
    expires_in = token_info.get("expires_in", 3600)
    
    # Get user profile from Spotify
    user_profile = spotify_service.get_user_profile(access_token)
    if not user_profile:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to get user profile from Spotify"
        )
    
    spotify_id = user_profile["spotify_id"]
    
    # Check if user already exists
    result = await db.execute(
        select(User).where(User.spotify_id == spotify_id)
    )
    user = result.scalar_one_or_none()
    
    if user:
        # Update existing user
        user.display_name = user_profile.get("display_name")
        user.email = user_profile.get("email")
        user.profile_image_url = user_profile.get("profile_image_url")
        user.updated_at = datetime.utcnow()
        
        # Update OAuth tokens
        oauth_result = await db.execute(
            select(OAuthAccount).where(
                OAuthAccount.user_id == user.id,
                OAuthAccount.provider == "spotify"
            )
        )
        oauth_account = oauth_result.scalar_one_or_none()
        
        if oauth_account:
            oauth_account.access_token = access_token
            oauth_account.refresh_token = refresh_token
            oauth_account.expires_at = datetime.utcnow() + timedelta(seconds=expires_in)
            oauth_account.updated_at = datetime.utcnow()
        else:
            # Create OAuth account if it doesn't exist
            oauth_account = OAuthAccount(
                user_id=user.id,
                provider="spotify",
                access_token=access_token,
                refresh_token=refresh_token,
                expires_at=datetime.utcnow() + timedelta(seconds=expires_in)
            )
            db.add(oauth_account)
    else:
        # Create new user
        user = User(
            spotify_id=spotify_id,
            display_name=user_profile.get("display_name"),
            email=user_profile.get("email"),
            profile_image_url=user_profile.get("profile_image_url")
        )
        db.add(user)
        await db.flush()  # Flush to get user.id
        
        # Create OAuth account
        oauth_account = OAuthAccount(
            user_id=user.id,
            provider="spotify",
            access_token=access_token,
            refresh_token=refresh_token,
            expires_at=datetime.utcnow() + timedelta(seconds=expires_in)
        )
        db.add(oauth_account)
    
    await db.commit()
    await db.refresh(user)
    
    # Create our service JWT token
    jwt_token = create_access_token(data={"sub": str(user.id)})
    
    return TokenResponse(
        access_token=jwt_token,
        token_type="bearer",
        expires_in=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS * 24 * 3600  # Convert days to seconds
    )


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(
    current_user: User = Depends(get_current_user)
):
    """
    Get current authenticated user information
    
    Requires:
        Valid JWT token in Authorization header
        
    Returns:
        Current user information
    """
    return UserResponse.model_validate(current_user)


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Refresh JWT token
    
    This endpoint can be used to get a new JWT token.
    In the future, this could also refresh the Spotify token if needed.
    
    Requires:
        Valid JWT token in Authorization header
        
    Returns:
        New JWT access token
    """
    # Create new JWT token
    jwt_token = create_access_token(data={"sub": str(current_user.id)})
    
    return TokenResponse(
        access_token=jwt_token,
        token_type="bearer",
        expires_in=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS * 24 * 3600
    )
