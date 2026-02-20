# Soundmark API

**위치 기반 소셜 음악 추천 플랫폼 백엔드**

사용자가 특정 장소(좌표)에 노래를 "묻어두고", 다른 사용자는 해당 장소 반경 200m 이내에 도착했을 때만 추천 음악의 상세 정보를 볼 수 있는 서비스입니다.

## 핵심 기능

- **위치 기반 음악 추천**: 특정 좌표에 Spotify 트랙을 추천으로 등록
- **거리 기반 접근 제어**: 200m 이내에서만 추천곡 상세 정보 확인 가능
- **Spotify 연동**: Spotify OAuth 로그인 및 트랙 메타데이터 연동
- **지도 API**: 가까운 핀은 개별 표시, 먼 핀은 개수만 클러스터링
- **소셜 기능**: 좋아요 토글

## 기술 스택

- **Framework**: FastAPI
- **Database**: PostgreSQL 15 + PostGIS (지리 공간 데이터)
- **ORM**: SQLAlchemy 2.0 (async)
- **Authentication**: JWT + Spotify OAuth
- **Migration**: Alembic
- **Testing**: Pytest
- **Containerization**: Docker + Docker Compose

## 프로젝트 구조

```
soundmark-api/
├── app/
│   ├── api/v1/          # API 라우트
│   ├── core/            # 설정, 보안
│   ├── models/          # SQLAlchemy 모델
│   ├── schemas/         # Pydantic 스키마
│   ├── services/        # 비즈니스 로직
│   ├── database.py      # DB 연결
│   └── main.py          # FastAPI 앱
├── alembic/             # DB 마이그레이션
├── tests/               # 테스트
├── docker-compose.yml
├── Dockerfile
└── requirements.txt
```

## 시작하기

### 1. 환경 설정

```bash
# .env 파일 생성
cp .env.example .env

# .env 파일 편집 - Spotify 앱 정보 입력 필요
# https://developer.spotify.com/dashboard 에서 앱 생성
```

**필수 환경 변수:**
- `SPOTIFY_CLIENT_ID`: Spotify 개발자 대시보드에서 발급
- `SPOTIFY_CLIENT_SECRET`: Spotify 개발자 대시보드에서 발급
- `SPOTIFY_REDIRECT_URI`: OAuth 콜백 URL
- `JWT_SECRET_KEY`: JWT 서명용 비밀키 (32자 이상)

### 2. Docker Compose로 실행

```bash
# 컨테이너 빌드 및 실행
docker-compose up -d

# 로그 확인
docker-compose logs -f api
```

### 3. 데이터베이스 마이그레이션

```bash
# 컨테이너 내부에서 실행
docker-compose exec api alembic upgrade head
```

### 4. API 접속

- API 문서: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

## Spotify 앱 등록

1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) 접속
2. "Create an App" 클릭
3. 앱 이름: "Soundmark" (또는 원하는 이름)
4. Redirect URIs 추가: `http://127.0.0.1:8000/api/v1/auth/spotify/callback`
   - **주의**: `localhost`는 허용되지 않고 loopback IP(`127.0.0.1`)를 사용해야 합니다
5. Client ID와 Client Secret을 `.env` 파일에 입력

## 주요 API 엔드포인트

### 인증
- `GET /api/v1/auth/spotify/login` - Spotify 로그인 URL 반환
- `POST /api/v1/auth/spotify/callback` - OAuth 콜백 처리
- `GET /api/v1/auth/me` - 현재 사용자 정보

### 추천곡
- `POST /api/v1/recommendations` - 추천곡 등록
- `GET /api/v1/recommendations/{id}` - 추천곡 상세 (거리 제한)
- `PUT /api/v1/recommendations/{id}/like` - 좋아요 토글

### 지도
- `GET /api/v1/map/nearby` - 주변 추천곡 조회

## 개발 환경

### 로컬에서 실행 (Docker 없이)

```bash
# 가상환경 생성
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 의존성 설치
pip install -r requirements.txt

# PostgreSQL + PostGIS 필요 (로컬 설치 또는 Docker로만 DB 실행)
docker-compose up -d postgres

# 애플리케이션 실행
uvicorn app.main:app --reload
```

### 테스트 실행

```bash
# 모든 테스트 실행
pytest

# 특정 테스트 파일 실행
pytest tests/test_api/test_recommendations.py

# 커버리지 포함
pytest --cov=app tests/
```

## 데이터베이스 스키마

### 핵심 테이블
- `users`: 사용자 정보 (Spotify 프로필)
- `oauth_accounts`: Spotify OAuth 토큰
- `tracks`: Spotify 트랙 메타데이터
- `places`: 장소 정보 (선택적)
- `recommendations`: 위치 기반 추천곡 (PostGIS POINT)
- `recommendation_likes`: 좋아요 관계
- `follows`: 팔로우 관계 (향후 기능)

### PostGIS 기능
- **거리 계산**: `ST_DWithin`, `ST_Distance` 함수 사용
- **공간 인덱스**: GIST 인덱스로 빠른 거리 쿼리

## MVP 설계 결정사항

- **활성 반경**: 200m 고정
- **비활성 핀**: 격자 클러스터링으로 개수만 표시
- **중복 정책**: DB 제약 없음 (유연성 확보)
- **위변조 방지**: MVP에서 제외 (클라이언트 좌표 신뢰)
- **미디어**: 사진 없음, 텍스트(message/note)만

## 라이선스

MIT

## Contact

Backend: FastAPI  
Frontend: Kotlin Android App
