"""
Location and clustering service
"""
import logging
from typing import List, Dict, Tuple
from collections import defaultdict
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, func
from sqlalchemy.orm import selectinload

from app.models.recommendation import Recommendation
from app.core.database_utils import (
    filter_by_radius,
    add_distance_column,
    cluster_by_grid
)

logger = logging.getLogger(__name__)


async def get_nearby_recommendations(
    db: AsyncSession,
    user_lat: float,
    user_lng: float,
    radius_meters: float = 200
) -> List[Tuple[Recommendation, float]]:
    """
    Get recommendations within specified radius with distances
    
    Args:
        db: Database session
        user_lat: User's latitude
        user_lng: User's longitude
        radius_meters: Search radius in meters
        
    Returns:
        List of (Recommendation, distance_meters) tuples
    """
    # Build query with relationships
    query = select(Recommendation).options(
        selectinload(Recommendation.track),
        selectinload(Recommendation.user),
        selectinload(Recommendation.place)
    ).where(
        Recommendation.deleted_at.is_(None)
    )
    
    # Apply distance filter
    query = filter_by_radius(query, user_lat, user_lng, radius_meters)
    
    # Add distance calculation
    query = add_distance_column(query, user_lat, user_lng)
    
    # Order by distance
    query = query.order_by('distance_meters')
    
    # Execute query
    result = await db.execute(query)
    rows = result.all()
    
    # Extract recommendations and distances
    recommendations_with_distances = [
        (row[0], row[1]) for row in rows
    ]
    
    return recommendations_with_distances


async def get_distant_recommendations(
    db: AsyncSession,
    user_lat: float,
    user_lng: float,
    min_radius_meters: float = 200,
    max_radius_meters: float = 10000  # 10km max for performance
) -> List[Recommendation]:
    """
    Get recommendations beyond min_radius but within max_radius
    
    Args:
        db: Database session
        user_lat: User's latitude
        user_lng: User's longitude
        min_radius_meters: Minimum radius (exclude closer ones)
        max_radius_meters: Maximum radius for search
        
    Returns:
        List of Recommendation objects
    """
    # First get all within max radius
    query = select(Recommendation).where(
        Recommendation.deleted_at.is_(None)
    )
    query = filter_by_radius(query, user_lat, user_lng, max_radius_meters)
    
    result = await db.execute(query)
    all_recommendations = result.scalars().all()
    
    # Filter out those within min_radius (we'll do this in Python for simplicity)
    # In production, you might want to use PostGIS query for this
    distant_recommendations = []
    
    for rec in all_recommendations:
        # Calculate approximate distance (Note: this is a simplification)
        # In production, use proper PostGIS distance calculation
        lat_diff = abs(rec.lat - user_lat)
        lng_diff = abs(rec.lng - user_lng)
        
        # Rough distance check (not accurate but fast)
        # 1 degree ≈ 111km
        approx_distance = ((lat_diff ** 2 + lng_diff ** 2) ** 0.5) * 111000
        
        if approx_distance > min_radius_meters:
            distant_recommendations.append(rec)
    
    return distant_recommendations


def cluster_recommendations_by_grid(
    recommendations: List[Recommendation],
    grid_size_meters: float = 400
) -> List[Dict[str, any]]:
    """
    Cluster recommendations by grid cells
    
    Args:
        recommendations: List of Recommendation objects
        grid_size_meters: Size of grid cells in meters
        
    Returns:
        List of cluster dicts with lat, lng, count
    """
    # Group recommendations by grid cell
    grid_counts: Dict[Tuple[float, float], int] = defaultdict(int)
    
    for rec in recommendations:
        grid_center = cluster_by_grid(rec.lat, rec.lng, grid_size_meters)
        grid_counts[grid_center] += 1
    
    # Convert to list of dicts
    clusters = [
        {
            "lat": lat,
            "lng": lng,
            "count": count
        }
        for (lat, lng), count in grid_counts.items()
    ]
    
    return clusters


async def get_map_data(
    db: AsyncSession,
    user_lat: float,
    user_lng: float,
    active_radius_meters: float = 200,
    grid_size_meters: float = 400
) -> Tuple[List[Tuple[Recommendation, float]], List[Dict[str, any]]]:
    """
    Get map data with active recommendations and inactive clusters
    
    Args:
        db: Database session
        user_lat: User's latitude
        user_lng: User's longitude
        active_radius_meters: Radius for active recommendations (default 200m)
        grid_size_meters: Grid size for clustering distant recommendations (default 400m)
        
    Returns:
        Tuple of (active_recommendations_with_distances, inactive_clusters)
    """
    # Get active recommendations (within radius)
    active_recommendations = await get_nearby_recommendations(
        db, user_lat, user_lng, active_radius_meters
    )
    
    # Get distant recommendations (beyond radius)
    distant_recommendations = await get_distant_recommendations(
        db, user_lat, user_lng, min_radius_meters=active_radius_meters
    )
    
    # Cluster distant recommendations
    inactive_clusters = cluster_recommendations_by_grid(
        distant_recommendations, grid_size_meters
    )
    
    return (active_recommendations, inactive_clusters)
