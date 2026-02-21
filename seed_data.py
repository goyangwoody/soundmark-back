"""
Mock data seeding script for Soundmark database (Local Development)
로컬 개발 환경에서 사용. 배포는 docker-compose의 db/init/*.sql 사용
"""
import asyncio
from datetime import datetime, timedelta
from sqlalchemy import select
from geoalchemy2.elements import WKTElement

from app.database import AsyncSessionLocal
from app.models.user import User
from app.models.track import Track
from app.models.place import Place
from app.models.recommendation import Recommendation
from app.models.oauth import OAuthAccount
from app.models.like import RecommendationLike


async def seed_users(session):
    """Create mock users"""
    users_data = [
        {
            "spotify_id": "spotify_user_minsu",
            "display_name": "김민수",
            "email": "minsu.kim@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=11"
        },
        {
            "spotify_id": "spotify_user_jieun",
            "display_name": "이지은",
            "email": "jieun.lee@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=22"
        },
        {
            "spotify_id": "spotify_user_junho",
            "display_name": "박준호",
            "email": "junho.park@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=33"
        },
        {
            "spotify_id": "spotify_user_seoyeon",
            "display_name": "최서연",
            "email": "seoyeon.choi@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=44"
        },
        {
            "spotify_id": "spotify_user_woojin",
            "display_name": "정우진",
            "email": "woojin.jung@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=55"
        }
    ]
    
    users = []
    for user_data in users_data:
        user = User(**user_data)
        session.add(user)
        users.append(user)
    
    await session.flush()
    print(f"✓ Created {len(users)} users")
    return users


async def seed_oauth_accounts(session, users):
    """Create mock OAuth accounts"""
    oauth_accounts = []
    for i, user in enumerate(users):
        oauth = OAuthAccount(
            user_id=user.id,
            provider="spotify",
            access_token=f"mock_access_token_{user.id}_" + "x" * 200,
            refresh_token=f"mock_refresh_token_{user.id}_" + "y" * 200,
            expires_at=datetime.utcnow() + timedelta(hours=1)
        )
        session.add(oauth)
        oauth_accounts.append(oauth)
    
    await session.flush()
    print(f"✓ Created {len(oauth_accounts)} OAuth accounts")
    return oauth_accounts


