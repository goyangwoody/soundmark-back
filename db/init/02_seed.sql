-- Seed data for Soundmark - Location-based Music Recommendation Service
-- 위치 기반 소셜 음악 추천 플랫폼 시드 데이터

-- ========================================
-- 1. Users (without profile_image_url)
-- ========================================
INSERT INTO users (spotify_id, display_name, email, created_at, updated_at) VALUES
('spotify_user_minsu', '김민수', 'minsu.kim@example.com', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
('spotify_user_jieun', '이지은', 'jieun.lee@example.com', NOW() - INTERVAL '12 days', NOW() - INTERVAL '12 days'),
('spotify_user_junho', '박준호', 'junho.park@example.com', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
('spotify_user_seoyeon', '최서연', 'seoyeon.choi@example.com', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
('spotify_user_woojin', '정우진', 'woojin.jung@example.com', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days')
ON CONFLICT (spotify_id) DO NOTHING;

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
FROM users
WHERE spotify_id IN ('spotify_user_minsu', 'spotify_user_jieun', 'spotify_user_junho', 'spotify_user_seoyeon', 'spotify_user_woojin')
ON CONFLICT DO NOTHING;

-- ========================================
-- 3. Follows (Follow relationships)
-- ========================================
-- 김민수 follows 이지은, 박준호
INSERT INTO follows (follower_id, following_id, created_at)
SELECT 
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_minsu'),
    u.id,
    NOW() - INTERVAL '5 days'
FROM users u
WHERE u.spotify_id IN ('spotify_user_jieun', 'spotify_user_junho')
ON CONFLICT DO NOTHING;

-- 이지은 follows 김민수, 최서연, 정우진
INSERT INTO follows (follower_id, following_id, created_at)
SELECT 
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_jieun'),
    u.id,
    NOW() - INTERVAL '4 days'
FROM users u
WHERE u.spotify_id IN ('spotify_user_minsu', 'spotify_user_seoyeon', 'spotify_user_woojin')
ON CONFLICT DO NOTHING;

-- 박준호 follows 김민수
INSERT INTO follows (follower_id, following_id, created_at)
SELECT 
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_junho'),
    u.id,
    NOW() - INTERVAL '3 days'
FROM users u
WHERE u.spotify_id = 'spotify_user_minsu'
ON CONFLICT DO NOTHING;

-- 최서연 follows 이지은, 정우진
INSERT INTO follows (follower_id, following_id, created_at)
SELECT 
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_seoyeon'),
    u.id,
    NOW() - INTERVAL '2 days'
FROM users u
WHERE u.spotify_id IN ('spotify_user_jieun', 'spotify_user_woojin')
ON CONFLICT DO NOTHING;

-- ========================================
-- 4. Tracks (Real Spotify Track IDs)
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
('11dFghVXANMlKmJXsNCbNl', 'Cut to the Feeling', 'Carly Rae Jepsen', 'Emotion', 'https://i.scdn.co/image/ab67616d0000b2735e5e5e5e5e5e5e5e5e5e5e5e', 'https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl', 'https://p.scdn.co/mp3-preview/...', NOW(), NOW())
ON CONFLICT (spotify_track_id) DO NOTHING;

-- ========================================
-- 5. Places (Seoul landmarks and popular spots)
-- ========================================
INSERT INTO places (place_name, address, lat, lng, geom, created_at, updated_at) VALUES
-- Central Seoul
('경복궁', '서울 종로구 사직로 161', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW(), NOW()),
('N서울타워', '서울 용산구 남산공원길 105', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW(), NOW()),
('한강공원 여의도', '서울 영등포구 여의동로 330', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW(), NOW()),
-- Cafes
('블루보틀 삼청점', '서울 종로구 삼청로 34', 37.584028, 126.982900, ST_SetSRID(ST_MakePoint(126.982900, 37.584028), 4326), NOW(), NOW()),
('테라로사 강남점', '서울 강남구 테헤란로 427', 37.508333, 127.061667, ST_SetSRID(ST_MakePoint(127.061667, 37.508333), 4326), NOW(), NOW()),
-- Universities
('서울대학교', '서울 관악구 관악로 1', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW(), NOW()),
('연세대학교', '서울 서대문구 연세로 50', 37.566536, 126.939370, ST_SetSRID(ST_MakePoint(126.939370, 37.566536), 4326), NOW(), NOW()),
('홍익대학교', '서울 마포구 와우산로 94', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW(), NOW()),
-- Restaurants
('광장시장', '서울 종로구 창경궁로 88', 37.570090, 126.999350, ST_SetSRID(ST_MakePoint(126.999350, 37.570090), 4326), NOW(), NOW()),
('이태원 거리', '서울 용산구 이태원로', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ========================================
-- 6. Recommendations (with geom for PostGIS)
-- ========================================
-- 경복궁에서 Dynamite (김민수)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_minsu'),
    (SELECT id FROM tracks WHERE spotify_track_id = '0tgVpDi06FyKpA1z0VMD4v'),
    (SELECT id FROM places WHERE place_name = '경복궁'),
    '궁궐을 걸으며 듣기 좋은 신나는 곡!',
    37.579617, 126.977041,
    ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326),
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '10 days'
) ON CONFLICT DO NOTHING;

-- N서울타워에서 Blinding Lights (이지은)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_jieun'),
    (SELECT id FROM tracks WHERE spotify_track_id = '0VjIjW4GlUZAMYd2vXMi3b'),
    (SELECT id FROM places WHERE place_name = 'N서울타워'),
    '야경을 보며 듣는 The Weeknd 최고!',
    37.551169, 126.988227,
    ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326),
    NOW() - INTERVAL '8 days',
    NOW() - INTERVAL '8 days'
) ON CONFLICT DO NOTHING;

-- 한강공원에서 Shape of You (박준호)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_junho'),
    (SELECT id FROM tracks WHERE spotify_track_id = '7qiZfU4dY1lWllzX7mPBIP'),
    (SELECT id FROM places WHERE place_name = '한강공원 여의도'),
    '자전거 타면서 듣기 완벽한 곡',
    37.529030, 126.932570,
    ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326),
    NOW() - INTERVAL '7 days',
    NOW() - INTERVAL '7 days'
) ON CONFLICT DO NOTHING;

