# Soundmark API

**위치 기반 소셜 음악 추천 플랫폼 백엔드**

사용자가 특정 장소(좌표)에 노래를 "묻어두고", 다른 사용자는 해당 장소 반경 200m 이내에 도착했을 때만 추천 음악의 상세 정보를 볼 수 있는 서비스입니다.

## 핵심 기능

- **위치 기반 음악 추천**: 특정 좌표에 Spotify 트랙을 추천으로 등록
- **거리 기반 접근 제어**: 200m 이내에서만 추천곡 상세 정보 확인 가능
- **Spotify 연동**: Spotify OAuth 로그인 및 트랙 메타데이터 연동
- **지도 API**: 가까운 핀(200m 이내)은 개별 표시, 먼 핀은 개수만 클러스터링
- **소셜 기능**: 좋아요/언라이크 토글
- **업로더 정보**: 모든 추천곡에 업로더(user) 정보 포함

## 기술 스택

- **Framework**: FastAPI 0.104+
- **Database**: PostgreSQL 15 + PostGIS 3.x (지리 공간 데이터)
- **ORM**: SQLAlchemy 2.0 (async)
- **Authentication**: JWT + Spotify OAuth 2.0
- **API Integration**: Spotipy (Spotify Web API)
- **Migration**: Alembic
- **Testing**: Pytest + Pytest-asyncio
- **Containerization**: Docker + Docker Compose

## 프로젝트 구조

```
soundmark-back/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── __init__.py           # API 라우터 통합
│   │       ├── auth.py               # 인증 엔드포인트
│   │       ├── recommendations.py    # 추천곡 CRUD
│   │       └── map.py                # 지도 데이터 조회
│   ├── core/
│   │   ├── config.py                 # 환경 설정 (Pydantic Settings)
│   │   ├── security.py               # JWT 인증/보안
│   │   └── database_utils.py         # PostGIS 유틸리티
│   ├── models/
│   │   ├── user.py                   # User 모델
│   │   ├── oauth.py                  # OAuthAccount 모델
│   │   ├── track.py                  # Track 모델
│   │   ├── place.py                  # Place 모델
│   │   ├── recommendation.py         # Recommendation 모델
│   │   └── like.py                   # RecommendationLike 모델
│   ├── schemas/
│   │   ├── auth.py                   # 인증 스키마
│   │   ├── track.py                  # 트랙 스키마
│   │   ├── recommendation.py         # 추천곡 스키마
│   │   └── map.py                    # 지도 스키마
│   ├── services/
│   │   ├── spotify.py                # Spotify API 통합
│   │   ├── recommendation.py         # 추천곡 비즈니스 로직
│   │   └── location.py               # 위치/클러스터링 로직
│   ├── database.py                   # DB 연결 및 Base
│   └── main.py                       # FastAPI 앱 진입점
├── alembic/
│   ├── env.py                        # Alembic 설정
│   └── versions/
│       └── 001_initial_schema_with_postgis_support.py
├── tests/
│   ├── conftest.py                   # Pytest 설정
│   └── test_api/
│       ├── test_auth.py
│       ├── test_recommendations.py
│       └── test_map.py
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── pytest.ini
└── README.md
```

## API 엔드포인트

### 🔐 인증 (Authentication) - `/api/v1/auth`

#### `GET /spotify/login`
Spotify OAuth 로그인 URL 반환
- **인증 필요**: ❌
- **응답**: `SpotifyLoginResponse`
  ```json
  {
    "authorization_url": "https://accounts.spotify.com/authorize?..."
  }
  ```

#### `POST /spotify/callback`
Spotify OAuth 콜백 처리 및 JWT 토큰 발급
- **인증 필요**: ❌
- **파라미터**: `code` (query, Spotify authorization code)
- **응답**: `TokenResponse`
  ```json
  {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "token_type": "bearer",
    "expires_in": 604800
  }
  ```
- **프로세스**:
  1. Spotify에서 access token 교환
  2. Spotify API로 사용자 프로필 조회
  3. User 생성 또는 업데이트
  4. OAuthAccount 저장 (Spotify tokens)
  5. 자체 JWT 토큰 발급

