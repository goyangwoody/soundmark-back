"""
Database CRUD tests - verify data insert, read, update, delete operations
"""
import pytest
from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.models.user import User
from app.models.track import Track
from app.models.oauth import OAuthAccount
from app.models.place import Place
from app.models.recommendation import Recommendation
from app.models.like import RecommendationLike
from geoalchemy2.functions import ST_MakePoint, ST_SetSRID


# ==================== User CRUD ====================

@pytest.mark.asyncio
async def test_create_user(db_session: AsyncSession):
    """Test creating a user and reading it back"""
    user = User(
        spotify_id="crud_test_user",
        display_name="CRUD Test",
        email="crud@test.com",
        profile_image_url="https://example.com/img.png"
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)

    # Read back
    result = await db_session.execute(
        select(User).where(User.spotify_id == "crud_test_user")
    )
    fetched = result.scalar_one()

    assert fetched.id == user.id
    assert fetched.display_name == "CRUD Test"
    assert fetched.email == "crud@test.com"
    assert fetched.profile_image_url == "https://example.com/img.png"
    assert fetched.created_at is not None
    assert fetched.updated_at is not None


@pytest.mark.asyncio
async def test_update_user(db_session: AsyncSession):
    """Test updating a user"""
    user = User(
        spotify_id="update_test_user",
        display_name="Before Update",
        email="before@test.com"
    )
    db_session.add(user)
    await db_session.commit()

    # Update
    user.display_name = "After Update"
    user.email = "after@test.com"
    await db_session.commit()
    await db_session.refresh(user)

    # Read back
    result = await db_session.execute(
        select(User).where(User.spotify_id == "update_test_user")
    )
    fetched = result.scalar_one()

    assert fetched.display_name == "After Update"
    assert fetched.email == "after@test.com"


@pytest.mark.asyncio
async def test_delete_user(db_session: AsyncSession):
    """Test deleting a user"""
    user = User(
        spotify_id="delete_test_user",
        display_name="Delete Me"
    )
    db_session.add(user)
    await db_session.commit()

    user_id = user.id

    # Delete
    await db_session.delete(user)
    await db_session.commit()

    # Verify gone
    result = await db_session.execute(
        select(User).where(User.id == user_id)
    )
    assert result.scalar_one_or_none() is None


@pytest.mark.asyncio
async def test_user_unique_spotify_id(db_session: AsyncSession):
    """Test that duplicate spotify_id raises error"""
    user1 = User(spotify_id="unique_test", display_name="User 1")
    db_session.add(user1)
    await db_session.commit()

    user2 = User(spotify_id="unique_test", display_name="User 2")
    db_session.add(user2)

    with pytest.raises(Exception):
        await db_session.commit()

    await db_session.rollback()


# ==================== Track CRUD ====================

@pytest.mark.asyncio
async def test_create_and_read_track(db_session: AsyncSession):
    """Test creating and reading a track"""
    track = Track(
        spotify_track_id="track_crud_001",
        title="Test Track",
        artist="Test Artist",
        album="Test Album",
        album_cover_url="https://example.com/cover.jpg",
        track_url="https://open.spotify.com/track/xxx",
        preview_url="https://p.scdn.co/mp3-preview/xxx"
    )
    db_session.add(track)
    await db_session.commit()
    await db_session.refresh(track)

    result = await db_session.execute(
        select(Track).where(Track.spotify_track_id == "track_crud_001")
    )
    fetched = result.scalar_one()

    assert fetched.title == "Test Track"
    assert fetched.artist == "Test Artist"
    assert fetched.album == "Test Album"
    assert fetched.album_cover_url == "https://example.com/cover.jpg"
    assert fetched.track_url == "https://open.spotify.com/track/xxx"
    assert fetched.preview_url == "https://p.scdn.co/mp3-preview/xxx"


@pytest.mark.asyncio
async def test_update_track(db_session: AsyncSession):
    """Test updating track metadata"""
    track = Track(
        spotify_track_id="track_update_001",
        title="Old Title",
        artist="Old Artist"
    )
    db_session.add(track)
    await db_session.commit()

    track.title = "New Title"
    track.artist = "New Artist"
    await db_session.commit()
    await db_session.refresh(track)

    result = await db_session.execute(
        select(Track).where(Track.spotify_track_id == "track_update_001")
    )
    fetched = result.scalar_one()
    assert fetched.title == "New Title"
    assert fetched.artist == "New Artist"


