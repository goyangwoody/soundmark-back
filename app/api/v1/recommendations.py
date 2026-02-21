"""
Recommendation API routes
"""
import logging
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from sqlalchemy.orm import selectinload

from app.database import get_db
from app.models.user import User
from app.models.recommendation import Recommendation
from app.schemas.recommendation import (
    RecommendationCreateRequest,
    RecommendationResponse,
    RecommendationDetailResponse,
    RecommendationReactionRequest,
    RecommendationReactionResponse,
    RecommendationLikeResponse,
    LLMRecommendationResponse,
)
from app.schemas.auth import UserResponse
from app.schemas.track import TrackResponse
from app.services.recommendation import (
    create_recommendation,
    add_or_update_reaction,
    remove_reaction,
    get_reactions,
    get_user_reaction,
    toggle_like,
    get_like_count,
    check_user_liked
)
from app.services.recommendation_v2 import get_llm_recommendations
from app.core.security import get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/recommendations", tags=["Recommendations"])


@router.post("", response_model=RecommendationResponse, status_code=status.HTTP_201_CREATED)
async def create_recommendation_endpoint(
    request: RecommendationCreateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Create a new recommendation
    
    Requires authentication.
    
    Args:
        request: Recommendation creation data
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Created recommendation
    """
    recommendation = await create_recommendation(
        db=db,
        user=current_user,
        lat=request.lat,
        lng=request.lng,
        spotify_track_id=request.spotify_track_id,
        message=request.message,
        place_input=request.place
    )
    
    if not recommendation:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to create recommendation. Track may not exist on Spotify."
        )
    
    # Eagerly load relationships
    await db.refresh(recommendation, ["track", "user"])
    
    # Get reactions and user's reaction
    reactions = await get_reactions(db, recommendation.id)
    user_reaction = await get_user_reaction(db, recommendation.id, current_user.id)
    
    return RecommendationResponse(
        id=recommendation.id,
        lat=recommendation.lat,
        lng=recommendation.lng,
        distance_meters=0,  # Just created, user is at this location
        track=TrackResponse.model_validate(recommendation.track),
        user=UserResponse.model_validate(recommendation.user),
        message=recommendation.message,
        created_at=recommendation.created_at,
        reactions=reactions,
        user_reaction=user_reaction
    )


# ========================================
# LLM-based Recommendation v2
# ========================================

@router.get("/llm", response_model=LLMRecommendationResponse)
async def get_llm_recommendation_endpoint(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    LLM-based personalized recommendation (v2)

    Analyses the current user's recommendation history using an LLM to:
    1. Extract taste keywords from past recommendations
    2. Suggest 10 new tracks the user might like
    3. Find places in our DB where those tracks have been recommended
    4. Extract mood/atmosphere keywords from the messages at those places

    Requires authentication. The user must have at least one recommendation.
    """
    result = await get_llm_recommendations(db, current_user)

    if not result["llm_recommended_tracks"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No recommendations found. Create some recommendations first.",
        )

    return result


@router.get("/{recommendation_id}", response_model=RecommendationDetailResponse)
async def get_recommendation_detail(
    recommendation_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Get recommendation detail
    
    Requires authentication.
    
    Args:
        recommendation_id: Recommendation ID
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Recommendation detail
        
    Raises:
        404: If recommendation not found
    """
    # Get recommendation with relationships
    result = await db.execute(
        select(Recommendation)
        .options(
            selectinload(Recommendation.track),
            selectinload(Recommendation.user),
            selectinload(Recommendation.place)
        )
        .where(
            and_(
                Recommendation.id == recommendation_id,
                Recommendation.deleted_at.is_(None)
            )
        )
    )
    recommendation = result.scalar_one_or_none()
    
    if not recommendation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recommendation not found"
        )
    
    # Get reactions and user's reaction
    reactions = await get_reactions(db, recommendation.id)
    user_reaction = await get_user_reaction(db, recommendation.id, current_user.id)
    
    return RecommendationDetailResponse(
        id=recommendation.id,
        lat=recommendation.lat,
        lng=recommendation.lng,
        track=TrackResponse.model_validate(recommendation.track),
        user=UserResponse.model_validate(recommendation.user),
        message=recommendation.message,
        place_name=recommendation.place.place_name if recommendation.place else None,
        address=recommendation.place.address if recommendation.place else None,
        created_at=recommendation.created_at,
        reactions=reactions,
        user_reaction=user_reaction
    )


@router.put("/{recommendation_id}/reactions", response_model=RecommendationReactionResponse)
async def add_recommendation_reaction(
    recommendation_id: int,
    request: RecommendationReactionRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Add or update emoji reaction to a recommendation
    
    Requires authentication.
    User can have only one reaction per recommendation (will update if exists).
    
    Args:
        recommendation_id: Recommendation ID
        request: Reaction data with emoji
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Updated reactions and user's current reaction
        
    Raises:
        404: If recommendation not found
    """
    # Check if recommendation exists
    result = await db.execute(
        select(Recommendation).where(
            and_(
                Recommendation.id == recommendation_id,
                Recommendation.deleted_at.is_(None)
            )
        )
    )
    recommendation = result.scalar_one_or_none()
    
    if not recommendation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recommendation not found"
        )
    
    # Add or update reaction
    reactions, user_reaction = await add_or_update_reaction(
        db, recommendation_id, current_user.id, request.emoji
    )
    
    return RecommendationReactionResponse(
        reactions=reactions,
        user_reaction=user_reaction
    )


@router.delete("/{recommendation_id}/reactions", response_model=RecommendationReactionResponse)
async def remove_recommendation_reaction(
    recommendation_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Remove user's reaction from a recommendation
    
    Requires authentication.
    
    Args:
        recommendation_id: Recommendation ID
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Updated reactions (user_reaction will be None)
        
    Raises:
        404: If recommendation not found
    """
    # Check if recommendation exists
    result = await db.execute(
        select(Recommendation).where(
            and_(
                Recommendation.id == recommendation_id,
                Recommendation.deleted_at.is_(None)
            )
        )
    )
    recommendation = result.scalar_one_or_none()
    
    if not recommendation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recommendation not found"
        )
    
    # Remove reaction
    reactions = await remove_reaction(db, recommendation_id, current_user.id)
    
    return RecommendationReactionResponse(
        reactions=reactions,
        user_reaction=None
    )


# Legacy endpoint for backward compatibility (deprecated)
@router.put("/{recommendation_id}/like", deprecated=True)
async def toggle_recommendation_like(
    recommendation_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Toggle like on a recommendation (deprecated - use /reactions instead)
    
    If user has already liked, it will unlike.
    If user hasn't liked, it will like.
    
    Requires authentication.
    
    Args:
        recommendation_id: Recommendation ID
        current_user: Authenticated user
        db: Database session
        
    Returns:
        Current like status and count
        
    Raises:
        404: If recommendation not found
    """
    # Check if recommendation exists
    result = await db.execute(
        select(Recommendation).where(
            and_(
                Recommendation.id == recommendation_id,
                Recommendation.deleted_at.is_(None)
            )
        )
    )
    recommendation = result.scalar_one_or_none()
    
    if not recommendation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recommendation not found"
        )
    
    # Toggle like
    liked, like_count = await toggle_like(db, recommendation_id, current_user.id)
    
    return RecommendationLikeResponse(
        liked=liked,
        like_count=like_count
    )
