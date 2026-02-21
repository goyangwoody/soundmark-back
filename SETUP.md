# Soundmark API - Setup Guide

## 🚀 Quick Start

### 1. Prerequisites
- Docker & Docker Compose installed
- Git installed
- Spotify Developer Account

### 2. Spotify App Setup

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Click "Create an App"
3. Fill in:
   - **App name**: Soundmark (or your choice)
   - **App description**: Location-based music recommendation platform
   - **Redirect URIs**: 
     - `soundmark://callback` (for mobile app with PKCE)
     - `http://127.0.0.1:8000/api/v1/auth/spotify/callback` (optional, for legacy backend callback)
     - ⚠️ **Note**: 모바일 앱에서 PKCE 사용 시 커스텀 URL scheme 필요
4. Save and copy your **Client ID** and **Client Secret**

### 3. Environment Configuration

```bash
# Copy example env file
cp .env.example .env

# Edit .env file and add your Spotify credentials
# Replace the following values:
# - SPOTIFY_CLIENT_ID=your_spotify_client_id_here
# - SPOTIFY_CLIENT_SECRET=your_spotify_client_secret_here
# - JWT_SECRET_KEY=your_jwt_secret_key_here_minimum_32_characters

# Generate a secure JWT secret key (run this in terminal):
# Windows PowerShell:
[System.Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))

# Linux/Mac:
openssl rand -hex 32
```

### 4. Start the Application

```bash
# Build and start containers
docker-compose up -d

# Check logs
docker-compose logs -f api

# Wait for "Application startup complete" message
```

### 5. Run Database Migrations

```bash
# Run migrations inside the container
docker-compose exec api alembic upgrade head
```

### 6. Verify Installation

Open your browser:
- **API Documentation**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

You should see the interactive API documentation with all endpoints.

---

## 📝 API Testing Flow

### Test Authentication Flow (Method 1: Client-side PKCE) ⭐ **권장**

클라이언트가 직접 Spotify OAuth를 처리하는 방식입니다.

1. **Postman/Insomnia에서 테스트**:
   - Spotify OAuth 2.0 flow를 수동으로 진행
   - Code verifier/challenge 생성
   - Spotify에서 access_token + refresh_token 받기
   
2. **백엔드 API 호출**:
   ```bash
   curl -X POST "http://localhost:8000/api/v1/auth/spotify/verify" \
     -H "Content-Type: application/json" \
     -d '{
       "spotify_access_token": "BQD...",
       "spotify_refresh_token": "AQC...",
       "expires_in": 3600
     }'
   ```

3. **응답에서 JWT 복사**:
   ```json
   {
     "access_token": "eyJ0eXAi...",
     "token_type": "bearer",
     "expires_in": 604800
   }
   ```

4. Swagger UI에서 "Authorize" 클릭 후 `Bearer <jwt_token>` 입력

### Test Authentication Flow (Method 2: Backend Callback) - Deprecated

백엔드가 OAuth를 처리하는 기존 방식입니다.

1. Go to http://localhost:8000/docs
2. Try `/api/v1/auth/spotify/login` endpoint
3. Copy the authorization URL from response
4. Open URL in browser and login with Spotify
5. After redirect, copy the `code` parameter from URL
6. Use `/api/v1/auth/spotify/callback` with the code
7. Copy the `access_token` from response
8. Click "Authorize" button in Swagger UI and enter: `Bearer <your_access_token>`
9. Now you can test all protected endpoints!

### Test Recommendation Flow

1. **Authenticate first** (see above)
2. Use `/api/v1/recommendations` POST to create a recommendation:
   ```json
   {
     "lat": 37.5665,
     "lng": 126.9780,
     "spotify_track_id": "4uLU6hMCjMI75M1A2tKUQC",
     "message": "Perfect for morning walk",
     "place": {
       "source": "manual",
       "place_name": "Seoul City Hall"
     }
   }
   ```
3. Copy the returned `id`
4. Test detail view with same coordinates (should work):
   `/api/v1/recommendations/{id}?lat=37.5665&lng=126.9780`
5. Test with far coordinates (should fail with 403):
   `/api/v1/recommendations/{id}?lat=37.5000&lng=126.9000`

### Test Map View

1. Use `/api/v1/map/nearby` with your coordinates:
   - `lat=37.5665`
   - `lng=126.9780`
2. Should return nearby recommendations

---

## 🧪 Running Tests

```bash
# Run all tests
docker-compose exec api pytest

# Run specific test file
docker-compose exec api pytest tests/test_api/test_auth.py

# Run with coverage
docker-compose exec api pytest --cov=app tests/

# Run tests verbosely
docker-compose exec api pytest -v
```

---

## 🛠️ Development Commands

```bash
# View logs
docker-compose logs -f api

# Restart API service
docker-compose restart api

# Access database
docker-compose exec postgres psql -U soundmark -d soundmark_db

# Create new migration
docker-compose exec api alembic revision -m "description"

# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ deletes database data)
docker-compose down -v
```

---

## 🗂️ Project Structure

```
soundmark-api/
├── app/
│   ├── api/v1/              # API endpoints
│   │   ├── auth.py          # Authentication routes
│   │   ├── recommendations.py  # Recommendation routes
│   │   └── map.py           # Map routes
│   ├── core/                # Core configuration
│   │   ├── config.py        # Settings
│   │   ├── security.py      # JWT & auth
│   │   └── database_utils.py  # PostGIS utilities
│   ├── models/              # Database models
│   ├── schemas/             # Pydantic schemas
│   ├── services/            # Business logic
│   ├── database.py          # Database setup
│   └── main.py              # FastAPI app
├── alembic/                 # Database migrations
├── tests/                   # Test suite
├── docker-compose.yml       # Docker setup
├── Dockerfile               # API container
├── requirements.txt         # Python dependencies
└── README.md               # Documentation
```

---

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Change ports in docker-compose.yml
# Postgres: "5433:5432"
# API: "8001:8000"
```

### Database Connection Error
```bash
# Check if postgres is running
docker-compose ps

# Check postgres logs
docker-compose logs postgres

# Verify DATABASE_URL in .env
```

### Migration Errors
```bash
# Reset migrations (⚠️ drops all data)
docker-compose down -v
docker-compose up -d
docker-compose exec api alembic upgrade head
```

### Spotify OAuth Issues
1. Verify redirect URI in Spotify Dashboard matches `.env`
2. Check Client ID and Secret are correct
3. Ensure no trailing spaces in `.env` values

---

## 📚 Next Steps

1. **Frontend Integration**: Share OpenAPI spec at `/openapi.json`
2. **Add More Features**: 
   - User profiles
   - Search functionality
   - Follow system
3. **Deploy**: Consider platforms like Railway, Render, or AWS
4. **Monitoring**: Add logging and error tracking

---

## 💡 Tips

- Use **Postman** or **Thunder Client** for API testing
- Check `/docs` for interactive API documentation
- Database schema is in `alembic/versions/001_*.py`
- All coordinates use **SRID 4326** (WGS 84)
- Distance calculations are in **meters**

---

Good luck building Soundmark! 🎵📍