async def seed_tracks(session):
    """Create mock tracks (Real Spotify Track IDs)"""
    tracks_data = [
        # K-Pop
        {
            "spotify_track_id": "0tgVpDi06FyKpA1z0VMD4v",
            "title": "Dynamite",
            "artist": "BTS",
            "album": "BE",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c9b6b22f5f2c2b0e8f3f3c8a",
            "track_url": "https://open.spotify.com/track/0tgVpDi06FyKpA1z0VMD4v",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "5sdQOyqq2IDhvmx2lHOpwd",
            "title": "Butter",
            "artist": "BTS",
            "album": "Butter",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2731be40024e992c1c8f2d39e87",
            "track_url": "https://open.spotify.com/track/5sdQOyqq2IDhvmx2lHOpwd",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "3XF5xLJHOQQRbWya6hBp7d",
            "title": "Gangnam Style",
            "artist": "PSY",
            "album": "Psy 6 (Six Rules), Part 1",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c9c2b1e08d3d9f0d6b8e6f5e",
            "track_url": "https://open.spotify.com/track/3XF5xLJHOQQRbWya6hBp7d",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "5jjmGBEHWVWeDYCpRnqRXC",
            "title": "Celebrity",
            "artist": "IU (아이유)",
            "album": "Celebrity",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2734ed058b71650a6ca2c04adff",
            "track_url": "https://open.spotify.com/track/5jjmGBEHWVWeDYCpRnqRXC",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        # Pop
        {
            "spotify_track_id": "0VjIjW4GlUZAMYd2vXMi3b",
            "title": "Blinding Lights",
            "artist": "The Weeknd",
            "album": "After Hours",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36",
            "track_url": "https://open.spotify.com/track/0VjIjW4GlUZAMYd2vXMi3b",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "7qiZfU4dY1lWllzX7mPBIP",
            "title": "Shape of You",
            "artist": "Ed Sheeran",
            "album": "÷ (Divide)",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96",
            "track_url": "https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBIP",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "3n3Ppam7vgaVa1iaRUc9Lp",
            "title": "Mr. Brightside",
            "artist": "The Killers",
            "album": "Hot Fuss",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273ccdddd46119a4ff53eaf1f5d",
            "track_url": "https://open.spotify.com/track/3n3Ppam7vgaVa1iaRUc9Lp",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "6DCZcSspjsKoFjzjrWoCdn",
            "title": "Someone You Loved",
            "artist": "Lewis Capaldi",
            "album": "Divinely Uninspired to a Hellish Extent",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2732d898688788a04f0c3c1c3c1",
            "track_url": "https://open.spotify.com/track/6DCZcSspjsKoFjzjrWoCdn",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "2takcwOaAZWiXQijPHIx7B",
            "title": "Time After Time",
            "artist": "Cyndi Lauper",
            "album": "She's So Unusual",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273e8e8e8e8e8e8e8e8e8e8e8e8",
            "track_url": "https://open.spotify.com/track/2takcwOaAZWiXQijPHIx7B",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "3XVBdLihbNbxUwZosxcGuJ",
            "title": "Skyfall",
            "artist": "Adele",
            "album": "Skyfall",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c4b4e2e2e2e2e2e2e2e2e2e2",
            "track_url": "https://open.spotify.com/track/3XVBdLihbNbxUwZosxcGuJ",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        # Indie/Alternative
        {
            "spotify_track_id": "2gNfxysfBRfl9Lvi9T3v6R",
            "title": "Heat Waves",
            "artist": "Glass Animals",
            "album": "Dreamland",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c4c4c4c4c4c4c4c4c4c4c4c4",
            "track_url": "https://open.spotify.com/track/2gNfxysfBRfl9Lvi9T3v6R",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "11dFghVXANMlKmJXsNCbNl",
            "title": "Cut to the Feeling",
            "artist": "Carly Rae Jepsen",
            "album": "Emotion",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2735e5e5e5e5e5e5e5e5e5e5e5e",
            "track_url": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        }
    ]
    
    tracks = []
    for track_data in tracks_data:
        track = Track(**track_data)
        session.add(track)
        tracks.append(track)
    
    await session.flush()
    print(f"✓ Created {len(tracks)} tracks")
    return tracks


async def seed_places(session):
    """Create mock places in Seoul"""
    places_data = [
        {
            "google_place_id": "ChIJceK-7y2efDURqDrut9x_93s",
            "place_name": "홍대입구역",
            "address": "서울특별시 마포구 양화로 160",
            "lat": 37.5563,
            "lng": 126.9236
        },
        {
            "google_place_id": "ChIJ9VHpNT-ifDURmZ1bZt0nPTM",
            "place_name": "강남역",
            "address": "서울특별시 강남구 강남대로 396",
            "lat": 37.4979,
            "lng": 127.0276
        },
        {
            "google_place_id": "ChIJwckXZEGjfDUR7anLn7hhvH4",
            "place_name": "명동성당",
            "address": "서울특별시 중구 명동길 74",
            "lat": 37.5633,
            "lng": 126.9864
        },
        {
            "google_place_id": "ChIJaQ6kcOCjfDURVQi5FepCp4Y",
            "place_name": "남산서울타워",
            "address": "서울특별시 용산구 남산공원길 105",
            "lat": 37.5511,
            "lng": 126.9882
        },
        {
            "google_place_id": "ChIJ67J9IrulfDURjt27f3_IOJo",
            "place_name": "경복궁",
            "address": "서울특별시 종로구 사직로 161",
            "lat": 37.5788,
            "lng": 126.9770
        },
        {
            "google_place_id": "ChIJJbdq3P6hfDURGYfxTSQzB-U",
            "place_name": "한강공원 여의도",
            "address": "서울특별시 영등포구 여의동로 330",
            "lat": 37.5285,
            "lng": 126.9322
        },
        {
            "google_place_id": "ChIJlfK8TdelfDURlPe-Yz3gdJw",
            "place_name": "이태원역",
            "address": "서울특별시 용산구 이태원로 177",
            "lat": 37.5344,
            "lng": 126.9944
        },
        {
            "google_place_id": "ChIJQVwKq6WhfDURiE6p_0m9DLM",
            "place_name": "코엑스",
            "address": "서울특별시 강남구 영동대로 513",
            "lat": 37.5115,
            "lng": 127.0595
        },
        {
            "google_place_id": "ChIJ-ScHw42efDURi0lYN0t5nWU",
            "place_name": "신촌역",
            "address": "서울특별시 서대문구 신촌역로 90",
            "lat": 37.5551,
            "lng": 126.9369
        },
        {
            "google_place_id": "ChIJy_w8WhSifDUR3aEKu4Zx7CU",
            "place_name": "건대입구역",
            "address": "서울특별시 광진구 아차산로 243",
            "lat": 37.5404,
            "lng": 127.0695
        }
    ]
    
    places = []
    for place_data in places_data:
        lat = place_data['lat']
        lng = place_data['lng']
        
        place = Place(
            google_place_id=place_data['google_place_id'],
            place_name=place_data['place_name'],
            address=place_data['address'],
            lat=lat,
            lng=lng,
            geom=WKTElement(f'POINT({lng} {lat})', srid=4326)
        )
        session.add(place)
        places.append(place)
    
    await session.flush()
    print(f"✓ Created {len(places)} places")
    return places


async def seed_recommendations(session, users, tracks, places):
    """Create mock recommendations matching 02_seed.sql"""
    recommendations_data = [
        # 홍대
        {"user": 0, "track": 2, "place": 0, "lat": 37.5565, "lng": 126.9238,
         "message": "홍대 클럽 앞에서 이 노래 나왔을 때 최고였어요! 🎉",
         "note": "친구들이랑 신나게 춤추면서 들었던 기억이 나요. 강남스타일은 역시 홍대 분위기랑 찰떡!",
         "days_ago": 7},
        {"user": 1, "track": 10, "place": 0, "lat": 37.5560, "lng": 126.9240,
         "message": "홍대 카페거리에서 작업할 때 들으면 집중 잘돼요",
         "note": "Heat Waves 들으면서 홍대 카페에서 노트북 작업하는 게 제 루틴이에요. 감성 충만합니다.",
         "days_ago": 5},
        # 강남
        {"user": 2, "track": 0, "place": 1, "lat": 37.4982, "lng": 127.0279,
         "message": "출근길 강남역에서 듣는 Dynamite로 하루 시작! 💜",
         "note": "매일 아침 강남역 9번 출구 나오면서 이 노래 들으면 힘이 나요. BTS 최고!",
         "days_ago": 3},
        {"user": 3, "track": 4, "place": 1, "lat": 37.4976, "lng": 127.0273,
         "message": "강남 밤거리는 Blinding Lights와 함께 🌃",
         "note": None,
         "days_ago": 2},
        # 명동
        {"user": 4, "track": 5, "place": 2, "lat": 37.5635, "lng": 126.9867,
         "message": "명동 쇼핑하면서 듣기 좋은 노래예요",
         "note": "에드 시런의 Shape of You는 쇼핑할 때 듣기 딱 좋더라고요. 신나고 경쾌해요!",
         "days_ago": 6},
        {"user": 0, "track": 3, "place": 2, "lat": 37.5630, "lng": 126.9862,
         "message": "명동성당 앞에서 우연히 들은 IU 노래 🎵",
         "note": "명동성당 앞 카페에서 이 노래가 나와서 묻어뒀어요. Celebrity는 언제 들어도 좋네요.",
         "days_ago": 8},
        # 남산
        {"user": 1, "track": 7, "place": 3, "lat": 37.5513, "lng": 126.9885,
         "message": "남산에서 야경 보면서 듣기 좋은 발라드 💕",
         "note": "연인과 남산타워에서 야경 보면서 이 노래 들었는데 너무 좋았어요. 추억의 노래가 됐습니다.",
         "days_ago": 10},
        # 경복궁
        {"user": 2, "track": 3, "place": 4, "lat": 37.5790, "lng": 126.9772,
         "message": "경복궁 산책하며 듣는 한국 음악 최고",
         "note": "한복 입고 경복궁 돌아다니면서 아이유 노래 들으니까 분위기 완전 대박이었어요!",
         "days_ago": 4},
        # 한강
        {"user": 3, "track": 8, "place": 5, "lat": 37.5287, "lng": 126.9325,
         "message": "한강에서 치맥하면서 듣기 좋은 노래 🌊",
         "note": "여의도 한강공원에서 치킨이랑 맥주 먹으면서 이 노래 틀었는데 분위기 죽여요!",
         "days_ago": 1},
        {"user": 4, "track": 11, "place": 5, "lat": 37.5283, "lng": 126.9320,
         "message": "한강 자전거 타면서 듣기 완벽한 곡",
         "note": "자전거 타고 한강 달리면서 이 노래 들으면 기분 최고예요. Carly Rae Jepsen 신나요!",
         "days_ago": 5},
        # 이태원
        {"user": 0, "track": 6, "place": 6, "lat": 37.5346, "lng": 126.9947,
         "message": "이태원 루프탑 바에서 듣던 노래예요 🍹",
         "note": "The Killers의 Mr. Brightside는 이태원 분위기랑 찰떡입니다. 외국 느낌 나서 좋아요.",
         "days_ago": 9},
        # 코엑스
        {"user": 1, "track": 9, "place": 7, "lat": 37.5117, "lng": 127.0598,
         "message": "코엑스 별마당 도서관에서 듣는 Adele",
         "note": "코엑스 별마당 도서관에서 책 읽으면서 이 노래 귀로 작게 들었어요. 집중 잘돼요.",
         "days_ago": 11},
        # 신촌
        {"user": 2, "track": 1, "place": 8, "lat": 37.5553, "lng": 126.9371,
         "message": "신촌 먹자골목에서 친구들이랑 신남! 🎊",
         "note": "신촌 먹자골목 포차에서 친구들이랑 소주 마시면서 BTS Butter 틀었어요. 완전 신나요!",
         "days_ago": 6},
        # 건대
        {"user": 3, "track": 10, "place": 9, "lat": 37.5406, "lng": 127.0698,
         "message": "건대 클럽 앞에서 대기할 때 들은 노래",
         "note": "건대 클럽 입장 줄 서면서 들었던 Heat Waves. 분위기 업 시키기 좋아요!",
         "days_ago": 2}
    ]
    
    recommendations = []
    for rec_data in recommendations_data:
        user = users[rec_data["user"]]
        track = tracks[rec_data["track"]]
        place = places[rec_data["place"]]
        
        recommendation = Recommendation(
            user_id=user.id,
            track_id=track.id,
            place_id=place.id,
            lat=rec_data["lat"],
            lng=rec_data["lng"],
            geom=WKTElement(f'POINT({rec_data["lng"]} {rec_data["lat"]})', srid=4326),
            message=rec_data["message"],
            note=rec_data["note"],
            created_at=datetime.utcnow() - timedelta(days=rec_data["days_ago"]),
            updated_at=datetime.utcnow() - timedelta(days=rec_data["days_ago"])
        )
        session.add(recommendation)
        recommendations.append(recommendation)
    
    await session.flush()
    print(f"✓ Created {len(recommendations)} recommendations")
    return recommendations


async def seed_likes(session, users, recommendations):
    """Create mock likes"""
    import random
    
    likes = []
    
    # Each user likes 2-4 recommendations from other users
    for user in users:
        other_recommendations = [r for r in recommendations if r.user_id != user.id]
        num_likes = min(random.randint(2, 4), len(other_recommendations))
        liked_recommendations = random.sample(other_recommendations, num_likes)
        
        for recommendation in liked_recommendations:
            like = RecommendationLike(
                recommendation_id=recommendation.id,
                user_id=user.id,
                created_at=datetime.utcnow() - timedelta(days=random.randint(0, 10))
            )
            session.add(like)
            likes.append(like)
    
    await session.flush()
    print(f"✓ Created {len(likes)} likes")
    return likes


async def main():
    """Main seeding function"""
    print("\n🌱 Starting database seeding...\n")
    
    async with AsyncSessionLocal() as session:
        try:
            users = await seed_users(session)
            oauth_accounts = await seed_oauth_accounts(session, users)
            tracks = await seed_tracks(session)
            places = await seed_places(session)
            recommendations = await seed_recommendations(session, users, tracks, places)
            likes = await seed_likes(session, users, recommendations)
            
            await session.commit()
            
            print("\n✅ Database seeding completed successfully!")
            print(f"\nSummary:")
            print(f"  - Users: {len(users)}")
            print(f"  - OAuth Accounts: {len(oauth_accounts)}")
            print(f"  - Tracks: {len(tracks)}")
            print(f"  - Places: {len(places)}")
            print(f"  - Recommendations: {len(recommendations)}")
            print(f"  - Likes: {len(likes)}")
            
        except Exception as e:
            await session.rollback()
            print(f"\n❌ Error during seeding: {e}")
            raise


if __name__ == "__main__":
    asyncio.run(main())

            "email": "seoyeon@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=4"
        },
        {
            "spotify_id": "spotify_user_005",
            "display_name": "정우진",
            "email": "woojin@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=5"
        }
    ]
    
    users = []
    for user_data in users_data:
        user = User(**user_data)
        session.add(user)
        users.append(user)
    
    await session.flush()  # Get IDs
    print(f"✓ Created {len(users)} users")
    return users