#### `GET /me`
현재 인증된 사용자 정보 조회
- **인증 필요**: ✅ (Bearer token)
- **응답**: `UserResponse`
  ```json
  {
    "id": 1,
    "spotify_id": "spotify:user:xxxxx",
    "display_name": "홍길동",
    "email": "user@example.com",
    "profile_image_url": "https://i.scdn.co/image/...",
    "created_at": "2026-02-20T10:00:00"
  }
  ```

#### `POST /refresh`
JWT 토큰 갱신
- **인증 필요**: ✅ (Bearer token)
- **응답**: `TokenResponse` (새로운 JWT)

---

### 🎵 추천곡 (Recommendations) - `/api/v1/recommendations`

#### `POST /recommendations`
새로운 추천곡 등록
- **인증 필요**: ✅
- **요청 바디**: `RecommendationCreateRequest`
  ```json
  {
    "lat": 37.5665,
    "lng": 126.9780,
    "spotify_track_id": "3n3Ppam7vgaVa1iaRUc9Lp",
    "message": "이 카페에서 들으면 좋아요!",
    "note": "비오는 날 창가 자리에서...",
    "place": {
      "source": "google",
      "google_place_id": "ChIJN1t_tDeuEmsRUsoyG83frY4",
      "place_name": "스타벅스 강남점",
      "address": "서울특별시 강남구 테헤란로 123"
    }
  }
  ```
- **응답**: `RecommendationResponse` (생성된 추천곡 + 업로더 정보)
  ```json
  {
    "id": 123,
    "lat": 37.5665,
    "lng": 126.9780,
    "distance_meters": 0,
    "track": {
      "id": 45,
      "spotify_track_id": "3n3Ppam7vgaVa1iaRUc9Lp",
      "title": "Blinding Lights",
      "artist": "The Weeknd",
      "album": "After Hours",
      "album_cover_url": "https://i.scdn.co/image/...",
      "track_url": "https://open.spotify.com/track/...",
      "preview_url": "https://p.scdn.co/mp3-preview/..."
    },
    "user": {
      "id": 1,
      "spotify_id": "spotify:user:xxxxx",
      "display_name": "홍길동",
      "email": "user@example.com",
      "profile_image_url": "https://i.scdn.co/image/..."
    },
    "message": "이 카페에서 들으면 좋아요!",
    "created_at": "2026-02-20T10:30:00",
    "like_count": 0,
    "liked": false
  }
  ```
- **로직**:
  1. Spotify Track 조회/생성 (캐싱)
  2. Place 조회/생성 (선택적)
  3. PostGIS POINT geometry 생성
  4. Recommendation 저장
  5. 중복 체크 (로깅만, 차단 안 함)

#### `GET /recommendations/{recommendation_id}`
추천곡 상세 조회 (**200m 거리 제한**)
- **인증 필요**: ✅
- **파라미터**: 
  - `lat` (query, 현재 위치 위도, required)
  - `lng` (query, 현재 위치 경도, required)
- **응답**: `RecommendationDetailResponse`
  ```json
  {
    "id": 123,
    "lat": 37.5665,
    "lng": 126.9780,
    "distance_meters": 150.5,
    "track": { /* TrackResponse */ },
    "user": { /* UserResponse */ },
    "message": "이 카페에서 들으면 좋아요!",
    "note": "비오는 날 창가 자리에서...",
    "place_name": "스타벅스 강남점",
    "address": "서울특별시 강남구 테헤란로 123",
    "created_at": "2026-02-20T10:30:00",
    "like_count": 5,
    "liked": true
  }
  ```
- **에러**:
  - `403 OUT_OF_RANGE`: 200m 초과 시
    ```json
    {
      "detail": {
        "code": "OUT_OF_RANGE",
        "message": "추천곡 상세는 반경 200m 이내에서만 볼 수 있습니다.",
        "distance_meters": 350.2
      }
    }
    ```
  - `404`: 추천곡 없음

#### `PUT /recommendations/{recommendation_id}/like`
추천곡 좋아요/언라이크 토글
- **인증 필요**: ✅
- **응답**: `RecommendationLikeResponse`
  ```json
  {
    "liked": true,
    "like_count": 6
  }
  ```
- **로직**: 이미 좋아요 → 취소, 안 한 경우 → 추가

---

### 🗺️ 지도 (Map) - `/api/v1/map`

#### `GET /map/nearby`
주변 추천곡 지도 데이터 조회
- **인증 필요**: ✅
- **파라미터**:
  - `lat` (query, 현재 위치 위도, required)
  - `lng` (query, 현재 위치 경도, required)
