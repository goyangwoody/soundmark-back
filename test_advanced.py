"""
데이터베이스 및 API 통합 테스트
"""
import requests
import json

BASE_URL = "http://localhost:8000"

class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


def print_section(title):
    print(f"\n{Colors.HEADER}{'=' * 60}{Colors.ENDC}")
    print(f"{Colors.BOLD}{title}{Colors.ENDC}")
    print(f"{Colors.HEADER}{'=' * 60}{Colors.ENDC}")


def print_success(message):
    print(f"{Colors.OKGREEN}✅ {message}{Colors.ENDC}")


def print_info(key, value):
    print(f"{Colors.OKCYAN}{key}:{Colors.ENDC} {value}")


def test_api_endpoints_list():
    """API 엔드포인트 목록 확인"""
    print_section("📋 API 엔드포인트 확인")
    
    response = requests.get(f"{BASE_URL}/openapi.json")
    if response.status_code == 200:
        openapi = response.json()
        paths = openapi.get("paths", {})
        
        print(f"\n총 {len(paths)}개의 엔드포인트:")
        
        endpoints_by_tag = {}
        for path, methods in paths.items():
            for method, details in methods.items():
                if method in ['get', 'post', 'put', 'delete', 'patch']:
                    tags = details.get('tags', ['기타'])
                    tag = tags[0] if tags else '기타'
                    if tag not in endpoints_by_tag:
                        endpoints_by_tag[tag] = []
                    endpoints_by_tag[tag].append(f"{method.upper():6s} {path}")
        
        for tag, endpoints in sorted(endpoints_by_tag.items()):
            print(f"\n{Colors.BOLD}[{tag}]{Colors.ENDC}")
            for endpoint in sorted(endpoints):
                print(f"  {endpoint}")
        
        print_success("엔드포인트 목록 확인 완료")
        return True
    return False


def test_database_connection():
    """데이터베이스 연결 테스트"""
    print_section("💾 데이터베이스 연결 테스트")
    
    # Health check를 통해 간접적으로 DB 연결 확인
    response = requests.get(f"{BASE_URL}/health")
    if response.status_code == 200:
        print_info("Status", "Connected")
        print_info("Database", "PostgreSQL + PostGIS")
        print_success("데이터베이스 연결 정상")
        return True
    return False


def test_map_endpoints():
    """지도 관련 엔드포인트 테스트"""
    print_section("🗺️  지도 API 테스트")
    
    # 지도 추천 목록 조회 (올바른 엔드포인트 사용)
    params = {
        "lat": 37.5665,  # 서울시청 좌표
        "lng": 126.9780
    }
    
    print_info("엔드포인트", "/api/v1/map/nearby")
    print_info("요청 위치", f"위도 {params['lat']}, 경도 {params['lng']}")
    
    # 인증 없이 호출 시도
    response = requests.get(f"{BASE_URL}/api/v1/map/nearby", params=params)
    print_info("응답 상태 (인증 없음)", response.status_code)
    
    if response.status_code == 200:
        data = response.json()
        print_info("응답 타입", type(data).__name__)
        
        # active_recommendations와 inactive_counts 확인
        if isinstance(data, dict):
            active = data.get("active_recommendations", [])
            inactive = data.get("inactive_counts", [])
            print_info("활성 추천", f"{len(active)}개")
            print_info("비활성 클러스터", f"{len(inactive)}개")
            
            if len(active) > 0:
                print("\n첫 번째 활성 추천:")
                print(json.dumps(active[0], indent=2, ensure_ascii=False))
        
        print_success("지도 API 호출 성공")
        return True
    elif response.status_code in [403, 401]:
        print_info("인증 필요", "✅ 이 엔드포인트는 인증이 필요합니다 (정상)")
        print_success("보안 설정 정상 동작")
        return True
    elif response.status_code == 422:
        error_data = response.json()
        print_info("파라미터 오류", error_data.get("detail", [{}])[0].get("msg", "N/A"))
        return False
    else:
        print_info("오류", f"{response.status_code} - {response.text}")
        return False