async def seed_oauth_accounts(session, users):
    """Create mock OAuth accounts"""
    oauth_accounts = []
    for i, user in enumerate(users):
        oauth = OAuthAccount(
            user_id=user.id,
            provider="spotify",
            access_token=f"mock_access_token_{i+1}_" + "x" * 200,
            refresh_token=f"mock_refresh_token_{i+1}_" + "y" * 200,
            expires_at=datetime.utcnow() + timedelta(hours=1)
        )
        session.add(oauth)
        oauth_accounts.append(oauth)
    
    await session.flush()
    print(f"✓ Created {len(oauth_accounts)} OAuth accounts")
    return oauth_accounts


async def seed_tracks(session):
    """Create mock tracks"""
    tracks_data = [
        {
            "spotify_track_id": "3n3Ppam7vgaVa1iaRUc9Lp",
            "title": "Mr. Brightside",
            "artist": "The Killers",
            "album": "Hot Fuss",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273ccdddd46119a4ff53eaf1f5d",
            "track_url": "https://open.spotify.com/track/3n3Ppam7vgaVa1iaRUc9Lp",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "0VjIjW4GlUZAMYd2vXMi3b",
            "title": "Blinding Lights",
            "artist": "The Weeknd",
            "album": "After Hours",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36",
            "track_url": "https://open.spotify.com/track/0VjIjW4GlUZAMYd2vXMi3b",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "7qiZfU4dY1lWllzX7mPBI",
            "title": "Shape of You",
            "artist": "Ed Sheeran",
            "album": "÷ (Divide)",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96",
            "track_url": "https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBI",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "3KkXRkHbMCARz0aVfEt68P",
            "title": "Dynamite",
            "artist": "BTS",
            "album": "BE",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c9b6e84d4d9d8b6e0f2f5c8a",
            "track_url": "https://open.spotify.com/track/3KkXRkHbMCARz0aVfEt68P",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "5sdQOyqq2IDhvmx2lHOpwd",
            "title": "Butter",
            "artist": "BTS",
            "album": "Butter",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2731be40024e992c1c8f2d39e87",
            "track_url": "https://open.spotify.com/track/5sdQOyqq2IDhvmx2lHOpwd",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "60nZcImufyMA1MKQY3dcCH",
            "title": "Gangnam Style",
            "artist": "PSY",
            "album": "Psy 6 (Six Rules), Part 1",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c9c2b1e08d3d9f0d6b8e6f5e",
            "track_url": "https://open.spotify.com/track/60nZcImufyMA1MKQY3dcCH",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "2plbrEY59IikOBgBGLjaoe",
            "title": "Eight",
            "artist": "IU (아이유), SUGA",
            "album": "eight",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b273c5f8e5c7f8e5c7f8e5c7f8e5",
            "track_url": "https://open.spotify.com/track/2plbrEY59IikOBgBGLjaoe",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "6DCZcSspjsKoFjzjrWoCdn",
            "title": "Someone You Loved",
            "artist": "Lewis Capaldi",
            "album": "Divinely Uninspired to a Hellish Extent",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2737f7f7f7f7f7f7f7f7f7f7f7f",
            "track_url": "https://open.spotify.com/track/6DCZcSspjsKoFjzjrWoCdn",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "3cfOd4CMv2snFaKAnMdnvK",
            "title": "Stay",
            "artist": "The Kid LAROI, Justin Bieber",
            "album": "Stay",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2736e6e6e6e6e6e6e6e6e6e6e6e",
            "track_url": "https://open.spotify.com/track/3cfOd4CMv2snFaKAnMdnvK",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        },
        {
            "spotify_track_id": "11dFghVXANMlKmJXsNCbNl",
            "title": "Cut the Feeling",
            "artist": "Carly Rae Jepsen",
            "album": "Emotion",
            "album_cover_url": "https://i.scdn.co/image/ab67616d0000b2735e5e5e5e5e5e5e5e5e5e5e5e",
            "track_url": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl",
            "preview_url": "https://p.scdn.co/mp3-preview/..."
        }
    ]
    
    tracks = []
    for track_data in tracks_data:
        track = Track(**track_data)
        session.add(track)
        tracks.append(track)
    
    await session.flush()
    print(f"✓ Created {len(tracks)} tracks")
    return tracks