- **응답**: `MapResponse`
  ```json
  {
    "active_recommendations": [
      {
        "id": 123,
        "lat": 37.5665,
        "lng": 126.9780,
        "distance_meters": 150.5,
        "track": { /* TrackResponse */ },
        "user": { /* UserResponse */ },
        "message": "이 카페에서 들으면 좋아요!",
        "like_count": 5,
        "liked": true
      }
    ],
    "inactive_counts": [
      {
        "lat": 37.5700,
        "lng": 126.9800,
        "count": 12
      }
    ]
  }
  ```
- **로직**:
  1. **Active (200m 이내)**: 개별 핀으로 표시 (track, user 포함)
  2. **Inactive (200m 초과)**: 400m 격자 클러스터링 → 개수만 반환
  3. PostGIS `ST_DWithin`, `ST_Distance` 사용

---

## 데이터베이스 모델

### 📊 ERD 개요
```
users ─┬─ oauth_accounts
       ├─ recommendations ─┬─ tracks
       └─ recommendation_likes ─┘
                           └─ places (optional)
```

### `users` - 사용자
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | 사용자 ID |
| `spotify_id` | VARCHAR(255) UNIQUE | Spotify 사용자 ID |
| `display_name` | VARCHAR(255) | 표시 이름 |
| `email` | VARCHAR(255) | 이메일 |
| `profile_image_url` | VARCHAR(512) | 프로필 이미지 URL |
| `created_at` | TIMESTAMP | 생성 시각 |
| `updated_at` | TIMESTAMP | 업데이트 시각 |

**Relationships**:
- `oauth_accounts`: One-to-Many (cascade delete)
- `recommendations`: One-to-Many (cascade delete)
- `likes`: One-to-Many (cascade delete)

---

### `oauth_accounts` - OAuth 토큰
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | OAuth 계정 ID |
| `user_id` | INT FK | User 외래키 |
| `provider` | VARCHAR(50) | 'spotify' |
| `access_token` | TEXT | Spotify access token |
| `refresh_token` | TEXT | Spotify refresh token |
| `expires_at` | TIMESTAMP | 토큰 만료 시각 |
| `created_at` | TIMESTAMP | 생성 시각 |
| `updated_at` | TIMESTAMP | 업데이트 시각 |

**Relationships**:
- `user`: Many-to-One

---

### `tracks` - Spotify 트랙 메타데이터
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | 트랙 ID |
| `spotify_track_id` | VARCHAR(255) UNIQUE | Spotify 트랙 ID |
| `title` | VARCHAR(512) | 곡 제목 |
| `artist` | VARCHAR(512) | 아티스트 (`,` 구분) |
| `album` | VARCHAR(512) | 앨범명 |
| `album_cover_url` | TEXT | 앨범 커버 이미지 URL |
| `track_url` | TEXT | Spotify Web URL |
| `preview_url` | TEXT | 30초 미리듣기 URL |
| `created_at` | TIMESTAMP | 생성 시각 |
| `updated_at` | TIMESTAMP | 업데이트 시각 |

**Relationships**:
- `recommendations`: One-to-Many

**캐싱 전략**: 동일 `spotify_track_id` 재사용 (중복 저장 방지)

---

### `places` - 장소 정보 (선택적)
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | 장소 ID |
| `google_place_id` | VARCHAR(255) UNIQUE | Google Place ID (nullable) |
| `place_name` | VARCHAR(512) | 장소 이름 |
| `address` | TEXT | 주소 |
| `lat` | FLOAT | 위도 |
| `lng` | FLOAT | 경도 |
| `geom` | GEOMETRY(POINT, 4326) | PostGIS 포인트 |
| `created_at` | TIMESTAMP | 생성 시각 |
| `updated_at` | TIMESTAMP | 업데이트 시각 |

**Relationships**:
- `recommendations`: One-to-Many

**용도**: Google Places API 또는 수동 입력 장소 저장

---

