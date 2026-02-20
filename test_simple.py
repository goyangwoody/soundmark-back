"""
간단한 API 동작 확인 테스트
"""
import requests
import json

BASE_URL = "http://localhost:8000"

def test_health_check():
    """서버 헬스 체크"""
    print("\n=== 1. Health Check ===")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2, ensure_ascii=False)}")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"
    print("✅ Health check 성공!")


def test_root_endpoint():
    """루트 엔드포인트 테스트"""
    print("\n=== 2. Root Endpoint ===")
    response = requests.get(f"{BASE_URL}/")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2, ensure_ascii=False)}")
    assert response.status_code == 200
    print("✅ Root endpoint 성공!")


def test_spotify_login():
    """Spotify 로그인 URL 생성 테스트"""
    print("\n=== 3. Spotify Login URL ===")
    response = requests.get(f"{BASE_URL}/api/v1/auth/spotify/login")
    print(f"Status: {response.status_code}")
    data = response.json()
    if response.status_code == 200:
        print(f"Authorization URL: {data.get('authorization_url', 'N/A')[:100]}...")
        assert "authorization_url" in data
        assert "spotify.com" in data["authorization_url"]
        print("✅ Spotify login URL 생성 성공!")
    else:
        print(f"Response: {json.dumps(data, indent=2, ensure_ascii=False)}")


def test_unauthorized_access():
    """인증 없이 보호된 엔드포인트 접근 테스트"""
    print("\n=== 4. Unauthorized Access ===")
    response = requests.get(f"{BASE_URL}/api/v1/auth/me")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2, ensure_ascii=False)}")
    # FastAPI HTTPBearer는 403을 반환함
    assert response.status_code in [401, 403]
    print("✅ 인증 없는 접근 차단 성공!")


def test_api_docs():
    """API 문서 접근 테스트"""
    print("\n=== 5. API Documentation ===")
    response = requests.get(f"{BASE_URL}/docs")
    print(f"Status: {response.status_code}")
    assert response.status_code == 200
    print("✅ API 문서 접근 성공!")
    print(f"Swagger UI: {BASE_URL}/docs")
    print(f"ReDoc: {BASE_URL}/redoc")


if __name__ == "__main__":
    print("=" * 60)
    print("🚀 Soundmark API 테스트 시작")
    print("=" * 60)
    
    try:
        test_health_check()
        test_root_endpoint()
        test_spotify_login()
        test_unauthorized_access()
        test_api_docs()
        
        print("\n" + "=" * 60)
        print("✅ 모든 테스트 통과!")
        print("=" * 60)
        
    except requests.exceptions.ConnectionError:
        print("\n❌ 오류: 서버에 연결할 수 없습니다.")
        print("서버가 실행 중인지 확인하세요: python -m uvicorn app.main:app --reload")
        
    except AssertionError as e:
        print(f"\n❌ 테스트 실패: {e}")
        
    except Exception as e:
        print(f"\n❌ 예상치 못한 오류: {e}")