async def seed_places(session):
    """Create mock places in Seoul and surrounding areas"""
    places_data = [
        {
            "google_place_id": "ChIJceK-7y2efDURqDrut9x_93s",
            "place_name": "홍대입구역",
            "address": "서울특별시 마포구 양화로 160",
            "lat": 37.5563,
            "lng": 126.9236
        },
        {
            "google_place_id": "ChIJ9VHpNT-ifDURmZ1bZt0nPTM",
            "place_name": "강남역",
            "address": "서울특별시 강남구 강남대로 396",
            "lat": 37.4979,
            "lng": 127.0276
        },
        {
            "google_place_id": "ChIJwckXZEGjfDUR7anLn7hhvH4",
            "place_name": "명동성당",
            "address": "서울특별시 중구 명동길 74",
            "lat": 37.5633,
            "lng": 126.9864
        },
        {
            "google_place_id": "ChIJaQ6kcOCjfDURVQi5FepCp4Y",
            "place_name": "남산서울타워",
            "address": "서울특별시 용산구 남산공원길 105",
            "lat": 37.5511,
            "lng": 126.9882
        },
        {
            "google_place_id": "ChIJ67J9IrulfDURjt27f3_IOJo",
            "place_name": "경복궁",
            "address": "서울특별시 종로구 사직로 161",
            "lat": 37.5788,
            "lng": 126.9770
        },
        {
            "google_place_id": "ChIJJbdq3P6hfDURGYfxTSQzB-U",
            "place_name": "한강공원 여의도",
            "address": "서울특별시 영등포구 여의동로 330",
            "lat": 37.5285,
            "lng": 126.9322
        },
        {
            "google_place_id": "ChIJlfK8TdelfDURlPe-Yz3gdJw",
            "place_name": "이태원역",
            "address": "서울특별시 용산구 이태원로 177",
            "lat": 37.5344,
            "lng": 126.9944
        },
        {
            "google_place_id": "ChIJQVwKq6WhfDURiE6p_0m9DLM",
            "place_name": "코엑스",
            "address": "서울특별시 강남구 영동대로 513",
            "lat": 37.5115,
            "lng": 127.0595
        },
        {
            "google_place_id": "ChIJ-ScHw42efDURi0lYN0t5nWU",
            "place_name": "신촌역",
            "address": "서울특별시 서대문구 신촌역로 90",
            "lat": 37.5551,
            "lng": 126.9369
        },
        {
            "google_place_id": "ChIJy_w8WhSifDUR3aEKu4Zx7CU",
            "place_name": "건대입구역",
            "address": "서울특별시 광진구 아차산로 243",
            "lat": 37.5404,
            "lng": 127.0695
        }
    ]
    
    places = []
    for place_data in places_data:
        lat = place_data.pop("lat")
        lng = place_data.pop("lng")
        
        place = Place(
            **place_data,
            lat=lat,
            lng=lng,
            geom=WKTElement(f'POINT({lng} {lat})', srid=4326)
        )
        session.add(place)
        places.append(place)
    
    await session.flush()
    print(f"✓ Created {len(places)} places")
    return places


