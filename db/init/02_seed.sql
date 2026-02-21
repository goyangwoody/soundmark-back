-- Mock data for Soundmark - Location-based Music Recommendation Service
-- 위치 기반 소셜 음악 추천 플랫폼 목 데이터

-- ========================================
-- 1. Users
-- ========================================
INSERT INTO users (spotify_id, display_name, email, profile_image_url, created_at, updated_at) VALUES
('spotify_user_minsu', '김민수', 'minsu.kim@example.com', 'https://i.pravatar.cc/150?img=11', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
('spotify_user_jieun', '이지은', 'jieun.lee@example.com', 'https://i.pravatar.cc/150?img=22', NOW() - INTERVAL '12 days', NOW() - INTERVAL '12 days'),
('spotify_user_junho', '박준호', 'junho.park@example.com', 'https://i.pravatar.cc/150?img=33', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
('spotify_user_seoyeon', '최서연', 'seoyeon.choi@example.com', 'https://i.pravatar.cc/150?img=44', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('spotify_user_woojin', '정우진', 'woojin.jung@example.com', 'https://i.pravatar.cc/150?img=55', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- ========================================
-- 2. OAuth Accounts (Spotify tokens)
-- ========================================
INSERT INTO oauth_accounts (user_id, provider, access_token, refresh_token, expires_at, created_at, updated_at)
SELECT 
    id,
    'spotify',
    'mock_access_token_' || id || '_' || repeat('x', 200),
    'mock_refresh_token_' || id || '_' || repeat('y', 200),
    NOW() + INTERVAL '1 hour',
    NOW(),
    NOW()
FROM users;

-- ========================================
-- 3. Tracks (Real Spotify Track IDs)
-- ========================================
INSERT INTO tracks (spotify_track_id, title, artist, album, album_cover_url, track_url, preview_url, created_at, updated_at) VALUES
-- K-Pop
('0tgVpDi06FyKpA1z0VMD4v', 'Dynamite', 'BTS', 'BE', 'https://i.scdn.co/image/ab67616d0000b273c9b6b22f5f2c2b0e8f3f3c8a', 'https://open.spotify.com/track/0tgVpDi06FyKpA1z0VMD4v', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('5sdQOyqq2IDhvmx2lHOpwd', 'Butter', 'BTS', 'Butter', 'https://i.scdn.co/image/ab67616d0000b2731be40024e992c1c8f2d39e87', 'https://open.spotify.com/track/5sdQOyqq2IDhvmx2lHOpwd', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('3XF5xLJHOQQRbWya6hBp7d', 'Gangnam Style', 'PSY', 'Psy 6 (Six Rules), Part 1', 'https://i.scdn.co/image/ab67616d0000b273c9c2b1e08d3d9f0d6b8e6f5e', 'https://open.spotify.com/track/3XF5xLJHOQQRbWya6hBp7d', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('5jjmGBEHWVWeDYCpRnqRXC', 'Celebrity', 'IU (아이유)', 'Celebrity', 'https://i.scdn.co/image/ab67616d0000b2734ed058b71650a6ca2c04adff', 'https://open.spotify.com/track/5jjmGBEHWVWeDYCpRnqRXC', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
-- Pop
('0VjIjW4GlUZAMYd2vXMi3b', 'Blinding Lights', 'The Weeknd', 'After Hours', 'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36', 'https://open.spotify.com/track/0VjIjW4GlUZAMYd2vXMi3b', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('7qiZfU4dY1lWllzX7mPBIP', 'Shape of You', 'Ed Sheeran', '÷ (Divide)', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBIP', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('3n3Ppam7vgaVa1iaRUc9Lp', 'Mr. Brightside', 'The Killers', 'Hot Fuss', 'https://i.scdn.co/image/ab67616d0000b273ccdddd46119a4ff53eaf1f5d', 'https://open.spotify.com/track/3n3Ppam7vgaVa1iaRUc9Lp', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('6DCZcSspjsKoFjzjrWoCdn', 'Someone You Loved', 'Lewis Capaldi', 'Divinely Uninspired to a Hellish Extent', 'https://i.scdn.co/image/ab67616d0000b2732d898688788a04f0c3c1c3c1', 'https://open.spotify.com/track/6DCZcSspjsKoFjzjrWoCdn', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('2takcwOaAZWiXQijPHIx7B', 'Time After Time', 'Cyndi Lauper', 'She''s So Unusual', 'https://i.scdn.co/image/ab67616d0000b273e8e8e8e8e8e8e8e8e8e8e8e8', 'https://open.spotify.com/track/2takcwOaAZWiXQijPHIx7B', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('3XVBdLihbNbxUwZosxcGuJ', 'Skyfall', 'Adele', 'Skyfall', 'https://i.scdn.co/image/ab67616d0000b273c4b4e2e2e2e2e2e2e2e2e2e2', 'https://open.spotify.com/track/3XVBdLihbNbxUwZosxcGuJ', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
-- Indie/Alternative
('2gNfxysfBRfl9Lvi9T3v6R', 'Heat Waves', 'Glass Animals', 'Dreamland', 'https://i.scdn.co/image/ab67616d0000b273c4c4c4c4c4c4c4c4c4c4c4c4', 'https://open.spotify.com/track/2gNfxysfBRfl9Lvi9T3v6R', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW()),
('11dFghVXANMlKmJXsNCbNl', 'Cut to the Feeling', 'Carly Rae Jepsen', 'Emotion', 'https://i.scdn.co/image/ab67616d0000b2735e5e5e5e5e5e5e5e5e5e5e5e', 'https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW());

-- ========================================
-- 4. Places (Seoul landmarks and popular spots)
-- ========================================
INSERT INTO places (google_place_id, place_name, address, lat, lng, geom, created_at, updated_at) VALUES
('ChIJceK-7y2efDURqDrut9x_93s', '홍대입구역', '서울특별시 마포구 양화로 160', 37.5563, 126.9236, ST_SetSRID(ST_MakePoint(126.9236, 37.5563), 4326), NOW(), NOW()),
('ChIJ9VHpNT-ifDURmZ1bZt0nPTM', '강남역', '서울특별시 강남구 강남대로 396', 37.4979, 127.0276, ST_SetSRID(ST_MakePoint(127.0276, 37.4979), 4326), NOW(), NOW()),
('ChIJwckXZEGjfDUR7anLn7hhvH4', '명동성당', '서울특별시 중구 명동길 74', 37.5633, 126.9864, ST_SetSRID(ST_MakePoint(126.9864, 37.5633), 4326), NOW(), NOW()),
('ChIJaQ6kcOCjfDURVQi5FepCp4Y', '남산서울타워', '서울특별시 용산구 남산공원길 105', 37.5511, 126.9882, ST_SetSRID(ST_MakePoint(126.9882, 37.5511), 4326), NOW(), NOW()),
('ChIJ67J9IrulfDURjt27f3_IOJo', '경복궁', '서울특별시 종로구 사직로 161', 37.5788, 126.9770, ST_SetSRID(ST_MakePoint(126.9770, 37.5788), 4326), NOW(), NOW()),
('ChIJJbdq3P6hfDURGYfxTSQzB-U', '한강공원 여의도', '서울특별시 영등포구 여의동로 330', 37.5285, 126.9322, ST_SetSRID(ST_MakePoint(126.9322, 37.5285), 4326), NOW(), NOW()),
('ChIJlfK8TdelfDURlPe-Yz3gdJw', '이태원역', '서울특별시 용산구 이태원로 177', 37.5344, 126.9944, ST_SetSRID(ST_MakePoint(126.9944, 37.5344), 4326), NOW(), NOW()),
('ChIJQVwKq6WhfDURiE6p_0m9DLM', '코엑스', '서울특별시 강남구 영동대로 513', 37.5115, 127.0595, ST_SetSRID(ST_MakePoint(127.0595, 37.5115), 4326), NOW(), NOW()),
('ChIJ-ScHw42efDURi0lYN0t5nWU', '신촌역', '서울특별시 서대문구 신촌역로 90', 37.5551, 126.9369, ST_SetSRID(ST_MakePoint(126.9369, 37.5551), 4326), NOW(), NOW()),
('ChIJy_w8WhSifDUR3aEKu4Zx7CU', '건대입구역', '서울특별시 광진구 아차산로 243', 37.5404, 127.0695, ST_SetSRID(ST_MakePoint(127.0695, 37.5404), 4326), NOW(), NOW());

-- ========================================
-- 5. Recommendations (위치에 "묻어둔" 음악들)
-- ========================================
-- 홍대에서의 추천들 (클럽/인디 문화)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES 
(1, 3, 1, 37.5565, 126.9238, ST_SetSRID(ST_MakePoint(126.9238, 37.5565), 4326), 
 '홍대 클럽 앞에서 이 노래 나왔을 때 최고였어요! 🎉', 
 '친구들이랑 신나게 춤추면서 들었던 기억이 나요. 강남스타일은 역시 홍대 분위기랑 찰떡!',
 NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),
 
(2, 11, 1, 37.5560, 126.9240, ST_SetSRID(ST_MakePoint(126.9240, 37.5560), 4326),
 '홍대 카페거리에서 작업할 때 들으면 집중 잘돼요', 
 'Heat Waves 들으면서 홍대 카페에서 노트북 작업하는 게 제 루틴이에요. 감성 충만합니다.',
 NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- 강남역에서의 추천들 (트렌디/활기)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(3, 1, 2, 37.4982, 127.0279, ST_SetSRID(ST_MakePoint(127.0279, 37.4982), 4326),
 '출근길 강남역에서 듣는 Dynamite로 하루 시작! 💜',
 '매일 아침 강남역 9번 출구 나오면서 이 노래 들으면 힘이 나요. BTS 최고!',
 NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
 
(4, 5, 2, 37.4976, 127.0273, ST_SetSRID(ST_MakePoint(127.0273, 37.4976), 4326),
 '강남 밤거리는 Blinding Lights와 함께 🌃',
 NULL,
 NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days');

-- 명동에서의 추천들 (관광/추억)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(5, 6, 3, 37.5635, 126.9867, ST_SetSRID(ST_MakePoint(126.9867, 37.5635), 4326),
 '명동 쇼핑하면서 듣기 좋은 노래예요',
 '에드 시런의 Shape of You는 쇼핑할 때 듣기 딱 좋더라고요. 신나고 경쾌해요!',
 NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days'),
 
(1, 4, 3, 37.5630, 126.9862, ST_SetSRID(ST_MakePoint(126.9862, 37.5630), 4326),
 '명동성당 앞에서 우연히 들은 IU 노래 🎵',
 '명동성당 앞 카페에서 이 노래가 나와서 묻어뒀어요. Celebrity는 언제 들어도 좋네요.',
 NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days');

-- 남산타워에서의 추천들 (로맨틱)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(2, 8, 4, 37.5513, 126.9885, ST_SetSRID(ST_MakePoint(126.9885, 37.5513), 4326),
 '남산에서 야경 보면서 듣기 좋은 발라드 💕',
 '연인과 남산타워에서 야경 보면서 이 노래 들었는데 너무 좋았어요. 추억의 노래가 됐습니다.',
 NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days');

-- 경복궁에서의 추천들 (한국적/감성)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(3, 4, 5, 37.5790, 126.9772, ST_SetSRID(ST_MakePoint(126.9772, 37.5790), 4326),
 '경복궁 산책하며 듣는 한국 음악 최고',
 '한복 입고 경복궁 돌아다니면서 아이유 노래 들으니까 분위기 완전 대박이었어요!',
 NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days');

-- 한강공원에서의 추천들 (힐링/여유)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(4, 9, 6, 37.5287, 126.9325, ST_SetSRID(ST_MakePoint(126.9325, 37.5287), 4326),
 '한강에서 치맥하면서 듣기 좋은 노래 🌊',
 '여의도 한강공원에서 치킨이랑 맥주 먹으면서 이 노래 틀었는데 분위기 죽여요!',
 NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
 
(5, 12, 6, 37.5283, 126.9320, ST_SetSRID(ST_MakePoint(126.9320, 37.5283), 4326),
 '한강 자전거 타면서 듣기 완벽한 곡',
 '자전거 타고 한강 달리면서 이 노래 들으면 기분 최고예요. Carly Rae Jepsen 신나요!',
 NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- 이태원에서의 추천들 (다문화/글로벌)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(1, 7, 7, 37.5346, 126.9947, ST_SetSRID(ST_MakePoint(126.9947, 37.5346), 4326),
 '이태원 루프탑 바에서 듣던 노래예요 🍹',
 'The Killers의 Mr. Brightside는 이태원 분위기랑 찰떡입니다. 외국 느낌 나서 좋아요.',
 NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days');

-- 코엑스에서의 추천들 (현대적/세련됨)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(2, 10, 8, 37.5117, 127.0598, ST_SetSRID(ST_MakePoint(127.0598, 37.5117), 4326),
 '코엑스 별마당 도서관에서 듣는 Adele',
 '코엑스 별마당 도서관에서 책 읽으면서 이 노래 귀로 작게 들었어요. 집중 잘돼요.',
 NOW() - INTERVAL '11 days', NOW() - INTERVAL '11 days');

-- 신촌에서의 추천들 (대학가/젊음)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(3, 2, 9, 37.5553, 126.9371, ST_SetSRID(ST_MakePoint(126.9371, 37.5553), 4326),
 '신촌 먹자골목에서 친구들이랑 신남! 🎊',
 '신촌 먹자골목 포차에서 친구들이랑 소주 마시면서 BTS Butter 틀었어요. 완전 신나요!',
 NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days');

-- 건대에서의 추천들 (대학가/파티)
INSERT INTO recommendations (user_id, track_id, place_id, lat, lng, geom, message, note, created_at, updated_at)
VALUES
(4, 11, 10, 37.5406, 127.0698, ST_SetSRID(ST_MakePoint(127.0698, 37.5406), 4326),
 '건대 클럽 앞에서 대기할 때 들은 노래',
 '건대 클럽 입장 줄 서면서 들었던 Heat Waves. 분위기 업 시키기 좋아요!',
 NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days');

-- ========================================
-- 6. Recommendation Likes
-- ========================================
-- 각 사용자가 다른 사용자의 추천에 좋아요
INSERT INTO recommendation_likes (recommendation_id, user_id, created_at)
SELECT 
    r.id,
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_jieun') as user_id,
    NOW() - INTERVAL '6 days'
FROM recommendations r
WHERE r.user_id = (SELECT id FROM users WHERE spotify_id = 'spotify_user_minsu')
LIMIT 2;

INSERT INTO recommendation_likes (recommendation_id, user_id, created_at)
SELECT 
    r.id,
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_junho') as user_id,
    NOW() - INTERVAL '5 days'
FROM recommendations r
WHERE r.user_id = (SELECT id FROM users WHERE spotify_id = 'spotify_user_jieun')
LIMIT 2;

INSERT INTO recommendation_likes (recommendation_id, user_id, created_at)
SELECT 
    r.id,
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_seoyeon') as user_id,
    NOW() - INTERVAL '4 days'
FROM recommendations r
WHERE r.user_id IN (SELECT id FROM users WHERE spotify_id IN ('spotify_user_minsu', 'spotify_user_junho'))
LIMIT 3;

INSERT INTO recommendation_likes (recommendation_id, user_id, created_at)
SELECT 
    r.id,
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_woojin') as user_id,
    NOW() - INTERVAL '3 days'
FROM recommendations r
WHERE r.user_id != (SELECT id FROM users WHERE spotify_id = 'spotify_user_woojin')
LIMIT 4;

INSERT INTO recommendation_likes (recommendation_id, user_id, created_at)
SELECT 
    r.id,
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_minsu') as user_id,
    NOW() - INTERVAL '2 days'
FROM recommendations r
WHERE r.user_id IN (SELECT id FROM users WHERE spotify_id IN ('spotify_user_jieun', 'spotify_user_seoyeon'))
LIMIT 3;

-- ========================================
-- Summary
-- ========================================
-- Users: 5
-- Tracks: 12 (K-Pop, Pop, Indie mix)
-- Places: 10 (Seoul landmarks)
-- Recommendations: 15 (distributed across Seoul)
-- Likes: ~15 (various users liking others' recommendations)
