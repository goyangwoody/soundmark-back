# Local Development Guide

## 로컬 개발 환경 설정

### 1. 사전 요구사항

- Python 3.12+
- PostgreSQL 15+ with PostGIS extension
- 가상 환경 (venv)

### 2. PostgreSQL + PostGIS 설치

**Windows (PostgreSQL 설치 시 Stack Builder로 PostGIS 설치):**
```powershell
# PostgreSQL 다운로드: https://www.postgresql.org/download/windows/
# 설치 후 Stack Builder에서 PostGIS 선택하여 설치
```

**Mac (Homebrew):**
```bash
brew install postgresql postgis
brew services start postgresql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib postgis
sudo systemctl start postgresql
```

### 3. 데이터베이스 생성

```sql
-- PostgreSQL에 접속
psql -U postgres

-- 데이터베이스 및 사용자 생성
CREATE DATABASE soundmark_db;
CREATE USER soundmark WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE soundmark_db TO soundmark;

-- soundmark_db에 연결
\c soundmark_db

-- PostGIS extension 활성화
CREATE EXTENSION IF NOT EXISTS postgis;

-- 권한 부여 (PostgreSQL 15+)
GRANT ALL ON SCHEMA public TO soundmark;
```

### 4. 환경 변수 설정

`.env` 파일 생성:

```bash
# Database
DATABASE_URL=postgresql+asyncpg://soundmark:your_password@localhost:5432/soundmark_db

# Spotify OAuth
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
SPOTIFY_REDIRECT_URI=http://localhost:8000/api/v1/auth/callback

# JWT
JWT_SECRET_KEY=your-super-secret-key-min-32-characters-long
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_DAYS=7

# CORS
ALLOWED_ORIGINS=http://localhost:3000

# Debug
DEBUG=true
```

### 5. Python 가상 환경 및 의존성 설치

```powershell
# 가상 환경 생성
python -m venv venv

# 가상 환경 활성화
.\venv\Scripts\activate  # Windows
# source venv/bin/activate  # Mac/Linux

# 의존성 설치
pip install -r requirements.txt
```

### 6. 데이터베이스 초기화 (자동)

```powershell
# 스키마 생성 + mock data 삽입 (한 번에)
python setup_local_db.py
```

**또는 수동으로:**

```powershell
# 1. Alembic 마이그레이션 (스키마 생성)
alembic upgrade head

# 2. Mock 데이터 삽입
python seed_data.py
```

### 7. 서버 실행

```powershell
# 개발 서버 실행 (hot reload)
uvicorn app.main:app --reload

# 또는 포트 지정
uvicorn app.main:app --reload --port 8000
```

서버 실행 후:
- API: http://localhost:8000
- Swagger 문서: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

### 8. 데이터베이스 초기화 (재설정)

```powershell
# 1. 데이터 삭제
alembic downgrade base

# 2. 다시 초기화
python setup_local_db.py
```

---

## 프로덕션 배포 (Docker)

### 1. 환경 변수 설정 (.env)

```bash
# Database (Docker 내부)
DATABASE_URL=postgresql+asyncpg://soundmark:strong_password@db:5432/soundmark_db
POSTGRES_PASSWORD=strong_password

# Spotify OAuth (프로덕션 URL)
SPOTIFY_CLIENT_ID=your_production_client_id
SPOTIFY_CLIENT_SECRET=your_production_client_secret
SPOTIFY_REDIRECT_URI=https://yourdomain.com/api/v1/auth/callback

# JWT
JWT_SECRET_KEY=production-very-long-secret-key-min-32-chars
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_DAYS=7

# CORS
ALLOWED_ORIGINS=https://yourdomain.com,https://app.yourdomain.com

# Debug
DEBUG=false
```

### 2. Docker Compose로 배포

```bash
# 컨테이너 빌드 및 시작 (백그라운드)
docker compose up -d --build

# 로그 확인
docker compose logs -f

# DB 초기화는 자동 (db/init/*.sql 실행됨)
```

### 3. DB 초기화 (재배포 시)

```bash
# 볼륨 포함 완전 삭제
docker compose down -v

# 다시 시작 (DB init 스크립트 자동 실행)
docker compose up -d --build
```

---

## Mock Data 정보

**Users:** 5명
- 김민수, 이지은, 박준호, 최서연, 정우진

**Tracks:** 12곡
- K-Pop: BTS (Dynamite, Butter), PSY (Gangnam Style), IU (Celebrity)
- Pop: The Weeknd, Ed Sheeran, The Killers, Lewis Capaldi, etc.
- Indie: Glass Animals, Carly Rae Jepsen

**Places:** 10곳 (서울)
- 홍대, 강남, 명동, 남산타워, 경복궁, 한강공원, 이태원, 코엑스, 신촌, 건대

**Recommendations:** 15개
- 각 장소에 맥락에 맞는 음악 + 사용자 메시지

**Likes:** ~15개
- 사용자들이 서로의 추천에 좋아요

---

## 문제 해결

### PostGIS extension 에러

```sql
-- psql로 접속하여 확인
\c soundmark_db
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Alembic 마이그레이션 실패

```bash
# 마이그레이션 상태 확인
alembic current

# 마이그레이션 히스토리
alembic history

# 초기화
alembic downgrade base
alembic upgrade head
```

### DATABASE_URL 연결 실패

- PostgreSQL 서비스가 실행 중인지 확인
- 포트 5432가 열려있는지 확인
- 사용자 권한 확인

```sql
-- PostgreSQL에서 사용자 권한 확인
\du
```