### `recommendations` - 추천곡 (핵심 테이블)
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | 추천곡 ID |
| `user_id` | INT FK | 업로더 (User 외래키) |
| `track_id` | INT FK | Track 외래키 |
| `place_id` | INT FK | Place 외래키 (nullable) |
| `lat` | FLOAT | 위도 |
| `lng` | FLOAT | 경도 |
| `geom` | GEOMETRY(POINT, 4326) | **PostGIS 포인트** (GIST 인덱스) |
| `message` | VARCHAR(500) | 짧은 메시지 |
| `note` | TEXT | 긴 노트 |
| `created_at` | TIMESTAMP | 생성 시각 (인덱스) |
| `updated_at` | TIMESTAMP | 업데이트 시각 |
| `deleted_at` | TIMESTAMP | 소프트 삭제 시각 |

**Relationships**:
- `user`: Many-to-One
- `track`: Many-to-One
- `place`: Many-to-One (nullable)
- `likes`: One-to-Many (cascade delete)

**PostGIS 기능**:
- `geom`: `GEOMETRY(POINT, 4326)` with **GIST 인덱스**
- 거리 계산: `ST_DWithin`, `ST_Distance` (geography cast)
- 200m 제한: `ST_DWithin(geom::geography, user_point::geography, 200)`

---

### `recommendation_likes` - 좋아요
| 필드 | 타입 | 설명 |
|------|------|------|
| `id` | INT PK | 좋아요 ID |
| `recommendation_id` | INT FK | Recommendation 외래키 |
| `user_id` | INT FK | User 외래키 |
| `created_at` | TIMESTAMP | 생성 시각 |

**Constraints**:
- `UNIQUE(recommendation_id, user_id)`: 중복 좋아요 방지

**Relationships**:
- `recommendation`: Many-to-One
- `user`: Many-to-One

---

## 서비스 계층

### `spotify.py` - Spotify API 통합

**SpotifyService 클래스**:

| 메서드 | 설명 |
|--------|------|
| `get_authorization_url()` | Spotify OAuth URL 생성 |
| `exchange_code_for_token(code)` | 인증 코드 → 토큰 교환 |
| `refresh_access_token(refresh_token)` | 토큰 갱신 |
| `get_user_profile(access_token)` | 사용자 프로필 조회 |
| `get_track_metadata(spotify_track_id)` | 트랙 메타데이터 조회 |
| `search_tracks(query, limit)` | 트랙 검색 |

**Spotipy 라이브러리**:
- `SpotifyOAuth`: 사용자 인증 (scope: `user-read-email user-read-private`)
- `SpotifyClientCredentials`: 트랙 조회 (서버 인증)

---

### `recommendation.py` - 추천곡 비즈니스 로직

| 함수 | 설명 |
|------|------|
| `get_or_create_track(db, spotify_track_id)` | 트랙 조회/생성 (캐싱) |
| `get_or_create_place(db, lat, lng, place_input)` | 장소 조회/생성 |
| `create_recommendation(...)` | 추천곡 생성 (트랙+장소+지오메트리) |
| `check_distance_access(db, rec_id, lat, lng, max_distance)` | 200m 거리 검증 |
| `toggle_like(db, rec_id, user_id)` | 좋아요/언라이크 토글 |
| `get_like_count(db, rec_id)` | 좋아요 수 조회 |
| `check_user_liked(db, rec_id, user_id)` | 사용자 좋아요 여부 |

---

### `location.py` - 위치/클러스터링

| 함수 | 설명 |
|------|------|
| `get_nearby_recommendations(db, lat, lng, radius)` | 반경 내 추천곡 조회 (거리 포함) |
| `get_distant_recommendations(db, lat, lng, min_radius, max_radius)` | 원거리 추천곡 조회 |
| `cluster_recommendations_by_grid(recommendations, grid_size)` | 격자 클러스터링 (400m 단위) |
| `get_map_data(db, lat, lng, active_radius, grid_size)` | 지도 데이터 (active + inactive) |

**클러스터링 알고리즘**:
```python
# 400m 격자로 그룹핑
grid_lat = round(lat / lat_per_400m) * lat_per_400m
grid_lng = round(lng / lng_per_400m) * lng_per_400m
```

---

## Core 유틸리티

### `config.py` - 환경 설정

**Settings 클래스** (Pydantic Settings):
```python
PROJECT_NAME: str = "Soundmark API"
API_V1_PREFIX: str = "/api/v1"
DEBUG: bool = False

DATABASE_URL: str                     # PostgreSQL DSN
SPOTIFY_CLIENT_ID: str
SPOTIFY_CLIENT_SECRET: str
SPOTIFY_REDIRECT_URI: str

JWT_SECRET_KEY: str                  # 32자 이상 필수
JWT_ALGORITHM: str = "HS256"
JWT_ACCESS_TOKEN_EXPIRE_DAYS: int = 7

ALLOWED_ORIGINS: str = "http://localhost:3000"  # CORS
```