-- 블루보틀에서 Heat Waves (최서연)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_seoyeon'),
    (SELECT id FROM tracks WHERE spotify_track_id = '2gNfxysfBRfl9Lvi9T3v6R'),
    (SELECT id FROM places WHERE place_name = '블루보틀 삼청점'),
    '커피 마시며 듣는 감성 인디 음악',
    37.584028, 126.982900,
    ST_SetSRID(ST_MakePoint(126.982900, 37.584028), 4326),
    NOW() - INTERVAL '5 days',
    NOW() - INTERVAL '5 days'
) ON CONFLICT DO NOTHING;

-- 홍대에서 Gangnam Style (정우진)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_woojin'),
    (SELECT id FROM tracks WHERE spotify_track_id = '3XF5xLJHOQQRbWya6hBp7d'),
    (SELECT id FROM places WHERE place_name = '홍익대학교'),
    '홍대 거리에서 춤추고 싶어지는 곡!',
    37.550970, 126.925620,
    ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326),
    NOW() - INTERVAL '4 days',
    NOW() - INTERVAL '4 days'
) ON CONFLICT DO NOTHING;

-- 서울대에서 Celebrity (김민수)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_minsu'),
    (SELECT id FROM tracks WHERE spotify_track_id = '5jjmGBEHWVWeDYCpRnqRXC'),
    (SELECT id FROM places WHERE place_name = '서울대학교'),
    '캠퍼스를 걸으며 듣는 IU',
    37.460800, 126.951900,
    ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326),
    NOW() - INTERVAL '3 days',
    NOW() - INTERVAL '3 days'
) ON CONFLICT DO NOTHING;