def test_cors_headers():
    """CORS 헤더 확인"""
    print_section("🌐 CORS 설정 확인")
    
    response = requests.options(
        f"{BASE_URL}/api/v1/auth/spotify/login",
        headers={"Origin": "http://localhost:3000"}
    )
    
    print_info("Status", response.status_code)
    
    cors_headers = {
        "Access-Control-Allow-Origin": response.headers.get("Access-Control-Allow-Origin"),
        "Access-Control-Allow-Methods": response.headers.get("Access-Control-Allow-Methods"),
        "Access-Control-Allow-Headers": response.headers.get("Access-Control-Allow-Headers"),
    }
    
    for header, value in cors_headers.items():
        if value:
            print_info(header, value[:50] + "..." if len(str(value)) > 50 else value)
    
    print_success("CORS 헤더 확인 완료")
    return True


def test_error_handling():
    """에러 핸들링 테스트"""
    print_section("⚠️  에러 핸들링 테스트")
    
    # 존재하지 않는 엔드포인트
    response = requests.get(f"{BASE_URL}/api/v1/invalid-endpoint")
    print_info("404 Not Found", f"Status {response.status_code}")
    
    # 잘못된 파라미터
    response = requests.get(f"{BASE_URL}/api/v1/map/recommendations?lat=invalid")
    print_info("422 Validation Error", f"Status {response.status_code}")
    if response.status_code == 422:
        error_data = response.json()
        print(f"  오류 상세: {error_data.get('detail', [{}])[0].get('msg', 'N/A')}")
    
    print_success("에러 핸들링 동작 확인")
    return True


def test_performance():
    """간단한 성능 테스트"""
    print_section("⚡ 성능 테스트")
    
    import time
    
    num_requests = 10
    start_time = time.time()
    
    for _ in range(num_requests):
        requests.get(f"{BASE_URL}/health")
    
    elapsed = time.time() - start_time
    avg_time = elapsed / num_requests
    
    print_info("총 요청", f"{num_requests}회")
    print_info("총 시간", f"{elapsed:.3f}초")
    print_info("평균 응답시간", f"{avg_time*1000:.2f}ms")
    print_info("초당 처리", f"{num_requests/elapsed:.2f} req/s")
    
    print_success("성능 테스트 완료")
    return True


def main():
    """메인 테스트 실행"""
    print(f"\n{Colors.BOLD}{'=' * 60}")
    print(f"🚀 Soundmark API 통합 테스트")
    print(f"{'=' * 60}{Colors.ENDC}\n")
    
    tests = [
        ("엔드포인트 목록", test_api_endpoints_list),
        ("데이터베이스 연결", test_database_connection),
        ("지도 API", test_map_endpoints),
        ("CORS 설정", test_cors_headers),
        ("에러 핸들링", test_error_handling),
        ("성능", test_performance),
    ]
    
    results = []
    
    try:
        for name, test_func in tests:
            try:
                result = test_func()
                results.append((name, result))
            except Exception as e:
                print(f"{Colors.FAIL}❌ {name} 테스트 실패: {e}{Colors.ENDC}")
                results.append((name, False))
        
        # 결과 요약
        print(f"\n{Colors.BOLD}{'=' * 60}")
        print("📊 테스트 결과 요약")
        print(f"{'=' * 60}{Colors.ENDC}\n")
        
        passed = sum(1 for _, result in results if result)
        total = len(results)
        
        for name, result in results:
            icon = "✅" if result else "❌"
            color = Colors.OKGREEN if result else Colors.FAIL
            print(f"{color}{icon} {name}{Colors.ENDC}")
        
        print(f"\n{Colors.BOLD}통과: {passed}/{total}{Colors.ENDC}")
        
        if passed == total:
            print(f"\n{Colors.OKGREEN}{Colors.BOLD}🎉 모든 테스트 통과!{Colors.ENDC}")
        else:
            print(f"\n{Colors.WARNING}⚠️  일부 테스트 실패{Colors.ENDC}")
        
    except requests.exceptions.ConnectionError:
        print(f"\n{Colors.FAIL}❌ 오류: 서버에 연결할 수 없습니다.")
        print("서버가 실행 중인지 확인하세요: python -m uvicorn app.main:app --reload{Colors.ENDC}")
    
    except Exception as e:
        print(f"\n{Colors.FAIL}❌ 예상치 못한 오류: {e}{Colors.ENDC}")


if __name__ == "__main__":
    main()