@pytest.mark.asyncio
async def test_delete_track(db_session: AsyncSession):
    """Test deleting a track"""
    track = Track(
        spotify_track_id="track_delete_001",
        title="Delete Me",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    track_id = track.id
    await db_session.delete(track)
    await db_session.commit()

    result = await db_session.execute(
        select(Track).where(Track.id == track_id)
    )
    assert result.scalar_one_or_none() is None


# ==================== OAuthAccount CRUD ====================

@pytest.mark.asyncio
async def test_create_and_read_oauth(db_session: AsyncSession):
    """Test creating and reading an OAuth account"""
    user = User(spotify_id="oauth_test_user", display_name="OAuth User")
    db_session.add(user)
    await db_session.commit()

    oauth = OAuthAccount(
        user_id=user.id,
        provider="spotify",
        access_token="test_access_token_12345",
        refresh_token="test_refresh_token_12345",
        expires_at=datetime(2026, 3, 1)
    )
    db_session.add(oauth)
    await db_session.commit()
    await db_session.refresh(oauth)

    result = await db_session.execute(
        select(OAuthAccount).where(OAuthAccount.user_id == user.id)
    )
    fetched = result.scalar_one()

    assert fetched.provider == "spotify"
    assert fetched.access_token == "test_access_token_12345"
    assert fetched.refresh_token == "test_refresh_token_12345"
    assert fetched.expires_at == datetime(2026, 3, 1)


@pytest.mark.asyncio
async def test_update_oauth_tokens(db_session: AsyncSession):
    """Test updating OAuth tokens (token refresh scenario)"""
    user = User(spotify_id="oauth_update_user", display_name="OAuth Update")
    db_session.add(user)
    await db_session.commit()

    oauth = OAuthAccount(
        user_id=user.id,
        provider="spotify",
        access_token="old_token",
        refresh_token="old_refresh"
    )
    db_session.add(oauth)
    await db_session.commit()

    # Simulate token refresh
    oauth.access_token = "new_token"
    oauth.refresh_token = "new_refresh"
    oauth.expires_at = datetime(2026, 4, 1)
    await db_session.commit()
    await db_session.refresh(oauth)

    result = await db_session.execute(
        select(OAuthAccount).where(OAuthAccount.user_id == user.id)
    )
    fetched = result.scalar_one()
    assert fetched.access_token == "new_token"
    assert fetched.refresh_token == "new_refresh"


@pytest.mark.asyncio
async def test_cascade_delete_oauth_on_user_delete(db_session: AsyncSession):
    """Test that deleting a user cascades to delete OAuth accounts"""
    user = User(spotify_id="cascade_oauth_user", display_name="Cascade")
    db_session.add(user)
    await db_session.commit()

    oauth = OAuthAccount(
        user_id=user.id,
        provider="spotify",
        access_token="cascade_token"
    )
    db_session.add(oauth)
    await db_session.commit()

    oauth_id = oauth.id

    # Delete user
    await db_session.delete(user)
    await db_session.commit()

    # OAuth should also be deleted
    result = await db_session.execute(
        select(OAuthAccount).where(OAuthAccount.id == oauth_id)
    )
    assert result.scalar_one_or_none() is None


# ==================== Recommendation CRUD ====================

@pytest.mark.asyncio
async def test_create_and_read_recommendation(db_session: AsyncSession):
    """Test creating and reading a recommendation"""
    user = User(spotify_id="rec_test_user", display_name="Rec User")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="rec_test_track",
        title="Rec Song",
        artist="Rec Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326),
        message="테스트 메시지"
    )
    db_session.add(rec)
    await db_session.commit()
    await db_session.refresh(rec)

    result = await db_session.execute(
        select(Recommendation).where(Recommendation.id == rec.id)
    )
    fetched = result.scalar_one()

    assert fetched.user_id == user.id
    assert fetched.track_id == track.id
    assert fetched.lat == lat
    assert fetched.lng == lng
    assert fetched.message == "테스트 메시지"
    assert fetched.deleted_at is None


@pytest.mark.asyncio
async def test_soft_delete_recommendation(db_session: AsyncSession):
    """Test soft-deleting a recommendation"""
    user = User(spotify_id="soft_del_user", display_name="Soft Del")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="soft_del_track",
        title="Soft Del Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326),
        message="Will be soft deleted"
    )
    db_session.add(rec)
    await db_session.commit()

    # Soft delete
    rec.deleted_at = datetime.utcnow()
    await db_session.commit()
    await db_session.refresh(rec)

    # Record still exists in DB
    result = await db_session.execute(
        select(Recommendation).where(Recommendation.id == rec.id)
    )
    fetched = result.scalar_one()
    assert fetched.deleted_at is not None

    # But filtered query should not return it
    result = await db_session.execute(
        select(Recommendation).where(
            Recommendation.id == rec.id,
            Recommendation.deleted_at.is_(None)
        )
    )
    assert result.scalar_one_or_none() is None


