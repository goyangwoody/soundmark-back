"""
Local development database setup script
로컬 PostgreSQL + PostGIS에 스키마 및 mock data 자동 설정
"""
import asyncio
import sys
import subprocess
from pathlib import Path


def run_command(command, description):
    """Run shell command and handle errors"""
    print(f"\n{'='*60}")
    print(f"📌 {description}")
    print(f"{'='*60}")
    print(f"$ {command}\n")
    
    result = subprocess.run(command, shell=True, capture_output=False, text=True)
    
    if result.returncode != 0:
        print(f"\n❌ Failed: {description}")
        return False
    
    print(f"\n✅ Success: {description}")
    return True


async def setup_database():
    """Setup local database"""
    print("\n" + "="*60)
    print("🚀 Soundmark Local Database Setup")
    print("="*60)
    
    # 1. Check if .env exists
    env_file = Path(".env")
    if not env_file.exists():
        print("\n❌ .env 파일이 없습니다. .env 파일을 먼저 생성하세요.")
        print("DATABASE_URL을 로컬 PostgreSQL로 설정해야 합니다.")
        print("예: DATABASE_URL=postgresql+asyncpg://soundmark:password@localhost:5432/soundmark_db")
        return False
    
    print("\n✅ .env 파일 확인됨")
    
    # 2. Run Alembic migrations
    if not run_command(
        "alembic upgrade head",
        "Alembic 마이그레이션 실행 (스키마 생성)"
    ):
        return False
    
    # 3. Seed mock data
    if not run_command(
        "python seed_data.py",
        "Mock 데이터 삽입"
    ):
        return False
    
    print("\n" + "="*60)
    print("🎉 로컬 데이터베이스 설정 완료!")
    print("="*60)
    print("\n다음 명령으로 서버를 실행하세요:")
    print("  uvicorn app.main:app --reload")
    print("\nAPI 문서:")
    print("  http://localhost:8000/docs")
    
    return True


async def main():
    """Main entry point"""
    try:
        success = await setup_database()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️  설정이 중단되었습니다.")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ 에러 발생: {e}")
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main())
