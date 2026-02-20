"""
PostGIS utility functions for location-based operations
"""
from typing import Tuple
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from geoalchemy2.functions import ST_DWithin, ST_Distance, ST_MakePoint
from geoalchemy2.elements import WKTElement

from app.models.recommendation import Recommendation


def create_point_wkt(lat: float, lng: float) -> str:
    """
    Create WKT (Well-Known Text) representation of a point
    
    Args:
        lat: Latitude
        lng: Longitude
        
    Returns:
        WKT string for PostGIS
    """
    return f'POINT({lng} {lat})'


def create_point_geom(lat: float, lng: float):
    """
    Create a PostGIS POINT geometry from lat/lng
    
    Args:
        lat: Latitude
        lng: Longitude
        
    Returns:
        SQLAlchemy expression for ST_MakePoint
    """
    return ST_MakePoint(lng, lat, type_='POINT', srid=4326)


async def calculate_distance_meters(
    db: AsyncSession,
    lat1: float,
    lng1: float,
    lat2: float,
    lng2: float
) -> float:
    """
    Calculate distance between two points in meters using PostGIS
    
    Args:
        db: Database session
        lat1, lng1: First point coordinates
        lat2, lng2: Second point coordinates
        
    Returns:
        Distance in meters
    """
    point1 = create_point_geom(lat1, lng1)
    point2 = create_point_geom(lat2, lng2)
    
    # ST_Distance with geography type returns meters
    query = select(
        func.ST_Distance(
            func.ST_Transform(point1, 4326)::func.geography,
            func.ST_Transform(point2, 4326)::func.geography
        )
    )
    
    result = await db.execute(query)
    distance = result.scalar()
    return float(distance) if distance else 0.0


def filter_by_radius(
    query,
    user_lat: float,
    user_lng: float,
    radius_meters: float
):
    """
    Add ST_DWithin filter to query for recommendations within radius
    
    Args:
        query: SQLAlchemy query
        user_lat: User's latitude
        user_lng: User's longitude
        radius_meters: Radius in meters
        
    Returns:
        Modified query with distance filter
    """
    user_point = create_point_geom(user_lat, user_lng)
    
    # Convert to geography for meter-based distance
    return query.where(
        ST_DWithin(
            func.ST_Transform(Recommendation.geom, 4326)::func.geography,
            func.ST_Transform(user_point, 4326)::func.geography,
            radius_meters
        )
    )


def add_distance_column(
    query,
    user_lat: float,
    user_lng: float
):
    """
    Add distance calculation to query result
    
    Args:
        query: SQLAlchemy query
        user_lat: User's latitude
        user_lng: User's longitude
        
    Returns:
        Modified query with distance as additional column
    """
    user_point = create_point_geom(user_lat, user_lng)
    
    distance_expr = func.ST_Distance(
        func.ST_Transform(Recommendation.geom, 4326)::func.geography,
        func.ST_Transform(user_point, 4326)::func.geography
    ).label('distance_meters')
    
    return query.add_columns(distance_expr)


def cluster_by_grid(
    lat: float,
    lng: float,
    grid_size_meters: float = 400
) -> Tuple[float, float]:
    """
    Calculate grid cell center for clustering distant recommendations
    
    Args:
        lat: Latitude
        lng: Longitude
        grid_size_meters: Size of grid cell in meters (default 400m)
        
    Returns:
        Tuple of (grid_lat, grid_lng) representing cluster center
    """
    # Approximate: 1 degree latitude ≈ 111km
    # 1 degree longitude varies by latitude, but we use simple approximation
    lat_per_meter = 1.0 / 111000.0
    lng_per_meter = 1.0 / (111000.0 * abs(0.9))  # Rough approximation
    
    grid_lat_size = grid_size_meters * lat_per_meter
    grid_lng_size = grid_size_meters * lng_per_meter
    
    # Round to grid
    grid_lat = round(lat / grid_lat_size) * grid_lat_size
    grid_lng = round(lng / grid_lng_size) * grid_lng_size
    
    return (grid_lat, grid_lng)