---

### `security.py` - JWT 인증

| 함수 | 설명 |
|------|------|
| `create_access_token(data, expires_delta)` | JWT 생성 (7일 만료) |
| `decode_access_token(token)` | JWT 검증/디코드 |
| `get_current_user(credentials, db)` | **FastAPI Dependency** (Bearer 토큰 → User) |

---

### `database_utils.py` - PostGIS 유틸리티

| 함수 | 설명 |
|------|------|
| `create_point_geom(lat, lng)` | `ST_MakePoint` 생성 |
| `calculate_distance_meters(db, lat1, lng1, lat2, lng2)` | 두 점 사이 거리 (m) |
| `filter_by_radius(query, lat, lng, radius_meters)` | `ST_DWithin` 필터 추가 |
| `add_distance_column(query, lat, lng)` | 거리 컬럼 추가 |
| `cluster_by_grid(lat, lng, grid_size_meters)` | 격자 중심 계산 |

**PostGIS 쿼리 예시**:
```sql
-- 200m 이내 필터링
ST_DWithin(
  ST_Transform(geom, 4326)::geography,
  ST_Transform(ST_GeomFromText('POINT(lng lat)', 4326), 4326)::geography,
  200
)

-- 거리 계산 (미터)
ST_Distance(
  ST_Transform(geom, 4326)::geography,
  ST_Transform(ST_GeomFromText('POINT(lng lat)', 4326), 4326)::geography
)
```

---

## 시작하기

### 필수 요구사항
- Docker & Docker Compose
- (선택) Python 3.11+ (로컬 개발 시)

### 1. 환경 설정

```bash
# .env 파일 생성
cp .env.example .env
```

**필수 환경 변수 (.env)**:
```env
# Database
DATABASE_URL=postgresql+asyncpg://postgres:postgres@postgres:5432/soundmark

# Spotify OAuth (https://developer.spotify.com/dashboard)
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
SPOTIFY_REDIRECT_URI=http://127.0.0.1:8000/api/v1/auth/spotify/callback

# JWT (32자 이상 랜덤 문자열)
JWT_SECRET_KEY=your-super-secret-jwt-key-at-least-32-characters-long
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_DAYS=7

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

# App
DEBUG=true
```

### 2. Spotify 앱 등록

1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) 접속
2. **"Create an App"** 클릭
3. 앱 정보 입력:
   - **App name**: Soundmark (또는 원하는 이름)
   - **App description**: Location-based music recommendation platform
4. **Edit Settings** → **Redirect URIs** 추가:
   ```
   http://127.0.0.1:8000/api/v1/auth/spotify/callback
   ```
   ⚠️ **주의**: `localhost` 대신 loopback IP `127.0.0.1` 사용 필수!
5. **Client ID**와 **Client Secret**을 `.env` 파일에 복사

### 3. Docker Compose로 실행

```bash
# 컨테이너 빌드 및 실행 (백그라운드)
docker-compose up -d

# 로그 확인
docker-compose logs -f api

# 특정 서비스 로그만 보기
docker-compose logs -f postgres
```

**실행되는 서비스**:
- `postgres`: PostgreSQL 15 + PostGIS 3.x (포트 5432)
- `api`: FastAPI (포트 8000)

### 4. 데이터베이스 마이그레이션

```bash
# 컨테이너 내부에서 Alembic 실행
docker-compose exec api alembic upgrade head

# 또는 새 마이그레이션 생성 (스키마 변경 시)
docker-compose exec api alembic revision --autogenerate -m "Add new column"
```

### 5. API 접속

- **API 문서 (Swagger)**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

---

## 로컬 개발 환경 (Docker 없이)

### 사전 준비
- Python 3.11+
- PostgreSQL 15 + PostGIS 3.x (로컬 설치 필수)

```bash
# 가상환경 생성
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# .env 파일 설정 (DATABASE_URL 수정)
DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5432/soundmark

# 데이터베이스 마이그레이션
alembic upgrade head

# 개발 서버 실행 (hot reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## 테스트

### 테스트 실행

```bash
# 모든 테스트 실행
docker-compose exec api pytest

