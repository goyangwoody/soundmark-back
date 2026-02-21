"""
Authentication API routes
"""
import logging
import random
from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import get_db
from app.models.user import User
from app.models.oauth import OAuthAccount
from app.models.refresh_token import RefreshToken
from app.schemas.auth import (
    SpotifyLoginResponse,
    SpotifyCallbackRequest,
    SpotifyVerifyRequest,
    RefreshTokenRequest,
    TokenResponse,
    UserResponse
)
from app.services.spotify import spotify_service
from app.core.security import (
    create_access_token,
    create_refresh_token,
    get_refresh_token_expire_time,
    get_current_user
)
from app.core.config import settings

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.get("/spotify/login", response_model=SpotifyLoginResponse, deprecated=True)
async def spotify_login():
    """
    Get Spotify authorization URL for user to login
    
    **DEPRECATED**: Clients should handle Spotify OAuth directly with PKCE.
    Use /spotify/verify endpoint instead.
    
    Returns:
        URL to redirect user to Spotify login page
    """
    authorization_url = spotify_service.get_authorization_url()
    return SpotifyLoginResponse(authorization_url=authorization_url)


@router.post("/spotify/callback", response_model=TokenResponse, deprecated=True)
async def spotify_callback(
    code: str = Query(..., description="Authorization code from Spotify"),
    db: AsyncSession = Depends(get_db)
):
    """
    Handle Spotify OAuth callback
    
    **DEPRECATED**: Clients should handle Spotify OAuth directly with PKCE.
    Use /spotify/verify endpoint instead.
    
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
            profile_image=random.randint(1, 9),
            status_message=""
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
    
    # Create refresh token
    refresh_token_str = create_refresh_token()
    refresh_token_db = RefreshToken(
        token=refresh_token_str,
        user_id=user.id,
        expires_at=get_refresh_token_expire_time()
    )
    db.add(refresh_token_db)
    await db.commit()
    
    return TokenResponse(
        access_token=jwt_token,
        refresh_token=refresh_token_str,
        token_type="bearer",
        expires_in=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS * 24 * 3600  # Convert days to seconds
    )


@router.post("/spotify/verify", response_model=TokenResponse)
async def verify_spotify_token(
    request: SpotifyVerifyRequest,
    db: AsyncSession = Depends(get_db)
):
    """
    Verify Spotify access token and issue JWT
    
    Client handles Spotify OAuth (with PKCE) and sends tokens to backend.
    Backend verifies the token, creates/updates user, and issues JWT.
    
    **Flow**:
    1. Client: Spotify OAuth with PKCE
    2. Client: Receives access_token + refresh_token from Spotify
    3. Client → Backend: Send tokens to this endpoint
    4. Backend: Verify token and issue JWT
    
    Args:
        request: Spotify tokens (access_token, refresh_token, expires_in)
        db: Database session
        
    Returns:
        JWT access token for our service
        
    Raises:
        401: If Spotify token is invalid
    """
    # Verify Spotify token by fetching user profile
    user_profile = spotify_service.get_user_profile(request.spotify_access_token)
    if not user_profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Spotify access token"
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
            oauth_account.access_token = request.spotify_access_token
            oauth_account.refresh_token = request.spotify_refresh_token
            oauth_account.expires_at = datetime.utcnow() + timedelta(seconds=request.expires_in)
            oauth_account.updated_at = datetime.utcnow()
        else:
            # Create OAuth account if it doesn't exist
            oauth_account = OAuthAccount(
                user_id=user.id,
                provider="spotify",
                access_token=request.spotify_access_token,
                refresh_token=request.spotify_refresh_token,
                expires_at=datetime.utcnow() + timedelta(seconds=request.expires_in)
            )
            db.add(oauth_account)
    else:
        # Create new user
        user = User(
            spotify_id=spotify_id,
            display_name=user_profile.get("display_name"),
            email=user_profile.get("email"),
            profile_image=random.randint(1, 9),
            status_message=""
        )
        db.add(user)
        await db.flush()  # Flush to get user.id
        
        # Create OAuth account
        oauth_account = OAuthAccount(
            user_id=user.id,
            provider="spotify",
            access_token=request.spotify_access_token,
            refresh_token=request.spotify_refresh_token,
            expires_at=datetime.utcnow() + timedelta(seconds=request.expires_in)
        )
        db.add(oauth_account)
    
    await db.commit()
    await db.refresh(user)
    
    # Create our service JWT token
    jwt_token = create_access_token(data={"sub": str(user.id)})
    
    # Create refresh token
    refresh_token_str = create_refresh_token()
    refresh_token_db = RefreshToken(
        token=refresh_token_str,
        user_id=user.id,
        expires_at=get_refresh_token_expire_time()
    )
    db.add(refresh_token_db)
    await db.commit()
    
    logger.info(f"User {user.id} ({spotify_id}) authenticated via Spotify token verification")
    
    return TokenResponse(
        access_token=jwt_token,
        refresh_token=refresh_token_str,
        token_type="bearer",
        expires_in=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS * 24 * 3600
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
    request: RefreshTokenRequest,
    db: AsyncSession = Depends(get_db)
):
    """
    Refresh JWT access token using refresh token
    
    Client sends refresh token to get a new access token + new refresh token.
    Old refresh token is revoked after successful refresh.
    
    Args:
        request: Refresh token request with refresh_token
        db: Database session
        
    Returns:
        New access token and new refresh token
        
    Raises:
        401: If refresh token is invalid, expired, or revoked
    """
    # Find refresh token in database
    result = await db.execute(
        select(RefreshToken).where(
            RefreshToken.token == request.refresh_token,
            RefreshToken.revoked == False
        )
    )
    refresh_token_db = result.scalar_one_or_none()
    
    if not refresh_token_db:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token"
        )
    
    # Check if token is expired
    if refresh_token_db.expires_at < datetime.utcnow():
        # Revoke expired token
        refresh_token_db.revoked = True
        await db.commit()
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Refresh token expired"
        )
    
    # Get user
    result = await db.execute(
        select(User).where(User.id == refresh_token_db.user_id)
    )
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found"
        )
    
    # Revoke old refresh token
    refresh_token_db.revoked = True
    
    # Create new JWT access token
    jwt_token = create_access_token(data={"sub": str(user.id)})
    
    # Create new refresh token
    new_refresh_token_str = create_refresh_token()
    new_refresh_token_db = RefreshToken(
        token=new_refresh_token_str,
        user_id=user.id,
        expires_at=get_refresh_token_expire_time()
    )
    db.add(new_refresh_token_db)
    await db.commit()
    
    logger.info(f"User {user.id} refreshed token")
    
    return TokenResponse(
        access_token=jwt_token,
        refresh_token=new_refresh_token_str,
        token_type="bearer",
        expires_in=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS * 24 * 3600
    )
