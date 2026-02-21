# OpenAPI Schema

이 디렉토리는 프론트엔드 연동을 위한 OpenAPI 스키마 파일을 포함합니다.

## 파일

- `openapi.json` - OpenAPI 3.0 스키마 (JSON 형식)
- `openapi.yaml` - OpenAPI 3.0 스키마 (YAML 형식, optional)

## 생성 방법

```bash
# OpenAPI 스키마 생성
python generate_openapi.py
```

## 사용

**Kotlin/Android에서 사용:**

1. **Retrofit + KotlinX Serialization**
   ```bash
   # OpenAPI Generator 사용
   openapi-generator-cli generate \
     -i openapi/openapi.json \
     -g kotlin \
     -o android-client \
     --additional-properties=library=jvm-retrofit2
   ```

2. **Ktor Client**
   ```bash
   openapi-generator-cli generate \
     -i openapi/openapi.json \
     -g kotlin \
     -o android-client \
     --additional-properties=library=jvm-ktor
   ```

**온라인 도구:**
- https://editor.swagger.io/ (Swagger Editor에서 스키마 편집/검증)
- https://generator.swagger.io/ (클라이언트 코드 생성)

## API 문서

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json