# 특정 테스트 파일
docker-compose exec api pytest tests/test_api/test_recommendations.py

# 커버리지 리포트
docker-compose exec api pytest --cov=app --cov-report=html tests/

# 로컬 환경에서
pytest
pytest --cov=app --cov-report=term-missing
```

### 테스트 구조
```
tests/
├── conftest.py                    # Pytest fixtures (test DB, client)
└── test_api/
    ├── test_auth.py               # 인증 테스트
    ├── test_recommendations.py    # 추천곡 CRUD 테스트
    └── test_map.py                # 지도 API 테스트
```

**주요 Fixtures**:
- `test_db`: 테스트용 PostgreSQL 세션
- `client`: TestClient (FastAPI)
- `test_user`: 인증된 테스트 사용자
- `auth_headers`: Bearer 토큰 헤더

---

## 주요 스키마 (Pydantic)

### 인증 스키마 (`schemas/auth.py`)
```python
class UserResponse(BaseModel):
    id: int
    spotify_id: str
    display_name: Optional[str]
    email: Optional[str]
    profile_image_url: Optional[str]
    created_at: datetime

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    expires_in: int
```

### 트랙 스키마 (`schemas/track.py`)
```python
class TrackResponse(BaseModel):
    id: int
    spotify_track_id: str
    title: str
    artist: str
    album: Optional[str]
    album_cover_url: Optional[str]
    track_url: Optional[str]
    preview_url: Optional[str]
```

### 추천곡 스키마 (`schemas/recommendation.py`)
```python
class RecommendationCreateRequest(BaseModel):
    lat: float = Field(ge=-90, le=90)
    lng: float = Field(ge=-180, le=180)
    spotify_track_id: str
    message: Optional[str] = Field(max_length=500)
    note: Optional[str]
    place: Optional[PlaceInput] = None

class RecommendationResponse(BaseModel):
    id: int
    lat: float
    lng: float
    distance_meters: Optional[float]
    track: TrackResponse
    user: UserResponse              # 업로더 정보
    message: Optional[str]
    created_at: datetime
    like_count: int = 0
    liked: bool = False

class RecommendationDetailResponse(RecommendationResponse):
    note: Optional[str]
    place_name: Optional[str]
    address: Optional[str]
```

### 지도 스키마 (`schemas/map.py`)
```python
class ActiveRecommendation(BaseModel):
    id: int
    lat: float
    lng: float
    distance_meters: float
    track: TrackResponse
    user: UserResponse              # 업로더 정보
    message: Optional[str]
    like_count: int = 0
    liked: bool = False

class InactiveCluster(BaseModel):
    lat: float                      # 클러스터 중심 위도
    lng: float                      # 클러스터 중심 경도
    count: int                      # 추천곡 개수

class MapResponse(BaseModel):
    active_recommendations: List[ActiveRecommendation]
    inactive_counts: List[InactiveCluster]
```

---

## FastAPI 앱 구조 (`main.py`)

```python
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: 로깅 설정, DB 연결 확인
    logger.info("Starting up Soundmark API...")
    yield
    # Shutdown: 리소스 정리
    logger.info("Shutting down Soundmark API...")

app = FastAPI(
    title="Soundmark API",
    description="Location-based social music recommendation platform",
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# CORS 미들웨어
app.add_middleware(CORSMiddleware, ...)

# 예외 핸들러
@app.exception_handler(RequestValidationError)  # 422 validation errors
@app.exception_handler(SQLAlchemyError)         # DB errors
@app.exception_handler(Exception)               # General errors

# Health check
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# API v1 라우터 통합
app.include_router(api_router, prefix=settings.API_V1_PREFIX)
```

---

## DB 연결 (`database.py`)

```python
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, declarative_base

engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_pre_ping=True
)

AsyncSessionLocal = sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)

Base = declarative_base()

async def get_db() -> AsyncSession:
    """FastAPI dependency for DB session"""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