@pytest.mark.asyncio
async def test_hard_delete_recommendation(db_session: AsyncSession):
    """Test hard-deleting a recommendation"""
    user = User(spotify_id="hard_del_user", display_name="Hard Del")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="hard_del_track",
        title="Hard Del Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    rec_id = rec.id
    await db_session.delete(rec)
    await db_session.commit()

    result = await db_session.execute(
        select(Recommendation).where(Recommendation.id == rec_id)
    )
    assert result.scalar_one_or_none() is None


@pytest.mark.asyncio
async def test_cascade_delete_recommendation_on_user_delete(db_session: AsyncSession):
    """Test that deleting a user cascades to delete recommendations"""
    user = User(spotify_id="cascade_rec_user", display_name="Cascade Rec")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="cascade_rec_track",
        title="Cascade Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    rec_id = rec.id

    # Delete user → recommendation should cascade delete
    await db_session.delete(user)
    await db_session.commit()

    result = await db_session.execute(
        select(Recommendation).where(Recommendation.id == rec_id)
    )
    assert result.scalar_one_or_none() is None


# ==================== RecommendationLike CRUD ====================

@pytest.mark.asyncio
async def test_create_and_read_like(db_session: AsyncSession):
    """Test creating and reading a like"""
    user = User(spotify_id="like_test_user", display_name="Like User")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="like_test_track",
        title="Like Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    # Create like
    like = RecommendationLike(
        recommendation_id=rec.id,
        user_id=user.id
    )
    db_session.add(like)
    await db_session.commit()
    await db_session.refresh(like)

    # Read back
    result = await db_session.execute(
        select(RecommendationLike).where(
            RecommendationLike.recommendation_id == rec.id,
            RecommendationLike.user_id == user.id
        )
    )
    fetched = result.scalar_one()
    assert fetched.recommendation_id == rec.id
    assert fetched.user_id == user.id
    assert fetched.created_at is not None


@pytest.mark.asyncio
async def test_unlike_delete(db_session: AsyncSession):
    """Test deleting a like (unlike)"""
    user = User(spotify_id="unlike_test_user", display_name="Unlike User")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="unlike_test_track",
        title="Unlike Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    like = RecommendationLike(
        recommendation_id=rec.id,
        user_id=user.id
    )
    db_session.add(like)
    await db_session.commit()

    like_id = like.id

    # Unlike (delete)
    await db_session.delete(like)
    await db_session.commit()

    result = await db_session.execute(
        select(RecommendationLike).where(RecommendationLike.id == like_id)
    )
    assert result.scalar_one_or_none() is None


@pytest.mark.asyncio
async def test_like_unique_constraint(db_session: AsyncSession):
    """Test that a user cannot like the same recommendation twice"""
    user = User(spotify_id="dup_like_user", display_name="Dup Like")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="dup_like_track",
        title="Dup Like Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    # First like
    like1 = RecommendationLike(recommendation_id=rec.id, user_id=user.id)
    db_session.add(like1)
    await db_session.commit()

    # Duplicate like should fail
    like2 = RecommendationLike(recommendation_id=rec.id, user_id=user.id)
    db_session.add(like2)

    with pytest.raises(Exception):
        await db_session.commit()

    await db_session.rollback()


