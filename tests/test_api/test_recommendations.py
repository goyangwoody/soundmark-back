"""
Recommendation API tests
"""
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.track import Track
from app.models.recommendation import Recommendation
from geoalchemy2.functions import ST_MakePoint, ST_SetSRID


@pytest.fixture
async def test_recommendation(
    db_session: AsyncSession,
    test_user,
    test_track
) -> Recommendation:
    """Create a test recommendation"""
    lat, lng = 37.5665, 126.9780  # Seoul coordinates
    
    recommendation = Recommendation(
        user_id=test_user.id,
        track_id=test_track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326),
        message="Great song for this location!"
    )
    db_session.add(recommendation)
    await db_session.commit()
    await db_session.refresh(recommendation)
    return recommendation


@pytest.mark.asyncio
async def test_get_recommendation_detail_within_range(
    authenticated_client: AsyncClient,
    test_recommendation
):
    """Test getting recommendation detail when within 200m"""
    # Use same coordinates as recommendation (0m distance)
    response = await authenticated_client.get(
        f"/api/v1/recommendations/{test_recommendation.id}",
        params={
            "lat": test_recommendation.lat,
            "lng": test_recommendation.lng
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == test_recommendation.id
    assert "track" in data
    assert "user" in data


@pytest.mark.asyncio
async def test_get_recommendation_detail_out_of_range(
    authenticated_client: AsyncClient,
    test_recommendation
):
    """Test getting recommendation detail when beyond 200m"""
    # Use coordinates far from recommendation (should fail)
    far_lat = test_recommendation.lat + 0.01  # ~1km away
    far_lng = test_recommendation.lng + 0.01
    
    response = await authenticated_client.get(
        f"/api/v1/recommendations/{test_recommendation.id}",
        params={
            "lat": far_lat,
            "lng": far_lng
        }
    )
    assert response.status_code == 403
    data = response.json()
    assert data["detail"]["code"] == "OUT_OF_RANGE"


@pytest.mark.asyncio
async def test_toggle_like(
    authenticated_client: AsyncClient,
    test_recommendation
):
    """Test toggling like on recommendation"""
    # Like
    response = await authenticated_client.put(
        f"/api/v1/recommendations/{test_recommendation.id}/like"
    )
    assert response.status_code == 200
    data = response.json()
    assert data["liked"] is True
    assert data["like_count"] == 1
    
    # Unlike
    response = await authenticated_client.put(
        f"/api/v1/recommendations/{test_recommendation.id}/like"
    )
    assert response.status_code == 200
    data = response.json()
    assert data["liked"] is False
    assert data["like_count"] == 0


@pytest.mark.asyncio
async def test_get_recommendation_not_found(authenticated_client: AsyncClient):
    """Test getting non-existent recommendation"""
    response = await authenticated_client.get(
        "/api/v1/recommendations/99999",
        params={"lat": 37.5665, "lng": 126.9780}
    )
    assert response.status_code == 404