```

---

## Alembic 마이그레이션

### 마이그레이션 파일 (`alembic/versions/001_initial_schema_with_postgis_support.py`)

**주요 작업**:
1. PostGIS 확장 설치: `CREATE EXTENSION IF NOT EXISTS postgis;`
2. 테이블 생성 (users, oauth_accounts, tracks, places, recommendations, recommendation_likes)
3. 외래키 제약 조건
4. 인덱스 생성:
   - `users.spotify_id` (UNIQUE)
   - `tracks.spotify_track_id` (UNIQUE)
   - `recommendations.geom` (GIST 인덱스)
   - `recommendations.created_at`
   - `recommendation_likes(recommendation_id, user_id)` (UNIQUE)

### 마이그레이션 명령어

```bash
# 현재 버전 확인
alembic current

# 최신 버전으로 업그레이드
alembic upgrade head

# 한 단계 롤백
alembic downgrade -1

# 새 마이그레이션 생성 (스키마 변경 후)
alembic revision --autogenerate -m "Add new feature"
```

---

## MVP 설계 결정사항

### ✅ 포함된 기능
1. **위치 기반 접근 제어**: 200m 이내에서만 상세 조회
2. **지도 클러스터링**: 400m 격자 단위 카운트
3. **좋아요 기능**: 토글 방식 (중복 방지)
4. **Spotify 통합**: OAuth + 트랙 메타데이터
5. **업로더 정보**: 모든 추천곡에 user 정보 포함
6. **장소 선택**: Google Place ID 또는 수동 입력

### ❌ 제외된 기능 (향후 추가 예정)
1. **위치 위변조 방지**: GPS 신뢰 (서버 검증 없음)
2. **이미지 업로드**: 텍스트(message/note)만 지원
3. **팔로우 시스템**: 테이블만 존재 (API 미구현)
4. **알림**: 푸시 알림 없음
5. **검색**: 트랙 검색 API 미구현 (서비스 레벨에만 존재)
6. **중복 방지**: 로깅만 (동일 위치/트랙 재등록 허용)

### 🔒 보안 고려사항
- **JWT 토큰**: 7일 만료, HS256 알고리즘
- **Spotify 토큰**: `oauth_accounts` 테이블에 저장 (갱신 가능)
- **비밀번호 없음**: OAuth 전용 (Spotify만)
- **CORS**: `ALLOWED_ORIGINS` 환경 변수로 제어

---

## 에러 처리

### 표준 에러 응답 형식
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "User-friendly message",
    "details": { /* optional */ }
  }
}
```

### 상태 코드
| 코드 | 설명 |
|------|------|
| `200` | 성공 |
| `201` | 생성 성공 |
| `400` | 잘못된 요청 (Spotify API 실패 등) |
| `401` | 인증 실패 (JWT 없음/만료) |
| `403` | 권한 없음 (거리 제한) |
| `404` | 리소스 없음 |
| `422` | Validation 오류 (Pydantic) |
| `500` | 서버 오류 |

---

## 배포

### 📦 EC2 Production Deployment

이 프로젝트는 AWS EC2에서 Docker Compose를 사용한 단일 인스턴스 배포를 지원합니다.

**Quick Start:**
- [DEPLOYMENT_QUICKSTART.md](DEPLOYMENT_QUICKSTART.md) - 5분 내 빠른 배포
- [DEPLOYMENT.md](DEPLOYMENT.md) - 상세 가이드 및 트러블슈팅

**배포 스택:**
- FastAPI (Uvicorn with 2+ workers)
- PostgreSQL + PostGIS (Docker volume)
- Nginx (Reverse proxy)

**배포 파일:**
- `docker-compose.prod.yml` - Production 설정
- `nginx.conf` - Nginx 리버스 프록시 설정
- `.env.example` - 환경 변수 템플릿

```bash
# 로컬에서 프로덕션 설정 테스트
docker-compose -f docker-compose.prod.yml up --build

# EC2 배포 (자세한 내용은 DEPLOYMENT.md 참조)
ssh ubuntu@YOUR_EC2_IP
git clone <repo>
cd soundmark-back
cp .env.example .env
nano .env  # 환경변수 설정
docker-compose -f docker-compose.prod.yml up -d --build
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head
```

### Docker Hub 이미지 빌드 (선택사항)
```bash
# 이미지 빌드
docker build -t soundmark-api:latest .

# 태그 및 푸시
docker tag soundmark-api:latest your-registry/soundmark-api:v1.0.0
docker push your-registry/soundmark-api:v1.0.0
```

