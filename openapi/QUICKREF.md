# OpenAPI Schema - Quick Reference

## 📋 파일 위치

- `openapi/openapi.json` - OpenAPI 3.1 스키마 (JSON)
- `openapi/openapi.yaml` - OpenAPI 3.1 스키마 (YAML)

## 🔄 스키마 재생성

```bash
python generate_openapi.py
```

## 📊 API 엔드포인트 목록

### Authentication (`/api/v1/auth`)
- `POST /spotify/verify` - ⭐ Spotify 토큰 검증 및 JWT 발급 (권장)
- `GET  /spotify/login` - ⚠️ Spotify 로그인 URL 획득 (Deprecated)
- `POST /spotify/callback` - ⚠️ OAuth callback 처리 및 JWT 발급 (Deprecated)
- `GET  /me` - 현재 사용자 정보 조회 🔒
- `POST /refresh` - JWT 토큰 갱신 🔒

### Recommendations (`/api/v1/recommendations`)
- `POST /` - 새 추천 생성 🔒
- `GET  /{recommendation_id}` - 추천 상세 조회 🔒
- `PUT  /{recommendation_id}/reactions` - 이모지 반응 추가/변경 🔒
- `DELETE /{recommendation_id}/reactions` - 이모지 반응 제거 🔒

### Map (`/api/v1/map`)
- `GET  /nearby` - 주변 추천 조회 (위도/경도 기반) 🔒

### Users & Follow (`/api/v1/users`)
- `GET  /me` - 내 프로필 조회 (추천 피드 포함) 🔒
- `PATCH /me` - 내 프로필 수정 (표시이름/프로필사진/상태메시지) 🔒
- `GET  /me/recently-played` - Spotify 최근 재생 기록 3곡 조회 🔒
- `GET  /me/place-recommendations` - 최근 재생곡 장르 기반 장소 추천 🔒
- `GET  /{user_id}` - 사용자 프로필 및 팔로우 통계 조회 (추천 피드 포함)
- `POST /{user_id}/follow` - 사용자 팔로우 🔒
- `DELETE /{user_id}/follow` - 사용자 언팔로우 🔒
- `GET  /{user_id}/followers` - 팔로워 목록 조회
- `GET  /{user_id}/following` - 팔로잉 목록 조회

### Health
- `GET  /health` - 서버 상태 확인
- `GET  /` - API 정보

🔒 = JWT Authentication 필요

## 🔐 Authentication

모든 인증이 필요한 엔드포인트는 `Authorization` 헤더에 Bearer 토큰 필요:

```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

## 📱 프론트엔드 연동

자세한 Kotlin/Android 연동 가이드: [FRONTEND_INTEGRATION.md](../FRONTEND_INTEGRATION.md)

## 🌐 온라인 도구

- **Swagger Editor**: https://editor.swagger.io/ (스키마 편집/검증)
- **OpenAPI Generator**: https://openapi-generator.tech/ (클라이언트 생성)
- **Postman**: Import OpenAPI 스키마로 자동 컬렉션 생성

## 📦 클라이언트 생성 예시

### Kotlin (Retrofit2)
```bash
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g kotlin \
  -o android-client \
  --additional-properties=library=jvm-retrofit2
```

### TypeScript (Axios)
```bash
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g typescript-axios \
  -o web-client
```

### Python
```bash
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g python \
  -o python-client
```

## 🔍 스키마 검증

```bash
python validate_openapi.py
```