async def seed_recommendations(session, users, tracks, places):
    """Create mock recommendations"""
    import random
    
    recommendations = []
    messages = [
        "이 노래를 듣고 있으면 마음이 편안해져요 🎵",
        "비오는 날 듣기 좋은 음악입니다",
        "친구들이랑 여기서 이 노래 들으면서 추억 만들었어요!",
        "출근길에 듣기 딱 좋은 노래",
        "카페에서 작업할 때 이 노래가 최고예요",
        "밤에 산책하면서 듣기 좋아요",
        "운동할 때 들으면 힘이 나는 노래!",
        "데이트하면서 들으면 분위기 좋아요 💕",
        "혼자 있고 싶을 때 듣는 노래",
        "친구 생각나게 하는 음악이에요",
    ]
    
    notes = [
        "이 장소에서 이 노래를 들으니 정말 좋더라구요. 여러분도 한번 들어보세요!",
        "날씨 좋은 날 여기 와서 이 노래 들으면 힐링됩니다.",
        "우연히 들렀다가 이 노래가 나와서 너무 좋았어요. 강추합니다!",
        "스트레스 받을 때 여기 와서 이 노래 들으면 다시 힘이 나요.",
        None,
        "친구 추천으로 알게 된 노래인데, 이 장소랑 너무 잘 어울려요.",
        None,
        "매일 출근길에 듣는 노래예요. 하루를 시작하기 좋은 음악입니다.",
        None,
        "특별한 날을 기념하며 이 장소에서 들었던 노래입니다.",
    ]
    
    # Create recommendations for each user
    for user in users:
        # Each user creates 2-4 recommendations
        num_recommendations = random.randint(2, 4)
        user_tracks = random.sample(tracks, num_recommendations)
        user_places = random.sample(places, num_recommendations)
        
        for track, place in zip(user_tracks, user_places):
            # Add some variation to the location (within ~100m)
            lat_offset = random.uniform(-0.0009, 0.0009)  # ~100m
            lng_offset = random.uniform(-0.0009, 0.0009)
            
            lat = place.lat + lat_offset
            lng = place.lng + lng_offset
            
            recommendation = Recommendation(
                user_id=user.id,
                track_id=track.id,
                place_id=place.id,
                lat=lat,
                lng=lng,
                geom=WKTElement(f'POINT({lng} {lat})', srid=4326),
                message=random.choice(messages),
                note=random.choice(notes),
                created_at=datetime.utcnow() - timedelta(days=random.randint(0, 30))
            )
            session.add(recommendation)
            recommendations.append(recommendation)
    
    await session.flush()
    print(f"✓ Created {len(recommendations)} recommendations")
    return recommendations