### 프로덕션 환경 변수
```env
DEBUG=false
DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/soundmark_db
POSTGRES_PASSWORD=secure_password_here
JWT_SECRET_KEY=<Generate with: openssl rand -hex 32>
ALLOWED_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
SPOTIFY_REDIRECT_URI=https://yourdomain.com/api/v1/auth/spotify/callback
```

### 헬스 체크
```bash
curl http://localhost:8000/docs
curl http://YOUR_EC2_IP/docs
```

---

## 트러블슈팅

### 1. PostGIS 함수 에러
**문제**: `function st_dwithin does not exist`
**해결**:
```sql
-- DB에서 PostGIS 확장 확인
SELECT postgis_version();

-- 없으면 설치
CREATE EXTENSION postgis;
```

### 2. Spotify OAuth 콜백 실패
**문제**: `Invalid redirect URI`
**해결**:
- Spotify Dashboard에서 Redirect URI 확인
- `http://127.0.0.1:8000/api/v1/auth/spotify/callback` 정확히 입력
- `localhost` 대신 `127.0.0.1` 사용

### 3. JWT 토큰 만료
**문제**: `Could not validate credentials`
**해결**:
- `/api/v1/auth/refresh` 엔드포인트로 재발급
- 또는 `/api/v1/auth/spotify/login`부터 재로그인

### 4. Docker 컨테이너 재시작
```bash
# 컨테이너 중지 및 삭제
docker-compose down

# 볼륨까지 삭제 (DB 데이터 초기화)
docker-compose down -v

# 재시작
docker-compose up -d --build
```

---

## 개발 팁

### 1. DB 직접 접속
```bash
# 컨테이너 내부 psql
docker-compose exec postgres psql -U postgres -d soundmark

# 로컬에서 접속
psql -h localhost -p 5432 -U postgres -d soundmark
```

### 2. API 테스트 (curl)
```bash
# 로그인 URL 받기
curl http://localhost:8000/api/v1/auth/spotify/login

# 추천곡 조회 (인증 필요)
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  "http://localhost:8000/api/v1/map/nearby?lat=37.5665&lng=126.9780"
```

### 3. 로그 레벨 조정
```python
# app/main.py
logging.basicConfig(level=logging.DEBUG)  # 상세 로그
```

---

## 라이선스

MIT License

---

## API 문서 및 프론트엔드 연동

### 📚 API 문서

**Swagger UI (대화형 문서):**
- 로컬: http://localhost:8000/docs
- 프로덕션: https://yourdomain.com/docs

**ReDoc (깔끔한 문서):**
- 로컬: http://localhost:8000/redoc
- 프로덕션: https://yourdomain.com/redoc

**OpenAPI JSON:**
- 로컬: http://localhost:8000/openapi.json
- 파일: `openapi/openapi.json`

### 🔄 OpenAPI 스키마 생성

프론트엔드 개발을 위한 OpenAPI 스키마 생성:

```bash
# OpenAPI JSON/YAML 생성
python generate_openapi.py

# 생성된 파일 확인
ls openapi/
# openapi.json
# openapi.yaml
```

### 📱 Kotlin/Android 클라이언트 생성

**OpenAPI Generator 사용 (권장):**

```bash
# Retrofit2 클라이언트 생성
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g kotlin \
  -o android-client \
  --additional-properties=\
library=jvm-retrofit2,\
serializationLibrary=kotlinx_serialization,\
useCoroutines=true,\
packageName=com.soundmark.api
```

**자세한 연동 가이드:**
- [FRONTEND_INTEGRATION.md](FRONTEND_INTEGRATION.md) - Kotlin/Android 연동 전체 가이드
- API 클라이언트 코드 예시
- 인증 플로우 구현 방법
- Google Maps + Spotify SDK 연동

---

## 기여

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

## Contact

**Backend**: FastAPI + PostgreSQL + PostGIS  
**Frontend**: Kotlin Android App (별도 리포지토리)  
**API Version**: v0.1.0  

**GitHub**: [soundmark-back](https://github.com/your-repo/soundmark-back)  
**Issues**: [Report bugs or request features](https://github.com/your-repo/soundmark-back/issues)

---

## 참고 자료

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy 2.0 Docs](https://docs.sqlalchemy.org/en/20/)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [Spotify Web API](https://developer.spotify.com/documentation/web-api/)
- [Spotipy Library](https://spotipy.readthedocs.io/)
- [Alembic Docs](https://alembic.sqlalchemy.org/)