@pytest.mark.asyncio
async def test_like_count(db_session: AsyncSession):
    """Test counting likes for a recommendation"""
    # Create 3 users
    users = []
    for i in range(3):
        u = User(spotify_id=f"count_user_{i}", display_name=f"User {i}")
        db_session.add(u)
        users.append(u)
    await db_session.commit()

    track = Track(
        spotify_track_id="count_track",
        title="Count Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=users[0].id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    # 3 users like
    for u in users:
        like = RecommendationLike(recommendation_id=rec.id, user_id=u.id)
        db_session.add(like)
    await db_session.commit()

    # Count
    result = await db_session.execute(
        select(func.count(RecommendationLike.id)).where(
            RecommendationLike.recommendation_id == rec.id
        )
    )
    assert result.scalar() == 3

    # One user unlikes
    result = await db_session.execute(
        select(RecommendationLike).where(
            RecommendationLike.recommendation_id == rec.id,
            RecommendationLike.user_id == users[0].id
        )
    )
    like_to_delete = result.scalar_one()
    await db_session.delete(like_to_delete)
    await db_session.commit()

    # Count should be 2
    result = await db_session.execute(
        select(func.count(RecommendationLike.id)).where(
            RecommendationLike.recommendation_id == rec.id
        )
    )
    assert result.scalar() == 2


@pytest.mark.asyncio
async def test_cascade_delete_likes_on_recommendation_delete(db_session: AsyncSession):
    """Test that deleting a recommendation cascades to delete likes"""
    user = User(spotify_id="cascade_like_user", display_name="Cascade Like")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="cascade_like_track",
        title="Cascade Like Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(rec)
    await db_session.commit()

    like = RecommendationLike(recommendation_id=rec.id, user_id=user.id)
    db_session.add(like)
    await db_session.commit()

    like_id = like.id

    # Delete recommendation → like should cascade delete
    await db_session.delete(rec)
    await db_session.commit()

    result = await db_session.execute(
        select(RecommendationLike).where(RecommendationLike.id == like_id)
    )
    assert result.scalar_one_or_none() is None


# ==================== Place CRUD ====================

@pytest.mark.asyncio
async def test_create_and_read_place(db_session: AsyncSession):
    """Test creating and reading a place"""
    lat, lng = 37.5665, 126.9780
    place = Place(
        google_place_id="ChIJN1t_test",
        place_name="테스트 카페",
        address="서울특별시 강남구 테헤란로 123",
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(place)
    await db_session.commit()
    await db_session.refresh(place)

    result = await db_session.execute(
        select(Place).where(Place.google_place_id == "ChIJN1t_test")
    )
    fetched = result.scalar_one()

    assert fetched.place_name == "테스트 카페"
    assert fetched.address == "서울특별시 강남구 테헤란로 123"
    assert fetched.lat == lat
    assert fetched.lng == lng


@pytest.mark.asyncio
async def test_create_place_without_google_id(db_session: AsyncSession):
    """Test creating a manual place (no Google Place ID)"""
    lat, lng = 37.5700, 126.9800
    place = Place(
        place_name="수동 입력 장소",
        address="직접 입력한 주소",
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(place)
    await db_session.commit()
    await db_session.refresh(place)

    assert place.google_place_id is None
    assert place.place_name == "수동 입력 장소"


@pytest.mark.asyncio
async def test_recommendation_with_place(db_session: AsyncSession):
    """Test creating a recommendation linked to a place"""
    user = User(spotify_id="place_rec_user", display_name="Place Rec")
    db_session.add(user)
    await db_session.commit()

    track = Track(
        spotify_track_id="place_rec_track",
        title="Place Song",
        artist="Artist"
    )
    db_session.add(track)
    await db_session.commit()

    lat, lng = 37.5665, 126.9780
    place = Place(
        place_name="테스트 장소",
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326)
    )
    db_session.add(place)
    await db_session.commit()

    rec = Recommendation(
        user_id=user.id,
        track_id=track.id,
        place_id=place.id,
        lat=lat,
        lng=lng,
        geom=ST_SetSRID(ST_MakePoint(lng, lat), 4326),
        message="장소 연결 테스트"
    )
    db_session.add(rec)
    await db_session.commit()
    await db_session.refresh(rec)

    assert rec.place_id == place.id

    # Load relationship
    result = await db_session.execute(
        select(Recommendation).where(Recommendation.id == rec.id)
    )
    fetched = result.scalar_one()
    await db_session.refresh(fetched, ["place"])
    assert fetched.place.place_name == "테스트 장소"


# ==================== Isolation: tables are clean between tests ====================

@pytest.mark.asyncio
async def test_table_isolation_users(db_session: AsyncSession):
    """Verify that test tables start empty (db_session drops/creates each test)"""
    result = await db_session.execute(select(func.count(User.id)))
    assert result.scalar() == 0


@pytest.mark.asyncio
async def test_table_isolation_tracks(db_session: AsyncSession):
    """Verify that tracks table starts empty"""
    result = await db_session.execute(select(func.count(Track.id)))
    assert result.scalar() == 0


@pytest.mark.asyncio
async def test_table_isolation_recommendations(db_session: AsyncSession):
    """Verify that recommendations table starts empty"""
    result = await db_session.execute(select(func.count(Recommendation.id)))
    assert result.scalar() == 0