async def seed_likes(session, users, recommendations):
    """Create mock likes"""
    import random
    
    likes = []
    
    for user in users:
        # Each user likes 3-7 random recommendations (excluding their own)
        other_recommendations = [r for r in recommendations if r.user_id != user.id]
        num_likes = min(random.randint(3, 7), len(other_recommendations))
        liked_recommendations = random.sample(other_recommendations, num_likes)
        
        for recommendation in liked_recommendations:
            like = RecommendationLike(
                recommendation_id=recommendation.id,
                user_id=user.id,
                created_at=datetime.utcnow() - timedelta(days=random.randint(0, 25))
            )
            session.add(like)
            likes.append(like)
    
    await session.flush()
    print(f"✓ Created {len(likes)} likes")
    return likes


async def main():
    """Main seeding function"""
    print("\n🌱 Starting database seeding...\n")
    
    async with AsyncSessionLocal() as session:
        try:
            # Seed data in order (respecting foreign key constraints)
            users = await seed_users(session)
            oauth_accounts = await seed_oauth_accounts(session, users)
            tracks = await seed_tracks(session)
            places = await seed_places(session)
            recommendations = await seed_recommendations(session, users, tracks, places)
            likes = await seed_likes(session, users, recommendations)
            
            # Commit all changes
            await session.commit()
            
            print("\n✅ Database seeding completed successfully!")
            print(f"\nSummary:")
            print(f"  - Users: {len(users)}")
            print(f"  - OAuth Accounts: {len(oauth_accounts)}")
            print(f"  - Tracks: {len(tracks)}")
            print(f"  - Places: {len(places)}")
            print(f"  - Recommendations: {len(recommendations)}")
            print(f"  - Likes: {len(likes)}")
            
        except Exception as e:
            await session.rollback()
            print(f"\n❌ Error during seeding: {e}")
            raise


if __name__ == "__main__":
    asyncio.run(main())