-- 이태원에서 Mr. Brightside (이지은)
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at)
VALUES (
    (SELECT id FROM users WHERE spotify_id = 'spotify_user_jieun'),
    (SELECT id FROM tracks WHERE spotify_track_id = '3n3Ppam7vgaVa1iaRUc9Lp'),
    (SELECT id FROM places WHERE place_name = '이태원 거리'),
    '이태원의 밤 분위기와 딱!',
    37.534540, 126.994360,
    ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326),
    NOW() - INTERVAL '2 days',
    NOW() - INTERVAL '2 days'
) ON CONFLICT DO NOTHING;

-- ========================================
-- 7. Recommendation Likes (with emoji reactions)
-- ========================================
-- 경복궁 Dynamite 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW() - INTERVAL '9 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '궁궐을 걸으며 듣기 좋은 신나는 곡!'
AND u.spotify_id = 'spotify_user_jieun'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🔥',
    NOW() - INTERVAL '8 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '궁궐을 걸으며 듣기 좋은 신나는 곡!'
AND u.spotify_id = 'spotify_user_junho'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '👍',
    NOW() - INTERVAL '7 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '궁궐을 걸으며 듣기 좋은 신나는 곡!'
AND u.spotify_id = 'spotify_user_seoyeon'
ON CONFLICT DO NOTHING;

-- N서울타워 Blinding Lights 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW() - INTERVAL '7 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '야경을 보며 듣는 The Weeknd 최고!'
AND u.spotify_id = 'spotify_user_minsu'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '😍',
    NOW() - INTERVAL '6 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '야경을 보며 듣는 The Weeknd 최고!'
AND u.spotify_id = 'spotify_user_woojin'
ON CONFLICT DO NOTHING;

-- 한강공원 Shape of You 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🚴',
    NOW() - INTERVAL '6 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '자전거 타면서 듣기 완벽한 곡'
AND u.spotify_id = 'spotify_user_jieun'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW() - INTERVAL '5 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '자전거 타면서 듣기 완벽한 곡'
AND u.spotify_id = 'spotify_user_seoyeon'
ON CONFLICT DO NOTHING;

-- 블루보틀 Heat Waves 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '☕',
    NOW() - INTERVAL '4 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '커피 마시며 듣는 감성 인디 음악'
AND u.spotify_id = 'spotify_user_minsu'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW() - INTERVAL '3 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '커피 마시며 듣는 감성 인디 음악'
AND u.spotify_id = 'spotify_user_junho'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🎵',
    NOW() - INTERVAL '2 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '커피 마시며 듣는 감성 인디 음악'
AND u.spotify_id = 'spotify_user_woojin'
ON CONFLICT DO NOTHING;

-- 홍대 Gangnam Style 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '💃',
    NOW() - INTERVAL '3 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '홍대 거리에서 춤추고 싶어지는 곡!'
AND u.spotify_id = 'spotify_user_minsu'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🔥',
    NOW() - INTERVAL '2 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '홍대 거리에서 춤추고 싶어지는 곡!'
AND u.spotify_id = 'spotify_user_jieun'
ON CONFLICT DO NOTHING;

-- 서울대 Celebrity 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW() - INTERVAL '2 days'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '캠퍼스를 걸으며 듣는 IU'
AND u.spotify_id = 'spotify_user_jieun'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🎓',
    NOW() - INTERVAL '1 day'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '캠퍼스를 걸으며 듣는 IU'
AND u.spotify_id = 'spotify_user_seoyeon'
ON CONFLICT DO NOTHING;

-- 이태원 Mr. Brightside 추천에 대한 반응들
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '🌃',
    NOW() - INTERVAL '1 day'
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '이태원의 밤 분위기와 딱!'
AND u.spotify_id = 'spotify_user_junho'
ON CONFLICT DO NOTHING;

INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT 
    r.id,
    u.id,
    '❤️',
    NOW()
FROM recommendations r
CROSS JOIN users u
WHERE r.message = '이태원의 밤 분위기와 딱!'
AND u.spotify_id = 'spotify_user_woojin'
ON CONFLICT DO NOTHING;
