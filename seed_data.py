"""
Mock data seeding script for Soundmark database
"""
import asyncio
from datetime import datetime, timedelta
from sqlalchemy import select
from geoalchemy2.elements import WKTElement

from app.database import AsyncSessionLocal, engine, Base
from app.models.user import User
from app.models.track import Track
from app.models.place import Place
from app.models.recommendation import Recommendation
from app.models.oauth import OAuthAccount
from app.models.like import RecommendationLike


async def clear_database():
    """Clear all existing data"""
    async with engine.begin() as conn:
        # Drop all tables and recreate them
        # await conn.run_sync(Base.metadata.drop_all)
        # await conn.run_sync(Base.metadata.create_all)
        pass


async def seed_users(session):
    """Create mock users"""
    users_data = [
        {
            "spotify_id": "spotify_user_001",
            "display_name": "김민수",
            "email": "minsu@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=1"
        },
        {
            "spotify_id": "spotify_user_002",
            "display_name": "이지은",
            "email": "jieun@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=2"
        },
        {
            "spotify_id": "spotify_user_003",
            "display_name": "박준호",
            "email": "junho@example.com",
            "profile_image_url": "https://i.pravatar.cc/150?img=3"
        },
        {
            "spotify_id": "spotify_user_004",
            "display_name": "최서연",
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
