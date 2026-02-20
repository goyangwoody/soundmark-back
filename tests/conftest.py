"""
Pytest configuration and fixtures
"""
import pytest
import asyncio
from typing import AsyncGenerator, Generator
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.pool import NullPool
from sqlalchemy import text

from app.main import app
from app.database import Base, get_db
from app.core.config import settings
from app.models.user import User
from app.models.oauth import OAuthAccount
from app.core.security import create_access_token

# Test database URL (use a separate test database)
TEST_DATABASE_URL = settings.DATABASE_URL.replace("/soundmark_db", "/soundmark_test_db")


# Create test engine
test_engine = create_async_engine(
    TEST_DATABASE_URL,
    poolclass=NullPool,
    echo=False
)

TestSessionLocal = async_sessionmaker(
    test_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)


@pytest.fixture(scope="session")
def event_loop() -> Generator:
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(scope="function")
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    """
    Create a fresh database session for each test
    """
    # Install PostGIS extension and create tables
    async with test_engine.begin() as conn:
        # Try to install PostGIS extension (ignore if already exists or no permission)
        try:
            await conn.execute(text("CREATE EXTENSION IF NOT EXISTS postgis;"))
        except Exception as e:
            # PostGIS may already be installed or user may not have permission
            # If it's already installed, we can continue
            print(f"PostGIS extension note: {e}")
        
        await conn.run_sync(Base.metadata.create_all)
    
    # Create session
    async with TestSessionLocal() as session:
        yield session
    
    # Drop tables after test
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest.fixture
async def client(db_session: AsyncSession) -> AsyncGenerator[AsyncClient, None]:
    """
    Create test client with overridden database dependency
    """
    async def override_get_db():
        yield db_session
    
    app.dependency_overrides[get_db] = override_get_db
    
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as ac:
        yield ac
    
    app.dependency_overrides.clear()


@pytest.fixture
async def test_user(db_session: AsyncSession) -> User:
    """
    Create a test user
    """
    user = User(
        spotify_id="test_spotify_id",
        display_name="Test User",
        email="test@example.com"
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


@pytest.fixture
async def test_track(db_session: AsyncSession):
    """
    Create a test track
    """
    from app.models.track import Track
    
    track = Track(
        spotify_track_id="test_track_123",
        title="Test Song",
        artist="Test Artist",
        album="Test Album"
    )
    db_session.add(track)
    await db_session.commit()
    await db_session.refresh(track)
    return track


@pytest.fixture
async def auth_token(test_user: User) -> str:
    """
    Create an authentication token for test user
    """
    token = create_access_token(data={"sub": str(test_user.id)})
    return token


@pytest.fixture
async def authenticated_client(
    db_session: AsyncSession,
    auth_token: str
) -> AsyncGenerator[AsyncClient, None]:
    """
    Create an authenticated test client
    """
    async def override_get_db():
        yield db_session
    
    app.dependency_overrides[get_db] = override_get_db
    
    # Create new client with auth header
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
        headers={"Authorization": f"Bearer {auth_token}"}
    ) as ac:
        yield ac
    
    app.dependency_overrides.clear()
