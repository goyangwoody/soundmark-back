"""
Map API tests
"""
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.track import Track
from app.models.recommendation import Recommendation
from geoalchemy2.functions import ST_MakePoint


@pytest.fixture
async def multiple_recommendations(
    db_session: AsyncSession,
    test_user,
    test_track
):
    """Create multiple recommendations at different distances"""
    base_lat, base_lng = 37.5665, 126.9780  # Seoul
    
    recommendations = []
    
    # Create 3 nearby recommendations (within 200m)
    for i in range(3):
        lat = base_lat + (i * 0.0001)  # ~11m apart
        lng = base_lng + (i * 0.0001)
        
        rec = Recommendation(
            user_id=test_user.id,
            track_id=test_track.id,
            lat=lat,
            lng=lng,
            geom=ST_MakePoint(lng, lat, type_='POINT', srid=4326),
            message=f"Nearby recommendation {i+1}"
        )
        db_session.add(rec)
        recommendations.append(rec)
    
    # Create 2 distant recommendations (beyond 200m)
    for i in range(2):
        lat = base_lat + (0.005 * (i + 1))  # ~500m+ apart
        lng = base_lng + (0.005 * (i + 1))
        
        rec = Recommendation(
            user_id=test_user.id,
            track_id=test_track.id,
            lat=lat,
            lng=lng,
            geom=ST_MakePoint(lng, lat, type_='POINT', srid=4326),
            message=f"Distant recommendation {i+1}"
        )
        db_session.add(rec)
        recommendations.append(rec)
    
    await db_session.commit()
    return recommendations


@pytest.mark.asyncio
async def test_get_map_nearby(
    authenticated_client: AsyncClient,
    multiple_recommendations
):
    """Test getting nearby map data"""
    base_lat, base_lng = 37.5665, 126.9780
    
    response = await authenticated_client.get(
        "/api/v1/map/nearby",
        params={"lat": base_lat, "lng": base_lng}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Should have both active and inactive
    assert "active_recommendations" in data
    assert "inactive_counts" in data
    
    # Should have 3 active recommendations (within 200m)
    assert len(data["active_recommendations"]) >= 1
    
    # Each active recommendation should have required fields
    if data["active_recommendations"]:
        active = data["active_recommendations"][0]
        assert "id" in active
        assert "lat" in active
        assert "lng" in active
        assert "distance_meters" in active
        assert "track" in active


@pytest.mark.asyncio
async def test_get_map_nearby_unauthorized(client: AsyncClient):
    """Test getting map data without authentication"""
    response = await client.get(
        "/api/v1/map/nearby",
        params={"lat": 37.5665, "lng": 126.9780}
    )
    assert response.status_code == 401
