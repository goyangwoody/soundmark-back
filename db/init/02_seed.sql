-- Seed data for Soundmark - Location-based Music Recommendation Service
-- 위치 기반 소셜 음악 추천 플랫폼 시드 데이터
-- 서울 전역 25개 자치구 대규모 Mock Data

-- ========================================
-- 1. Users (20 users)
-- ========================================
INSERT INTO users (spotify_id, display_name, email, profile_image, status_message, created_at, updated_at) VALUES
('spotify_user_minsu',    '김민수',   'minsu.kim@example.com',     3, '',  NOW() - INTERVAL '60 days', NOW() - INTERVAL '60 days'),
('spotify_user_jieun',    '이지은',   'jieun.lee@example.com',     7, '',  NOW() - INTERVAL '58 days', NOW() - INTERVAL '58 days'),
('spotify_user_junho',    '박준호',   'junho.park@example.com',    1, '',  NOW() - INTERVAL '55 days', NOW() - INTERVAL '55 days'),
('spotify_user_seoyeon',  '최서연',   'seoyeon.choi@example.com',  5, '',  NOW() - INTERVAL '52 days', NOW() - INTERVAL '52 days'),
('spotify_user_woojin',   '정우진',   'woojin.jung@example.com',   9, '',  NOW() - INTERVAL '50 days', NOW() - INTERVAL '50 days'),
('spotify_user_hyejin',   '강혜진',   'hyejin.kang@example.com',   2, '',  NOW() - INTERVAL '48 days', NOW() - INTERVAL '48 days'),
('spotify_user_donghyun', '윤동현',   'donghyun.yoon@example.com', 6, '',  NOW() - INTERVAL '45 days', NOW() - INTERVAL '45 days'),
('spotify_user_sohee',    '한소희',   'sohee.han@example.com',     4, '',  NOW() - INTERVAL '42 days', NOW() - INTERVAL '42 days'),
('spotify_user_taehyung', '임태형',   'taehyung.lim@example.com',  8, '',  NOW() - INTERVAL '40 days', NOW() - INTERVAL '40 days'),
('spotify_user_yuna',     '서유나',   'yuna.seo@example.com',      1, '',  NOW() - INTERVAL '38 days', NOW() - INTERVAL '38 days'),
('spotify_user_jiho',     '오지호',   'jiho.oh@example.com',       3, '',  NOW() - INTERVAL '35 days', NOW() - INTERVAL '35 days'),
('spotify_user_eunji',    '배은지',   'eunji.bae@example.com',     7, '',  NOW() - INTERVAL '32 days', NOW() - INTERVAL '32 days'),
('spotify_user_minjae',   '송민재',   'minjae.song@example.com',   5, '',  NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days'),
('spotify_user_nayeon',   '홍나연',   'nayeon.hong@example.com',   9, '',  NOW() - INTERVAL '28 days', NOW() - INTERVAL '28 days'),
('spotify_user_siwoo',    '조시우',   'siwoo.cho@example.com',     2, '',  NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days'),
('spotify_user_hayoung',  '문하영',   'hayoung.moon@example.com',  6, '',  NOW() - INTERVAL '22 days', NOW() - INTERVAL '22 days'),
('spotify_user_doyoon',   '신도윤',   'doyoon.shin@example.com',   4, '',  NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days'),
('spotify_user_chaewon',  '안채원',   'chaewon.ahn@example.com',   8, '',  NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),
('spotify_user_hyunwoo',  '류현우',   'hyunwoo.ryu@example.com',   1, '',  NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
('spotify_user_minji',    '장민지',   'minji.jang@example.com',    3, '',  NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days')
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
ON CONFLICT DO NOTHING;

-- ========================================
-- 3. Follows (Follow relationships)
-- ========================================
-- Build a rich social graph
INSERT INTO follows (follower_id, following_id, created_at)
SELECT a.id, b.id, NOW() - (random() * INTERVAL '30 days')
FROM users a, users b
WHERE a.id != b.id
  AND random() < 0.3
ON CONFLICT DO NOTHING;

-- ========================================
-- 4. Tracks (40 tracks - diverse genres)
-- ========================================
INSERT INTO tracks (spotify_track_id, title, artist, album, album_cover_url, track_url, preview_url, created_at, updated_at) VALUES
-- K-Pop
('72IwoG8tqvIWV10IHjpNNA', 'Dynamite', 'BTS', 'Dynamite (DayTime Version)', 'https://i.scdn.co/image/ab67616d0000b273668914e625d75e5fe3f1da51', 'https://open.spotify.com/track/72IwoG8tqvIWV10IHjpNNA', NULL, NOW(), NOW()),
('1mWdTewIgB3gtBM3TOSFhB', 'Butter', 'BTS', 'Butter (Hotter, Sweeter, Cooler)', 'https://i.scdn.co/image/ab67616d0000b273240447f2da1433d8f4303596', 'https://open.spotify.com/track/1mWdTewIgB3gtBM3TOSFhB', NULL, NOW(), NOW()),
('5c58c6sKc2JK3o75ZBSeL1', 'Gangnam Style (강남스타일)', 'PSY', 'Hottest Hits Ever 3', 'https://i.scdn.co/image/ab67616d0000b27320c8eba212bd2e4305304af8', 'https://open.spotify.com/track/5c58c6sKc2JK3o75ZBSeL1', NULL, NOW(), NOW()),
('4RewTiGEGoO7FWNZUmp1f4', 'Celebrity', 'IU', 'Celebrity', 'https://i.scdn.co/image/ab67616d0000b2732fda07910d40ee81e620fe3f', 'https://open.spotify.com/track/4RewTiGEGoO7FWNZUmp1f4', NULL, NOW(), NOW()),
('6bvZRLLkBKkmgpBJTTj3QK', 'How You Like That', 'BLACKPINK', 'THE ALBUM', 'https://i.scdn.co/image/ab67616d0000b2731895052324f123becdd0d53d', 'https://open.spotify.com/track/6bvZRLLkBKkmgpBJTTj3QK', NULL, NOW(), NOW()),
('0a4MMyCrzT0En247IhqZbD', 'Hype Boy', 'NewJeans', 'NewJeans 1st EP ''New Jeans''', 'https://i.scdn.co/image/ab67616d0000b2739d28fd01859073a3ae6ea209', 'https://open.spotify.com/track/0a4MMyCrzT0En247IhqZbD', NULL, NOW(), NOW()),
('0Q5VnK2DYzRyfqQRJuUtvi', 'LOVE DIVE', 'IVE', 'LOVE DIVE', 'https://i.scdn.co/image/ab67616d0000b2739016f58cc49e6473e1207093', 'https://open.spotify.com/track/0Q5VnK2DYzRyfqQRJuUtvi', NULL, NOW(), NOW()),
('4fsQ0K37TOXa3hEQfjEic1', 'ANTIFRAGILE', 'LE SSERAFIM', 'ANTIFRAGILE', 'https://i.scdn.co/image/ab67616d0000b2739cfed1dd2d368a0855d7b1a4', 'https://open.spotify.com/track/4fsQ0K37TOXa3hEQfjEic1', NULL, NOW(), NOW()),
('68r87x3VZdAMhv8nBVuynz', 'Queencard', 'i-dle', 'I feel', 'https://i.scdn.co/image/ab67616d0000b27357de3da10da259d0a19a81b4', 'https://open.spotify.com/track/68r87x3VZdAMhv8nBVuynz', NULL, NOW(), NOW()),
('0ObcVIFoDdBBClvABfJvdz', 'MANIAC', 'Stray Kids', 'ODDINARY', 'https://i.scdn.co/image/ab67616d0000b2738c759dea19e40f9225e447e8', 'https://open.spotify.com/track/0ObcVIFoDdBBClvABfJvdz', NULL, NOW(), NOW()),
('3AOf6YEpxQ894FmrwI9k96', 'Super', 'SEVENTEEN', 'SEVENTEEN 10th Mini Album ''FML''', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'https://open.spotify.com/track/3AOf6YEpxQ894FmrwI9k96', NULL, NOW(), NOW()),
('3r8RuvgbX9s7ammBn07D3W', 'Ditto', 'NewJeans', 'Ditto', 'https://i.scdn.co/image/ab67616d0000b273edf5b257be1d6593e81bb45f', 'https://open.spotify.com/track/3r8RuvgbX9s7ammBn07D3W', NULL, NOW(), NOW()),
-- K-Indie / K-R&B
('3P3UA61WRQqwCXaoFOTENd', 'Through the Night', 'IU', 'Palette', 'https://i.scdn.co/image/ab67616d0000b273c06f0e8b33ac2d246158253e', 'https://open.spotify.com/track/3P3UA61WRQqwCXaoFOTENd', NULL, NOW(), NOW()),
('0pYacDCZuRhcrwGUA5nTBe', 'eight(Prod.&Feat. SUGA of BTS)', 'IU, SUGA', 'eight', 'https://i.scdn.co/image/ab67616d0000b273c63be04ae902b1da7a54d247', 'https://open.spotify.com/track/0pYacDCZuRhcrwGUA5nTBe', NULL, NOW(), NOW()),
('4TBHfv2isYco3fNKjQ8oSI', 'NAN CHUN', 'SE SO NEON', 'NAN CHUN', 'https://i.scdn.co/image/ab67616d0000b27362fa9ca3dea123404eda1b71', 'https://open.spotify.com/track/4TBHfv2isYco3fNKjQ8oSI', NULL, NOW(), NOW()),
('2IgbYlOlFpiSFYnsqB39lM', 'Jasmine', 'DPR LIVE', 'Jasmine', 'https://i.scdn.co/image/ab67616d0000b273aede3a5ed9bb90fb91aad963', 'https://open.spotify.com/track/2IgbYlOlFpiSFYnsqB39lM', NULL, NOW(), NOW()),
('4g6XOg9rvB55GCTJcYchOG', 'METEOR', 'CHANGMO', 'Boyhood', 'https://i.scdn.co/image/ab67616d0000b273e0891e322bc2773b1e4389c2', 'https://open.spotify.com/track/4g6XOg9rvB55GCTJcYchOG', NULL, NOW(), NOW()),
('69WpV0U7OMNFGyq8I63dcC', 'Given-Taken', 'ENHYPEN', 'BORDER : DAY ONE', 'https://i.scdn.co/image/ab67616d0000b2734a6096741dcf413354a59554', 'https://open.spotify.com/track/69WpV0U7OMNFGyq8I63dcC', NULL, NOW(), NOW()),
-- Pop / Western
('0VjIjW4GlUZAMYd2vXMi3b', 'Blinding Lights', 'The Weeknd', 'After Hours', 'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36', 'https://open.spotify.com/track/0VjIjW4GlUZAMYd2vXMi3b', NULL, NOW(), NOW()),
('7qiZfU4dY1lWllzX7mPBI3', 'Shape of You', 'Ed Sheeran', '÷ (Deluxe)', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBI3', NULL, NOW(), NOW()),
('003vvx7Niy0yvhvHt4a68B', 'Mr. Brightside', 'The Killers', 'Hot Fuss', 'https://i.scdn.co/image/ab67616d0000b273ccdddd46119a4ff53eaf1f5d', 'https://open.spotify.com/track/003vvx7Niy0yvhvHt4a68B', NULL, NOW(), NOW()),
('7qEHsqek33rTcFNT9PFqLf', 'Someone You Loved', 'Lewis Capaldi', 'Divinely Uninspired To A Hellish Extent', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'https://open.spotify.com/track/7qEHsqek33rTcFNT9PFqLf', NULL, NOW(), NOW()),
('7o9uu2GDtVDr9nsR7ZRN73', 'Time After Time', 'Cyndi Lauper', 'She''s So Unusual', 'https://i.scdn.co/image/ab67616d0000b273ce023ce7dfdd5199bcdfd5a1', 'https://open.spotify.com/track/7o9uu2GDtVDr9nsR7ZRN73', NULL, NOW(), NOW()),
('6VObnIkLVruX4UVyxWhlqm', 'Skyfall', 'Adele', 'Skyfall', 'https://i.scdn.co/image/ab67616d0000b273b479bb2aed275bb1b13d83da', 'https://open.spotify.com/track/6VObnIkLVruX4UVyxWhlqm', NULL, NOW(), NOW()),
('3USxtqRwSYz57Ewm6wWRMp', 'Heat Waves', 'Glass Animals', 'Dreamland', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'https://open.spotify.com/track/3USxtqRwSYz57Ewm6wWRMp', NULL, NOW(), NOW()),
('6EJiVf7U0p1BBfs0qqeb1f', 'Cut To The Feeling', 'Carly Rae Jepsen', 'Cut To The Feeling', 'https://i.scdn.co/image/ab67616d0000b273ef531a2218e0274cb4f67896', 'https://open.spotify.com/track/6EJiVf7U0p1BBfs0qqeb1f', NULL, NOW(), NOW()),
('39LLxExYz6ewLAcYrzQQyP', 'Levitating', 'Dua Lipa', 'Future Nostalgia', 'https://i.scdn.co/image/ab67616d0000b273c88bae7846e62a8ba59ee0bd', 'https://open.spotify.com/track/39LLxExYz6ewLAcYrzQQyP', NULL, NOW(), NOW()),
('4Dvkj6JhhA12EX05fT7y2e', 'As It Was', 'Harry Styles', 'Harry''s House', 'https://i.scdn.co/image/ab67616d0000b27382ce362511fb3d9dda6578ee', 'https://open.spotify.com/track/4Dvkj6JhhA12EX05fT7y2e', NULL, NOW(), NOW()),
('5wANPM4fQCJwkGd4rN57mH', 'drivers license', 'Olivia Rodrigo', 'SOUR', 'https://i.scdn.co/image/ab67616d0000b273a91c10fe9472d9bd89802e5a', 'https://open.spotify.com/track/5wANPM4fQCJwkGd4rN57mH', NULL, NOW(), NOW()),
('0V3wPSX9ygBnCm8psDIegu', 'Anti-Hero', 'Taylor Swift', 'Midnights', 'https://i.scdn.co/image/ab67616d0000b273bb54dde68cd23e2a268ae0f5', 'https://open.spotify.com/track/0V3wPSX9ygBnCm8psDIegu', NULL, NOW(), NOW()),
-- Hip-hop / R&B
('2xLMifQCjDGFmkHkpNLD9h', 'SICKO MODE', 'Travis Scott', 'ASTROWORLD', 'https://i.scdn.co/image/ab67616d0000b273daec894c14c0ca42d76eeb32', 'https://open.spotify.com/track/2xLMifQCjDGFmkHkpNLD9h', NULL, NOW(), NOW()),
('7MJQ9Nfxzh8LPZ9e9u68Fq', 'Lose Yourself', 'Eminem', 'SHADYXV', 'https://i.scdn.co/image/ab67616d0000b2733f66b5b49ccea004a5ef0db2', 'https://open.spotify.com/track/7MJQ9Nfxzh8LPZ9e9u68Fq', NULL, NOW(), NOW()),
('4iJyoBOLtHqaGxP12qzhQI', 'Peaches (feat. Daniel Caesar & Giveon)', 'Justin Bieber, Daniel Caesar, GIVĒON', 'Justice', 'https://i.scdn.co/image/ab67616d0000b273e6f407c7f3a0ec98845e4431', 'https://open.spotify.com/track/4iJyoBOLtHqaGxP12qzhQI', NULL, NOW(), NOW()),
-- Jazz / Lo-fi
('7FXj7Qg3YorUxdrzvrcY25', 'Fly Me To The Moon - 2008 Remastered', 'Frank Sinatra, Count Basie', 'Nothing But The Best (2008 Remastered)', 'https://i.scdn.co/image/ab67616d0000b273b81d66d1416afa139d12767b', 'https://open.spotify.com/track/7FXj7Qg3YorUxdrzvrcY25', NULL, NOW(), NOW()),
('1YQWosTIljIvxAgHWTp7KP', 'Take Five', 'The Dave Brubeck Quartet', 'Time Out', 'https://i.scdn.co/image/ab67616d0000b273b6bd44cf06bf8f4d5ce1e080', 'https://open.spotify.com/track/1YQWosTIljIvxAgHWTp7KP', NULL, NOW(), NOW()),
-- Classical / OST
('2agBDIr9MYDUducQPC1sFU', 'River Flows In You', 'Yiruma', 'First Love (The Original & the Very First Recording)', 'https://i.scdn.co/image/ab67616d0000b2734bdb66d1335f8571240e755f', 'https://open.spotify.com/track/2agBDIr9MYDUducQPC1sFU', NULL, NOW(), NOW()),
('1c3GkbZBnyrQ1cm4TGHFrK', 'Canon in D', 'Johann Pachelbel, Kanon Orchestre de Chambre, Jean-François Paillard', 'Pachelbel: Canon in D - Bach: Air on a G String - Handel: Largo from ''Xerxes'' - Hallelujah Chorus - Clarke: Trumpet Voluntary', 'https://i.scdn.co/image/ab67616d0000b273db8b4f88699f1033124ba8a5', 'https://open.spotify.com/track/1c3GkbZBnyrQ1cm4TGHFrK', NULL, NOW(), NOW()),
-- Rock / Alternative
('3z8h0TU7ReDPLIbEnYhWZb', 'Bohemian Rhapsody', 'Queen', 'Bohemian Rhapsody (The Original Soundtrack)', 'https://i.scdn.co/image/ab67616d0000b273e8b066f70c206551210d902b', 'https://open.spotify.com/track/3z8h0TU7ReDPLIbEnYhWZb', NULL, NOW(), NOW()),
('41tTCXOzxSWAoVrfeIIh8x', 'Wonderwall', 'Oasis', 'Time Flies...1994-2009', 'https://i.scdn.co/image/ab67616d0000b27324865fba42984f62aaa53d21', 'https://open.spotify.com/track/41tTCXOzxSWAoVrfeIIh8x', NULL, NOW(), NOW()),
('70LcF31zb1H0PyJoS1Sx1r', 'Creep', 'Radiohead', 'Pablo Honey', 'https://i.scdn.co/image/ab67616d0000b273ec548c00d3ac2f10be73366d', 'https://open.spotify.com/track/70LcF31zb1H0PyJoS1Sx1r', NULL, NOW(), NOW()),
('40riOy7x9W7GXjyGp4pjAv', 'Hotel California - 2013 Remaster', 'Eagles', 'Hotel California (2013 Remaster)', 'https://i.scdn.co/image/ab67616d0000b2734637341b9f507521afa9a778', 'https://open.spotify.com/track/40riOy7x9W7GXjyGp4pjAv', NULL, NOW(), NOW())
ON CONFLICT (spotify_track_id) DO NOTHING;


-- ========================================
-- 5. Places (Seoul 전역 - 25개 구 75+ locations)
-- ========================================
INSERT INTO places (place_name, address, lat, lng, geom, created_at, updated_at) VALUES
-- ─── 종로구 ───
('경복궁', '서울 종로구 사직로 161', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW(), NOW()),
('북촌한옥마을', '서울 종로구 계동길 37', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW(), NOW()),
('인사동 쌈지길', '서울 종로구 인사동길 44', 37.573924, 126.985019, ST_SetSRID(ST_MakePoint(126.985019, 37.573924), 4326), NOW(), NOW()),
('창덕궁', '서울 종로구 율곡로 99', 37.579400, 126.991100, ST_SetSRID(ST_MakePoint(126.991100, 37.579400), 4326), NOW(), NOW()),
('광화문광장', '서울 종로구 세종대로 172', 37.572280, 126.976890, ST_SetSRID(ST_MakePoint(126.976890, 37.572280), 4326), NOW(), NOW()),
('블루보틀 삼청점', '서울 종로구 삼청로 34', 37.584028, 126.982900, ST_SetSRID(ST_MakePoint(126.982900, 37.584028), 4326), NOW(), NOW()),
('종묘', '서울 종로구 종로 157', 37.574240, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.574240), 4326), NOW(), NOW()),

-- ─── 중구 ───
('명동거리', '서울 중구 명동길 74', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW(), NOW()),
('남대문시장', '서울 중구 남대문시장4길 21', 37.559398, 126.977600, ST_SetSRID(ST_MakePoint(126.977600, 37.559398), 4326), NOW(), NOW()),
('DDP 동대문디자인플라자', '서울 중구 을지로 281', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW(), NOW()),
('을지로3가 힙지로', '서울 중구 을지로 120', 37.566010, 126.991350, ST_SetSRID(ST_MakePoint(126.991350, 37.566010), 4326), NOW(), NOW()),
('남산골한옥마을', '서울 중구 퇴계로34길 28', 37.559050, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.559050), 4326), NOW(), NOW()),

-- ─── 용산구 ───
('N서울타워', '서울 용산구 남산공원길 105', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW(), NOW()),
('이태원 거리', '서울 용산구 이태원로', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW(), NOW()),
('국립중앙박물관', '서울 용산구 서빙고로 137', 37.523800, 126.980620, ST_SetSRID(ST_MakePoint(126.980620, 37.523800), 4326), NOW(), NOW()),
('한남동 카페거리', '서울 용산구 한남대로 42길', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW(), NOW()),
('용산전자상가', '서울 용산구 한강대로 258', 37.530500, 126.964700, ST_SetSRID(ST_MakePoint(126.964700, 37.530500), 4326), NOW(), NOW()),
('경리단길', '서울 용산구 녹사평대로40길', 37.537300, 126.987450, ST_SetSRID(ST_MakePoint(126.987450, 37.537300), 4326), NOW(), NOW()),

-- ─── 성동구 ───
('서울숲', '서울 성동구 뚝섬로 273', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW(), NOW()),
('성수동 카페거리', '서울 성동구 서울숲2길 44', 37.544200, 127.055800, ST_SetSRID(ST_MakePoint(127.055800, 37.544200), 4326), NOW(), NOW()),
('뚝섬역 벽화골목', '서울 성동구 뚝섬로 1', 37.547300, 127.047100, ST_SetSRID(ST_MakePoint(127.047100, 37.547300), 4326), NOW(), NOW()),
('성수 수제화거리', '서울 성동구 연무장3길 18', 37.544700, 127.052300, ST_SetSRID(ST_MakePoint(127.052300, 37.544700), 4326), NOW(), NOW()),
('성수역 앞 광장', '서울 성동구 성수이로 51', 37.544580, 127.055900, ST_SetSRID(ST_MakePoint(127.055900, 37.544580), 4326), NOW(), NOW()),
('성수 대림창고', '서울 성동구 성수이로7길 8', 37.544100, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.544100), 4326), NOW(), NOW()),
('성수연방', '서울 성동구 연무장15길 11', 37.543900, 127.054700, ST_SetSRID(ST_MakePoint(127.054700, 37.543900), 4326), NOW(), NOW()),
('어니언 성수점', '서울 성동구 아차산로9길 8', 37.545200, 127.056800, ST_SetSRID(ST_MakePoint(127.056800, 37.545200), 4326), NOW(), NOW()),
('성수 갤러리아포레', '서울 성동구 연무장5길 7', 37.545100, 127.053500, ST_SetSRID(ST_MakePoint(127.053500, 37.545100), 4326), NOW(), NOW()),
('뚝도시장', '서울 성동구 뚝섬로3길 15', 37.547800, 127.048200, ST_SetSRID(ST_MakePoint(127.048200, 37.547800), 4326), NOW(), NOW()),
('할아버지공장', '서울 성동구 연무장3길 8', 37.544400, 127.051800, ST_SetSRID(ST_MakePoint(127.051800, 37.544400), 4326), NOW(), NOW()),

-- ─── 광진구 ───
('건대입구 커먼그라운드', '서울 광진구 아차산로 200', 37.542470, 127.068100, ST_SetSRID(ST_MakePoint(127.068100, 37.542470), 4326), NOW(), NOW()),
('뚝섬유원지', '서울 광진구 강변역로 50', 37.531600, 127.066800, ST_SetSRID(ST_MakePoint(127.066800, 37.531600), 4326), NOW(), NOW()),
('어린이대공원', '서울 광진구 능동로 216', 37.548300, 127.080200, ST_SetSRID(ST_MakePoint(127.080200, 37.548300), 4326), NOW(), NOW()),

-- ─── 동대문구 ───
('경희대학교', '서울 동대문구 경희대로 26', 37.597010, 127.051480, ST_SetSRID(ST_MakePoint(127.051480, 37.597010), 4326), NOW(), NOW()),
('회기역 먹자골목', '서울 동대문구 회기로 188', 37.589500, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.589500), 4326), NOW(), NOW()),
('배봉산근린공원', '서울 동대문구 전농로 90', 37.580200, 127.060100, ST_SetSRID(ST_MakePoint(127.060100, 37.580200), 4326), NOW(), NOW()),

-- ─── 중랑구 ───
('용마폭포공원', '서울 중랑구 용마산로 250', 37.575400, 127.084300, ST_SetSRID(ST_MakePoint(127.084300, 37.575400), 4326), NOW(), NOW()),
('망우역사문화공원', '서울 중랑구 망우로 474', 37.598600, 127.105200, ST_SetSRID(ST_MakePoint(127.105200, 37.598600), 4326), NOW(), NOW()),

-- ─── 성북구 ───
('고려대학교', '서울 성북구 안암로 145', 37.589610, 127.032400, ST_SetSRID(ST_MakePoint(127.032400, 37.589610), 4326), NOW(), NOW()),
('성북동 수연산방', '서울 성북구 성북로26길 8', 37.593880, 127.007200, ST_SetSRID(ST_MakePoint(127.007200, 37.593880), 4326), NOW(), NOW()),
('길상사', '서울 성북구 선잠로5길 68', 37.600970, 127.006900, ST_SetSRID(ST_MakePoint(127.006900, 37.600970), 4326), NOW(), NOW()),

-- ─── 강북구 ───
('북한산 우이령길', '서울 강북구 삼양로 181길', 37.641580, 127.011900, ST_SetSRID(ST_MakePoint(127.011900, 37.641580), 4326), NOW(), NOW()),
('4.19민주묘지', '서울 강북구 수유동 산9-1', 37.647200, 127.017800, ST_SetSRID(ST_MakePoint(127.017800, 37.647200), 4326), NOW(), NOW()),

-- ─── 도봉구 ───
('도봉산역 등산로입구', '서울 도봉구 도봉산길 86', 37.689480, 127.044250, ST_SetSRID(ST_MakePoint(127.044250, 37.689480), 4326), NOW(), NOW()),
('무수골 계곡', '서울 도봉구 시루봉로 42', 37.680300, 127.040100, ST_SetSRID(ST_MakePoint(127.040100, 37.680300), 4326), NOW(), NOW()),

-- ─── 노원구 ───
('노원역 로데오거리', '서울 노원구 상계로 70', 37.656020, 127.061580, ST_SetSRID(ST_MakePoint(127.061580, 37.656020), 4326), NOW(), NOW()),
('수락산 등산로', '서울 노원구 덕릉로 901', 37.671800, 127.072200, ST_SetSRID(ST_MakePoint(127.072200, 37.671800), 4326), NOW(), NOW()),
('서울과학기술대학교', '서울 노원구 공릉로 232', 37.632040, 127.077750, ST_SetSRID(ST_MakePoint(127.077750, 37.632040), 4326), NOW(), NOW()),

-- ─── 은평구 ───
('은평한옥마을', '서울 은평구 진관길 62', 37.636400, 126.918300, ST_SetSRID(ST_MakePoint(126.918300, 37.636400), 4326), NOW(), NOW()),
('불광천 산책로', '서울 은평구 불광로 41', 37.617200, 126.924500, ST_SetSRID(ST_MakePoint(126.924500, 37.617200), 4326), NOW(), NOW()),
('서오릉', '서울 은평구 진관동 산1', 37.638500, 126.900200, ST_SetSRID(ST_MakePoint(126.900200, 37.638500), 4326), NOW(), NOW()),

-- ─── 서대문구 ───
('연세대학교', '서울 서대문구 연세로 50', 37.566536, 126.939370, ST_SetSRID(ST_MakePoint(126.939370, 37.566536), 4326), NOW(), NOW()),
('연남동 연트럴파크', '서울 서대문구 연남로 56', 37.566100, 126.925800, ST_SetSRID(ST_MakePoint(126.925800, 37.566100), 4326), NOW(), NOW()),
('이화여자대학교', '서울 서대문구 이화여대길 52', 37.562850, 126.946500, ST_SetSRID(ST_MakePoint(126.946500, 37.562850), 4326), NOW(), NOW()),
('신촌 거리', '서울 서대문구 연세로 37', 37.559700, 126.942200, ST_SetSRID(ST_MakePoint(126.942200, 37.559700), 4326), NOW(), NOW()),

-- ─── 마포구 ───
('홍익대학교', '서울 마포구 와우산로 94', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW(), NOW()),
('합정역 카페거리', '서울 마포구 양화로 183', 37.549460, 126.913580, ST_SetSRID(ST_MakePoint(126.913580, 37.549460), 4326), NOW(), NOW()),
('상수역 책방골목', '서울 마포구 와우산로29길 20', 37.547650, 126.922600, ST_SetSRID(ST_MakePoint(126.922600, 37.547650), 4326), NOW(), NOW()),
('망원한강공원', '서울 마포구 마포나루길 467', 37.551930, 126.895230, ST_SetSRID(ST_MakePoint(126.895230, 37.551930), 4326), NOW(), NOW()),
('연남동 골목길', '서울 마포구 동교로46길 33', 37.562400, 126.925500, ST_SetSRID(ST_MakePoint(126.925500, 37.562400), 4326), NOW(), NOW()),
('경의선숲길', '서울 마포구 토정로 10', 37.544900, 126.913200, ST_SetSRID(ST_MakePoint(126.913200, 37.544900), 4326), NOW(), NOW()),
('월드컵경기장', '서울 마포구 성산동 515', 37.568330, 126.897200, ST_SetSRID(ST_MakePoint(126.897200, 37.568330), 4326), NOW(), NOW()),

-- ─── 양천구 ───
('목동운동장', '서울 양천구 안양천로 939', 37.525700, 126.873600, ST_SetSRID(ST_MakePoint(126.873600, 37.525700), 4326), NOW(), NOW()),
('파리공원', '서울 양천구 목동동로 363', 37.528700, 126.872400, ST_SetSRID(ST_MakePoint(126.872400, 37.528700), 4326), NOW(), NOW()),

-- ─── 강서구 ───
('마곡나루역 서울식물원', '서울 강서구 마곡동로 161', 37.569000, 126.835400, ST_SetSRID(ST_MakePoint(126.835400, 37.569000), 4326), NOW(), NOW()),
('김포공항 하늘길', '서울 강서구 하늘길 112', 37.558990, 126.794540, ST_SetSRID(ST_MakePoint(126.794540, 37.558990), 4326), NOW(), NOW()),
('허준박물관', '서울 강서구 허준로 87', 37.543100, 126.847200, ST_SetSRID(ST_MakePoint(126.847200, 37.543100), 4326), NOW(), NOW()),

-- ─── 구로구 ───
('구로디지털단지역', '서울 구로구 디지털로 300', 37.485300, 126.901500, ST_SetSRID(ST_MakePoint(126.901500, 37.485300), 4326), NOW(), NOW()),
('신도림 디큐브시티', '서울 구로구 경인로 662', 37.508900, 126.891100, ST_SetSRID(ST_MakePoint(126.891100, 37.508900), 4326), NOW(), NOW()),
('항동철길', '서울 구로구 오류동', 37.482500, 126.863200, ST_SetSRID(ST_MakePoint(126.863200, 37.482500), 4326), NOW(), NOW()),

-- ─── 금천구 ───
('가산디지털단지', '서울 금천구 가산디지털1로 181', 37.478200, 126.882800, ST_SetSRID(ST_MakePoint(126.882800, 37.478200), 4326), NOW(), NOW()),
('독산역 카페거리', '서울 금천구 시흥대로 394', 37.468700, 126.895500, ST_SetSRID(ST_MakePoint(126.895500, 37.468700), 4326), NOW(), NOW()),

-- ─── 영등포구 ───
('한강공원 여의도', '서울 영등포구 여의동로 330', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW(), NOW()),
('영등포 타임스퀘어', '서울 영등포구 영중로 15', 37.517150, 126.903200, ST_SetSRID(ST_MakePoint(126.903200, 37.517150), 4326), NOW(), NOW()),
('선유도공원', '서울 영등포구 선유로 343', 37.541700, 126.899700, ST_SetSRID(ST_MakePoint(126.899700, 37.541700), 4326), NOW(), NOW()),
('여의도공원', '서울 영등포구 여의공원로 68', 37.525800, 126.922400, ST_SetSRID(ST_MakePoint(126.922400, 37.525800), 4326), NOW(), NOW()),
('63빌딩', '서울 영등포구 63로 50', 37.519780, 126.940120, ST_SetSRID(ST_MakePoint(126.940120, 37.519780), 4326), NOW(), NOW()),

-- ─── 동작구 ───
('노량진 수산시장', '서울 동작구 노량진로 688', 37.513600, 126.940800, ST_SetSRID(ST_MakePoint(126.940800, 37.513600), 4326), NOW(), NOW()),
('사당역 먹자골목', '서울 동작구 동작대로 156', 37.476600, 126.981700, ST_SetSRID(ST_MakePoint(126.981700, 37.476600), 4326), NOW(), NOW()),
('흑석동 중앙대학교', '서울 동작구 흑석로 84', 37.505300, 126.957600, ST_SetSRID(ST_MakePoint(126.957600, 37.505300), 4326), NOW(), NOW()),
('보라매공원', '서울 동작구 여의대방로20길 33', 37.493100, 126.927800, ST_SetSRID(ST_MakePoint(126.927800, 37.493100), 4326), NOW(), NOW()),

-- ─── 관악구 ───
('서울대학교', '서울 관악구 관악로 1', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW(), NOW()),
('신림역 순대타운', '서울 관악구 신림로 330', 37.484200, 126.929500, ST_SetSRID(ST_MakePoint(126.929500, 37.484200), 4326), NOW(), NOW()),
('낙성대공원', '서울 관악구 낙성대로 77', 37.477800, 126.963900, ST_SetSRID(ST_MakePoint(126.963900, 37.477800), 4326), NOW(), NOW()),
('관악산 등산로', '서울 관악구 남부순환로 1820', 37.446700, 126.964100, ST_SetSRID(ST_MakePoint(126.964100, 37.446700), 4326), NOW(), NOW()),

-- ─── 서초구 ───
('강남역 사거리', '서울 서초구 강남대로 396', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW(), NOW()),
('양재시민의숲', '서울 서초구 매헌로 99', 37.471400, 127.037800, ST_SetSRID(ST_MakePoint(127.037800, 37.471400), 4326), NOW(), NOW()),
('반포한강공원', '서울 서초구 신반포로 40', 37.510490, 127.008600, ST_SetSRID(ST_MakePoint(127.008600, 37.510490), 4326), NOW(), NOW()),
('예술의전당', '서울 서초구 남부순환로 2406', 37.478300, 127.011600, ST_SetSRID(ST_MakePoint(127.011600, 37.478300), 4326), NOW(), NOW()),
('서초동 법원거리 카페', '서울 서초구 서초중앙로 18', 37.492700, 127.017200, ST_SetSRID(ST_MakePoint(127.017200, 37.492700), 4326), NOW(), NOW()),
('반포 세빛섬', '서울 서초구 올림픽대로 2085', 37.512400, 127.001800, ST_SetSRID(ST_MakePoint(127.001800, 37.512400), 4326), NOW(), NOW()),

-- ─── 강남구 ───
('코엑스몰', '서울 강남구 영동대로 513', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW(), NOW()),
('테라로사 강남점', '서울 강남구 테헤란로 427', 37.508333, 127.061667, ST_SetSRID(ST_MakePoint(127.061667, 37.508333), 4326), NOW(), NOW()),
('압구정 로데오거리', '서울 강남구 압구정로 343', 37.527700, 127.040900, ST_SetSRID(ST_MakePoint(127.040900, 37.527700), 4326), NOW(), NOW()),
('가로수길', '서울 강남구 신사동 가로수길', 37.519200, 127.023500, ST_SetSRID(ST_MakePoint(127.023500, 37.519200), 4326), NOW(), NOW()),
('선릉공원', '서울 강남구 선릉로 100길 1', 37.508700, 127.048900, ST_SetSRID(ST_MakePoint(127.048900, 37.508700), 4326), NOW(), NOW()),
('봉은사', '서울 강남구 봉은사로 531', 37.515200, 127.057800, ST_SetSRID(ST_MakePoint(127.057800, 37.515200), 4326), NOW(), NOW()),
('삼성역 파르나스몰', '서울 강남구 테헤란로 521', 37.510400, 127.060300, ST_SetSRID(ST_MakePoint(127.060300, 37.510400), 4326), NOW(), NOW()),
('도산공원', '서울 강남구 도산대로 186', 37.523200, 127.035600, ST_SetSRID(ST_MakePoint(127.035600, 37.523200), 4326), NOW(), NOW()),

-- ─── 송파구 ───
('석촌호수', '서울 송파구 석촌호수로 16', 37.510760, 127.099430, ST_SetSRID(ST_MakePoint(127.099430, 37.510760), 4326), NOW(), NOW()),
('롯데월드타워', '서울 송파구 올림픽로 300', 37.512460, 127.102470, ST_SetSRID(ST_MakePoint(127.102470, 37.512460), 4326), NOW(), NOW()),
('올림픽공원', '서울 송파구 올림픽로 424', 37.520800, 127.121700, ST_SetSRID(ST_MakePoint(127.121700, 37.520800), 4326), NOW(), NOW()),
('잠실야구장', '서울 송파구 올림픽로 25', 37.512200, 127.071500, ST_SetSRID(ST_MakePoint(127.071500, 37.512200), 4326), NOW(), NOW()),
('방이동 먹자골목', '서울 송파구 오금로 268', 37.514200, 127.116700, ST_SetSRID(ST_MakePoint(127.116700, 37.514200), 4326), NOW(), NOW()),
('잠실한강공원', '서울 송파구 한가람로 65', 37.519300, 127.080600, ST_SetSRID(ST_MakePoint(127.080600, 37.519300), 4326), NOW(), NOW()),
('송리단길', '서울 송파구 백제고분로 398', 37.509300, 127.098200, ST_SetSRID(ST_MakePoint(127.098200, 37.509300), 4326), NOW(), NOW()),

-- ─── 강동구 ───
('천호역 로데오거리', '서울 강동구 천호대로 1033', 37.538500, 127.123400, ST_SetSRID(ST_MakePoint(127.123400, 37.538500), 4326), NOW(), NOW()),
('암사동 유적지', '서울 강동구 올림픽로 875', 37.551600, 127.131200, ST_SetSRID(ST_MakePoint(127.131200, 37.551600), 4326), NOW(), NOW()),
('강동 그린웨이', '서울 강동구 아리수로 93', 37.545800, 127.143500, ST_SetSRID(ST_MakePoint(127.143500, 37.545800), 4326), NOW(), NOW()),
('광나루한강공원', '서울 강동구 선사로 83-85', 37.541200, 127.100500, ST_SetSRID(ST_MakePoint(127.100500, 37.541200), 4326), NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ========================================
-- 6. Recommendations (대규모 - 서울 전역 120+)
-- ========================================

INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at) VALUES
-- ─── 종로구 (9) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='72IwoG8tqvIWV10IHjpNNA'), (SELECT id FROM places WHERE place_name='경복궁'), '궁궐을 걸으며 듣기 좋은 신나는 곡!', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW()-INTERVAL '50 days', NOW()-INTERVAL '50 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='경복궁'), '경복궁과 이루마의 조합', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='3P3UA61WRQqwCXaoFOTENd'), (SELECT id FROM places WHERE place_name='북촌한옥마을'), '한옥마을 걸으며 듣는 밤편지 감성 최고', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW()-INTERVAL '48 days', NOW()-INTERVAL '48 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='북촌한옥마을'), '한옥과 재즈의 만남, 신기하게 잘 어울려요', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='4TBHfv2isYco3fNKjQ8oSI'), (SELECT id FROM places WHERE place_name='인사동 쌈지길'), '인사동 구경하면서 새소년 듣기', 37.573924, 126.985019, ST_SetSRID(ST_MakePoint(126.985019, 37.573924), 4326), NOW()-INTERVAL '42 days', NOW()-INTERVAL '42 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='창덕궁'), '창덕궁 비원에서 카논 듣기', 37.579400, 126.991100, ST_SetSRID(ST_MakePoint(126.991100, 37.579400), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='0V3wPSX9ygBnCm8psDIegu'), (SELECT id FROM places WHERE place_name='광화문광장'), '광화문에서 Anti-Hero 들으니 묘하게 어울림', 37.572280, 126.976890, ST_SetSRID(ST_MakePoint(126.976890, 37.572280), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='3USxtqRwSYz57Ewm6wWRMp'), (SELECT id FROM places WHERE place_name='블루보틀 삼청점'), '커피 마시며 듣는 감성 인디 음악', 37.584028, 126.982900, ST_SetSRID(ST_MakePoint(126.982900, 37.584028), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='1YQWosTIljIvxAgHWTp7KP'), (SELECT id FROM places WHERE place_name='종묘'), '종묘의 고요함과 Take Five의 리듬', 37.574240, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.574240), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),

-- ─── 중구 (7) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='6bvZRLLkBKkmgpBJTTj3QK'), (SELECT id FROM places WHERE place_name='명동거리'), '명동 쇼핑하면서 블핑 How You Like That', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='7qiZfU4dY1lWllzX7mPBI3'), (SELECT id FROM places WHERE place_name='명동거리'), '명동 걸으면서 Shape of You 바운스', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='39LLxExYz6ewLAcYrzQQyP'), (SELECT id FROM places WHERE place_name='남대문시장'), '시장 구경하면서 Levitating 기분 up!', 37.559398, 126.977600, ST_SetSRID(ST_MakePoint(126.977600, 37.559398), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0Q5VnK2DYzRyfqQRJuUtvi'), (SELECT id FROM places WHERE place_name='DDP 동대문디자인플라자'), 'DDP 야경 + LOVE DIVE = 완벽 조합', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW()-INTERVAL '36 days', NOW()-INTERVAL '36 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='2IgbYlOlFpiSFYnsqB39lM'), (SELECT id FROM places WHERE place_name='을지로3가 힙지로'), '힙지로 감성에 DPR LIVE 찰떡!', 37.566010, 126.991350, ST_SetSRID(ST_MakePoint(126.991350, 37.566010), 4326), NOW()-INTERVAL '33 days', NOW()-INTERVAL '33 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='70LcF31zb1H0PyJoS1Sx1r'), (SELECT id FROM places WHERE place_name='을지로3가 힙지로'), '을지로 맥주 + Radiohead Creep 감성', 37.566010, 126.991350, ST_SetSRID(ST_MakePoint(126.991350, 37.566010), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='남산골한옥마을'), '남산골에서 듣는 River Flows in You 감동', 37.559050, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.559050), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),

-- ─── 용산구 (8) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='0VjIjW4GlUZAMYd2vXMi3b'), (SELECT id FROM places WHERE place_name='N서울타워'), '야경을 보며 듣는 The Weeknd 최고!', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW()-INTERVAL '46 days', NOW()-INTERVAL '46 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='7qEHsqek33rTcFNT9PFqLf'), (SELECT id FROM places WHERE place_name='N서울타워'), '남산타워 야경에 Someone You Loved 눈물날뻔', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW()-INTERVAL '12 days', NOW()-INTERVAL '12 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='003vvx7Niy0yvhvHt4a68B'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원의 밤 분위기와 딱!', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='2xLMifQCjDGFmkHkpNLD9h'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원 클럽 분위기에 SICKO MODE', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='국립중앙박물관'), '박물관의 고즈넉한 분위기에 클래식이 딱', 37.523800, 126.980620, ST_SetSRID(ST_MakePoint(126.980620, 37.523800), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='2IgbYlOlFpiSFYnsqB39lM'), (SELECT id FROM places WHERE place_name='한남동 카페거리'), '한남동 카페에서 DPR LIVE', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='3z8h0TU7ReDPLIbEnYhWZb'), (SELECT id FROM places WHERE place_name='용산전자상가'), '전자상가 구경하면서 Bohemian Rhapsody 열창', 37.530500, 126.964700, ST_SetSRID(ST_MakePoint(126.964700, 37.530500), 4326), NOW()-INTERVAL '34 days', NOW()-INTERVAL '34 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='4Dvkj6JhhA12EX05fT7y2e'), (SELECT id FROM places WHERE place_name='경리단길'), '경리단길 인생샷 스팟에서 As It Was', 37.537300, 126.987450, ST_SetSRID(ST_MakePoint(126.987450, 37.537300), 4326), NOW()-INTERVAL '31 days', NOW()-INTERVAL '31 days'),

-- ─── 성동구 (5+15=20, 수제화거리 중심) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='4TBHfv2isYco3fNKjQ8oSI'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 산책에 새소년 노래 최고', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '39 days', NOW()-INTERVAL '39 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='3USxtqRwSYz57Ewm6wWRMp'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 피크닉 + Heat Waves = 여유', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '22 days', NOW()-INTERVAL '22 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='0a4MMyCrzT0En247IhqZbD'), (SELECT id FROM places WHERE place_name='성수동 카페거리'), '성수동 핫플에서 Hype Boy 텐션 업!', 37.544200, 127.055800, ST_SetSRID(ST_MakePoint(127.055800, 37.544200), 4326), NOW()-INTERVAL '32 days', NOW()-INTERVAL '32 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='3r8RuvgbX9s7ammBn07D3W'), (SELECT id FROM places WHERE place_name='성수동 카페거리'), '성수에서 뉴진스 Ditto 들으면서 카페투어', 37.544200, 127.055800, ST_SetSRID(ST_MakePoint(127.055800, 37.544200), 4326), NOW()-INTERVAL '18 days', NOW()-INTERVAL '18 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='41tTCXOzxSWAoVrfeIIh8x'), (SELECT id FROM places WHERE place_name='뚝섬역 벽화골목'), '벽화골목에서 Wonderwall 분위기', 37.547300, 127.047100, ST_SetSRID(ST_MakePoint(127.047100, 37.547300), 4326), NOW()-INTERVAL '27 days', NOW()-INTERVAL '27 days'),
-- 수제화거리 주변 추가 추천
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='3P3UA61WRQqwCXaoFOTENd'), (SELECT id FROM places WHERE place_name='성수 수제화거리'), '수제화거리 장인의 손길 느끼며 IU 밤편지', 37.544700, 127.052300, ST_SetSRID(ST_MakePoint(127.052300, 37.544700), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='성수 수제화거리'), '가죽 냄새와 재즈의 조합이 이렇게 잘 어울리다니', 37.544700, 127.052300, ST_SetSRID(ST_MakePoint(127.052300, 37.544700), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='2IgbYlOlFpiSFYnsqB39lM'), (SELECT id FROM places WHERE place_name='성수 수제화거리'), '수제화 구경하면서 DPR LIVE 감성 뿜뿜', 37.544700, 127.052300, ST_SetSRID(ST_MakePoint(127.052300, 37.544700), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='4Dvkj6JhhA12EX05fT7y2e'), (SELECT id FROM places WHERE place_name='성수 수제화거리'), '깔끔한 수제화 매장 앞에서 As It Was 딱', 37.544700, 127.052300, ST_SetSRID(ST_MakePoint(127.052300, 37.544700), 4326), NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='41tTCXOzxSWAoVrfeIIh8x'), (SELECT id FROM places WHERE place_name='성수역 앞 광장'), '성수역 나와서 Wonderwall 흥얼거리기', 37.544580, 127.055900, ST_SetSRID(ST_MakePoint(127.055900, 37.544580), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='0a4MMyCrzT0En247IhqZbD'), (SELECT id FROM places WHERE place_name='성수역 앞 광장'), '성수역 광장에서 뉴진스 Hype Boy 텐션', 37.544580, 127.055900, ST_SetSRID(ST_MakePoint(127.055900, 37.544580), 4326), NOW()-INTERVAL '12 days', NOW()-INTERVAL '12 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='1YQWosTIljIvxAgHWTp7KP'), (SELECT id FROM places WHERE place_name='성수 대림창고'), '대림창고 전시 보면서 Take Five 재즈 감상', 37.544100, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.544100), 4326), NOW()-INTERVAL '26 days', NOW()-INTERVAL '26 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='70LcF31zb1H0PyJoS1Sx1r'), (SELECT id FROM places WHERE place_name='성수 대림창고'), '대림창고 인더스트리얼 감성에 Creep 찰떡', 37.544100, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.544100), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='5wANPM4fQCJwkGd4rN57mH'), (SELECT id FROM places WHERE place_name='성수연방'), '성수연방 루프탑에서 drivers license 감성', 37.543900, 127.054700, ST_SetSRID(ST_MakePoint(127.054700, 37.543900), 4326), NOW()-INTERVAL '23 days', NOW()-INTERVAL '23 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='0Q5VnK2DYzRyfqQRJuUtvi'), (SELECT id FROM places WHERE place_name='성수연방'), '성수연방 중 IVE LOVE DIVE 들으면 텐션 UP', 37.543900, 127.054700, ST_SetSRID(ST_MakePoint(127.054700, 37.543900), 4326), NOW()-INTERVAL '7 days', NOW()-INTERVAL '7 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='어니언 성수점'), '어니언 빵 냄새와 이루마 피아노의 힐링 조합', 37.545200, 127.056800, ST_SetSRID(ST_MakePoint(127.056800, 37.545200), 4326), NOW()-INTERVAL '21 days', NOW()-INTERVAL '21 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='0V3wPSX9ygBnCm8psDIegu'), (SELECT id FROM places WHERE place_name='어니언 성수점'), '어니언 2층 창가에서 Anti-Hero 들으면 주인공 느낌', 37.545200, 127.056800, ST_SetSRID(ST_MakePoint(127.056800, 37.545200), 4326), NOW()-INTERVAL '9 days', NOW()-INTERVAL '9 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='39LLxExYz6ewLAcYrzQQyP'), (SELECT id FROM places WHERE place_name='성수 갤러리아포레'), '갤러리아포레 산책길에 Levitating 기분 좋음', 37.545100, 127.053500, ST_SetSRID(ST_MakePoint(127.053500, 37.545100), 4326), NOW()-INTERVAL '19 days', NOW()-INTERVAL '19 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='2xLMifQCjDGFmkHkpNLD9h'), (SELECT id FROM places WHERE place_name='뚝도시장'), '뚝도시장 로컬 감성에 SICKO MODE 묘한 조합', 37.547800, 127.048200, ST_SetSRID(ST_MakePoint(127.048200, 37.547800), 4326), NOW()-INTERVAL '16 days', NOW()-INTERVAL '16 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='4g6XOg9rvB55GCTJcYchOG'), (SELECT id FROM places WHERE place_name='할아버지공장'), '할아버지공장에서 창모 METEOR 들으며 작업', 37.544400, 127.051800, ST_SetSRID(ST_MakePoint(127.051800, 37.544400), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),

-- ─── 광진구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='68r87x3VZdAMhv8nBVuynz'), (SELECT id FROM places WHERE place_name='건대입구 커먼그라운드'), '건대 커먼그라운드에서 Queencard 파워워킹', 37.542470, 127.068100, ST_SetSRID(ST_MakePoint(127.068100, 37.542470), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='1mWdTewIgB3gtBM3TOSFhB'), (SELECT id FROM places WHERE place_name='뚝섬유원지'), '뚝섬 한강에서 Butter 들으면서 치맥', 37.531600, 127.066800, ST_SetSRID(ST_MakePoint(127.066800, 37.531600), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='4iJyoBOLtHqaGxP12qzhQI'), (SELECT id FROM places WHERE place_name='어린이대공원'), '어린이대공원 산책에 Peaches 달콤', 37.548300, 127.080200, ST_SetSRID(ST_MakePoint(127.080200, 37.548300), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),

-- ─── 동대문구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0ObcVIFoDdBBClvABfJvdz'), (SELECT id FROM places WHERE place_name='경희대학교'), '경희대 캠퍼스에서 MANIAC 텐션', 37.597010, 127.051480, ST_SetSRID(ST_MakePoint(127.051480, 37.597010), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='0pYacDCZuRhcrwGUA5nTBe'), (SELECT id FROM places WHERE place_name='회기역 먹자골목'), '회기 떡볶이 먹으면서 IU Eight', 37.589500, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.589500), 4326), NOW()-INTERVAL '29 days', NOW()-INTERVAL '29 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='40riOy7x9W7GXjyGp4pjAv'), (SELECT id FROM places WHERE place_name='배봉산근린공원'), '배봉산 석양에 Hotel California 감성', 37.580200, 127.060100, ST_SetSRID(ST_MakePoint(127.060100, 37.580200), 4326), NOW()-INTERVAL '19 days', NOW()-INTERVAL '19 days'),

-- ─── 중랑구 (2) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='3z8h0TU7ReDPLIbEnYhWZb'), (SELECT id FROM places WHERE place_name='용마폭포공원'), '폭포 앞에서 Bohemian Rhapsody 불렀다', 37.575400, 127.084300, ST_SetSRID(ST_MakePoint(127.084300, 37.575400), 4326), NOW()-INTERVAL '36 days', NOW()-INTERVAL '36 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='5wANPM4fQCJwkGd4rN57mH'), (SELECT id FROM places WHERE place_name='망우역사문화공원'), '산책길에 drivers license 감성폭발', 37.598600, 127.105200, ST_SetSRID(ST_MakePoint(127.105200, 37.598600), 4326), NOW()-INTERVAL '24 days', NOW()-INTERVAL '24 days'),

-- ─── 성북구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='4RewTiGEGoO7FWNZUmp1f4'), (SELECT id FROM places WHERE place_name='고려대학교'), '고대 캠퍼스에서 Celebrity 들으면 뭐든 셀럽', 37.589610, 127.032400, ST_SetSRID(ST_MakePoint(127.032400, 37.589610), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='성북동 수연산방'), '수연산방 차 마시며 Fly Me to the Moon', 37.593880, 127.007200, ST_SetSRID(ST_MakePoint(127.007200, 37.593880), 4326), NOW()-INTERVAL '33 days', NOW()-INTERVAL '33 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='길상사'), '길상사의 고요함에 이루마 피아노가 흐르면', 37.600970, 127.006900, ST_SetSRID(ST_MakePoint(127.006900, 37.600970), 4326), NOW()-INTERVAL '26 days', NOW()-INTERVAL '26 days'),

-- ─── 강북구 (2) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='41tTCXOzxSWAoVrfeIIh8x'), (SELECT id FROM places WHERE place_name='북한산 우이령길'), '등산하면서 Wonderwall 따라 부르기', 37.641580, 127.011900, ST_SetSRID(ST_MakePoint(127.011900, 37.641580), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='7MJQ9Nfxzh8LPZ9e9u68Fq'), (SELECT id FROM places WHERE place_name='4.19민주묘지'), '역사적 장소에서 Lose Yourself 결의', 37.647200, 127.017800, ST_SetSRID(ST_MakePoint(127.017800, 37.647200), 4326), NOW()-INTERVAL '21 days', NOW()-INTERVAL '21 days'),

-- ─── 도봉구 (2) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='3AOf6YEpxQ894FmrwI9k96'), (SELECT id FROM places WHERE place_name='도봉산역 등산로입구'), '도봉산 오르면서 세븐틴 Super 들으면 힘남!', 37.689480, 127.044250, ST_SetSRID(ST_MakePoint(127.044250, 37.689480), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='무수골 계곡'), '계곡 물소리 + 카논 = 힐링 최고봉', 37.680300, 127.040100, ST_SetSRID(ST_MakePoint(127.040100, 37.680300), 4326), NOW()-INTERVAL '23 days', NOW()-INTERVAL '23 days'),

-- ─── 노원구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='0Q5VnK2DYzRyfqQRJuUtvi'), (SELECT id FROM places WHERE place_name='노원역 로데오거리'), '노원 로데오에서 LOVE DIVE 쇼핑 기분', 37.656020, 127.061580, ST_SetSRID(ST_MakePoint(127.061580, 37.656020), 4326), NOW()-INTERVAL '34 days', NOW()-INTERVAL '34 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='40riOy7x9W7GXjyGp4pjAv'), (SELECT id FROM places WHERE place_name='수락산 등산로'), '수락산 정상에서 Hotel California 뷰', 37.671800, 127.072200, ST_SetSRID(ST_MakePoint(127.072200, 37.671800), 4326), NOW()-INTERVAL '14 days', NOW()-INTERVAL '14 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='4g6XOg9rvB55GCTJcYchOG'), (SELECT id FROM places WHERE place_name='서울과학기술대학교'), '과기대 야경에 창모 METEOR 감성', 37.632040, 127.077750, ST_SetSRID(ST_MakePoint(127.077750, 37.632040), 4326), NOW()-INTERVAL '17 days', NOW()-INTERVAL '17 days'),

-- ─── 은평구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='3P3UA61WRQqwCXaoFOTENd'), (SELECT id FROM places WHERE place_name='은평한옥마을'), '은평한옥마을 걸으며 IU 밤편지', 37.636400, 126.918300, ST_SetSRID(ST_MakePoint(126.918300, 37.636400), 4326), NOW()-INTERVAL '31 days', NOW()-INTERVAL '31 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='1YQWosTIljIvxAgHWTp7KP'), (SELECT id FROM places WHERE place_name='불광천 산책로'), '불광천 따라 걸으며 Take Five 재즈 산책', 37.617200, 126.924500, ST_SetSRID(ST_MakePoint(126.924500, 37.617200), 4326), NOW()-INTERVAL '16 days', NOW()-INTERVAL '16 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='7o9uu2GDtVDr9nsR7ZRN73'), (SELECT id FROM places WHERE place_name='서오릉'), '서오릉 고즈넉한 길에 Time After Time', 37.638500, 126.900200, ST_SetSRID(ST_MakePoint(126.900200, 37.638500), 4326), NOW()-INTERVAL '11 days', NOW()-INTERVAL '11 days'),

-- ─── 서대문구 (4) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='6VObnIkLVruX4UVyxWhlqm'), (SELECT id FROM places WHERE place_name='연세대학교'), '연대 캠퍼스 걸으며 Adele Skyfall 감성', 37.566536, 126.939370, ST_SetSRID(ST_MakePoint(126.939370, 37.566536), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='0a4MMyCrzT0En247IhqZbD'), (SELECT id FROM places WHERE place_name='연남동 연트럴파크'), '연트럴파크에서 Hype Boy 산책', 37.566100, 126.925800, ST_SetSRID(ST_MakePoint(126.925800, 37.566100), 4326), NOW()-INTERVAL '7 days', NOW()-INTERVAL '7 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0pYacDCZuRhcrwGUA5nTBe'), (SELECT id FROM places WHERE place_name='이화여자대학교'), '이대 교정에서 IU Eight 듣기', 37.562850, 126.946500, ST_SetSRID(ST_MakePoint(126.946500, 37.562850), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='39LLxExYz6ewLAcYrzQQyP'), (SELECT id FROM places WHERE place_name='신촌 거리'), '신촌 거리에서 Levitating 바운스!', 37.559700, 126.942200, ST_SetSRID(ST_MakePoint(126.942200, 37.559700), 4326), NOW()-INTERVAL '29 days', NOW()-INTERVAL '29 days'),

-- ─── 마포구 (8) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='5c58c6sKc2JK3o75ZBSeL1'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 거리에서 춤추고 싶어지는 곡!', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '49 days', NOW()-INTERVAL '49 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='68r87x3VZdAMhv8nBVuynz'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대에서 Queencard 들으면 자신감 MAX', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='6EJiVf7U0p1BBfs0qqeb1f'), (SELECT id FROM places WHERE place_name='합정역 카페거리'), '합정 카페에서 Cut to the Feeling 들으면 행복', 37.549460, 126.913580, ST_SetSRID(ST_MakePoint(126.913580, 37.549460), 4326), NOW()-INTERVAL '42 days', NOW()-INTERVAL '42 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='4TBHfv2isYco3fNKjQ8oSI'), (SELECT id FROM places WHERE place_name='상수역 책방골목'), '상수 독립서점에서 새소년 듣기', 37.547650, 126.922600, ST_SetSRID(ST_MakePoint(126.922600, 37.547650), 4326), NOW()-INTERVAL '26 days', NOW()-INTERVAL '26 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7qiZfU4dY1lWllzX7mPBI3'), (SELECT id FROM places WHERE place_name='망원한강공원'), '자전거 타면서 듣기 완벽한 곡', 37.551930, 126.895230, ST_SetSRID(ST_MakePoint(126.895230, 37.551930), 4326), NOW()-INTERVAL '46 days', NOW()-INTERVAL '46 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='69WpV0U7OMNFGyq8I63dcC'), (SELECT id FROM places WHERE place_name='연남동 골목길'), '연남동 골목 탐험하면서 ENHYPEN Given-Taken 듣기', 37.562400, 126.925500, ST_SetSRID(ST_MakePoint(126.925500, 37.562400), 4326), NOW()-INTERVAL '21 days', NOW()-INTERVAL '21 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='경의선숲길'), '경의선숲길 산책에 Fly Me to the Moon', 37.544900, 126.913200, ST_SetSRID(ST_MakePoint(126.913200, 37.544900), 4326), NOW()-INTERVAL '33 days', NOW()-INTERVAL '33 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='72IwoG8tqvIWV10IHjpNNA'), (SELECT id FROM places WHERE place_name='월드컵경기장'), '월드컵경기장에서 Dynamite 응원가 버전!', 37.568330, 126.897200, ST_SetSRID(ST_MakePoint(126.897200, 37.568330), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),

-- ─── 양천구 (2) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='7MJQ9Nfxzh8LPZ9e9u68Fq'), (SELECT id FROM places WHERE place_name='목동운동장'), '목동 운동장 조깅하면서 Lose Yourself 파이팅', 37.525700, 126.873600, ST_SetSRID(ST_MakePoint(126.873600, 37.525700), 4326), NOW()-INTERVAL '39 days', NOW()-INTERVAL '39 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='4iJyoBOLtHqaGxP12qzhQI'), (SELECT id FROM places WHERE place_name='파리공원'), '파리공원 벤치에서 Peaches 듣기', 37.528700, 126.872400, ST_SetSRID(ST_MakePoint(126.872400, 37.528700), 4326), NOW()-INTERVAL '24 days', NOW()-INTERVAL '24 days'),

-- ─── 강서구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='4fsQ0K37TOXa3hEQfjEic1'), (SELECT id FROM places WHERE place_name='마곡나루역 서울식물원'), '식물원에서 LE SSERAFIM 듣기', 37.569000, 126.835400, ST_SetSRID(ST_MakePoint(126.835400, 37.569000), 4326), NOW()-INTERVAL '36 days', NOW()-INTERVAL '36 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='4Dvkj6JhhA12EX05fT7y2e'), (SELECT id FROM places WHERE place_name='김포공항 하늘길'), '공항 가는 길에 As It Was 들으면 여행 기분', 37.558990, 126.794540, ST_SetSRID(ST_MakePoint(126.794540, 37.558990), 4326), NOW()-INTERVAL '27 days', NOW()-INTERVAL '27 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='허준박물관'), '허준박물관 고요한 분위기에 이루마 피아노', 37.543100, 126.847200, ST_SetSRID(ST_MakePoint(126.847200, 37.543100), 4326), NOW()-INTERVAL '13 days', NOW()-INTERVAL '13 days'),

-- ─── 구로구 (3) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='4g6XOg9rvB55GCTJcYchOG'), (SELECT id FROM places WHERE place_name='구로디지털단지역'), '야근 후 퇴근길에 창모 METEOR', 37.485300, 126.901500, ST_SetSRID(ST_MakePoint(126.901500, 37.485300), 4326), NOW()-INTERVAL '32 days', NOW()-INTERVAL '32 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='0V3wPSX9ygBnCm8psDIegu'), (SELECT id FROM places WHERE place_name='신도림 디큐브시티'), '디큐브시티에서 Taylor Swift Anti-Hero', 37.508900, 126.891100, ST_SetSRID(ST_MakePoint(126.891100, 37.508900), 4326), NOW()-INTERVAL '18 days', NOW()-INTERVAL '18 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='70LcF31zb1H0PyJoS1Sx1r'), (SELECT id FROM places WHERE place_name='항동철길'), '폐철길 감성에 Radiohead Creep 완벽 매칭', 37.482500, 126.863200, ST_SetSRID(ST_MakePoint(126.863200, 37.482500), 4326), NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'),

-- ─── 금천구 (2) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0ObcVIFoDdBBClvABfJvdz'), (SELECT id FROM places WHERE place_name='가산디지털단지'), '가디에서 Stray Kids MANIAC으로 텐션업', 37.478200, 126.882800, ST_SetSRID(ST_MakePoint(126.882800, 37.478200), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='1YQWosTIljIvxAgHWTp7KP'), (SELECT id FROM places WHERE place_name='독산역 카페거리'), '독산 로컬 카페에서 Take Five 재즈타임', 37.468700, 126.895500, ST_SetSRID(ST_MakePoint(126.895500, 37.468700), 4326), NOW()-INTERVAL '9 days', NOW()-INTERVAL '9 days'),

-- ─── 영등포구 (6) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7qiZfU4dY1lWllzX7mPBI3'), (SELECT id FROM places WHERE place_name='한강공원 여의도'), '여의도 자전거 + Shape of You = 운동 완벽 BGM', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0VjIjW4GlUZAMYd2vXMi3b'), (SELECT id FROM places WHERE place_name='한강공원 여의도'), '여의도 한강 야경에 Blinding Lights', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW()-INTERVAL '19 days', NOW()-INTERVAL '19 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='39LLxExYz6ewLAcYrzQQyP'), (SELECT id FROM places WHERE place_name='영등포 타임스퀘어'), '타임스퀘어 쇼핑하면서 Levitating', 37.517150, 126.903200, ST_SetSRID(ST_MakePoint(126.903200, 37.517150), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='3P3UA61WRQqwCXaoFOTENd'), (SELECT id FROM places WHERE place_name='선유도공원'), '선유도 석양에 IU 밤편지 들으면 감성 터짐', 37.541700, 126.899700, ST_SetSRID(ST_MakePoint(126.899700, 37.541700), 4326), NOW()-INTERVAL '34 days', NOW()-INTERVAL '34 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='6VObnIkLVruX4UVyxWhlqm'), (SELECT id FROM places WHERE place_name='63빌딩'), '63빌딩 전망대에서 Skyfall 들으면 제임스본드', 37.519780, 126.940120, ST_SetSRID(ST_MakePoint(126.940120, 37.519780), 4326), NOW()-INTERVAL '22 days', NOW()-INTERVAL '22 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='여의도공원'), '여의도공원 벚꽃길에 카논 흐르면', 37.525800, 126.922400, ST_SetSRID(ST_MakePoint(126.922400, 37.525800), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),

-- ─── 동작구 (4) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='2IgbYlOlFpiSFYnsqB39lM'), (SELECT id FROM places WHERE place_name='노량진 수산시장'), '노량진 수산시장 활기에 DPR LIVE 찰떡', 37.513600, 126.940800, ST_SetSRID(ST_MakePoint(126.940800, 37.513600), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='2xLMifQCjDGFmkHkpNLD9h'), (SELECT id FROM places WHERE place_name='사당역 먹자골목'), '사당 먹자골목 탐방에 SICKO MODE 텐션', 37.476600, 126.981700, ST_SetSRID(ST_MakePoint(126.981700, 37.476600), 4326), NOW()-INTERVAL '23 days', NOW()-INTERVAL '23 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='4RewTiGEGoO7FWNZUmp1f4'), (SELECT id FROM places WHERE place_name='흑석동 중앙대학교'), '중앙대 캠퍼스에서 IU Celebrity 들으면 기분 UP', 37.505300, 126.957600, ST_SetSRID(ST_MakePoint(126.957600, 37.505300), 4326), NOW()-INTERVAL '26 days', NOW()-INTERVAL '26 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='3USxtqRwSYz57Ewm6wWRMp'), (SELECT id FROM places WHERE place_name='보라매공원'), '보라매공원 조깅하면서 Heat Waves', 37.493100, 126.927800, ST_SetSRID(ST_MakePoint(126.927800, 37.493100), 4326), NOW()-INTERVAL '16 days', NOW()-INTERVAL '16 days'),

-- ─── 관악구 (5) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='4RewTiGEGoO7FWNZUmp1f4'), (SELECT id FROM places WHERE place_name='서울대학교'), '캠퍼스를 걸으며 듣는 IU Celebrity', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='7MJQ9Nfxzh8LPZ9e9u68Fq'), (SELECT id FROM places WHERE place_name='서울대학교'), '서울대 도서관 앞에서 Lose Yourself 공부 의지', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW()-INTERVAL '14 days', NOW()-INTERVAL '14 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='6bvZRLLkBKkmgpBJTTj3QK'), (SELECT id FROM places WHERE place_name='신림역 순대타운'), '신림 순대국 먹으면서 블핑 텐션', 37.484200, 126.929500, ST_SetSRID(ST_MakePoint(126.929500, 37.484200), 4326), NOW()-INTERVAL '31 days', NOW()-INTERVAL '31 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='7qEHsqek33rTcFNT9PFqLf'), (SELECT id FROM places WHERE place_name='낙성대공원'), '낙성대 벤치에서 Someone You Loved 감성', 37.477800, 126.963900, ST_SetSRID(ST_MakePoint(126.963900, 37.477800), 4326), NOW()-INTERVAL '19 days', NOW()-INTERVAL '19 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='41tTCXOzxSWAoVrfeIIh8x'), (SELECT id FROM places WHERE place_name='관악산 등산로'), '관악산 정상에서 Wonderwall 소리질렀다', 37.446700, 126.964100, ST_SetSRID(ST_MakePoint(126.964100, 37.446700), 4326), NOW()-INTERVAL '9 days', NOW()-INTERVAL '9 days'),

-- ─── 서초구 (7) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='3r8RuvgbX9s7ammBn07D3W'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역 쇼핑 + 뉴진스 Ditto 조합', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='72IwoG8tqvIWV10IHjpNNA'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역에서 BTS Dynamite 들으면 에너지 충전', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '11 days', NOW()-INTERVAL '11 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='양재시민의숲'), '숲에서 듣는 River Flows in You 힐링', 37.471400, 127.037800, ST_SetSRID(ST_MakePoint(127.037800, 37.471400), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='반포한강공원'), '반포 달빛무지개분수 + Fly Me to the Moon', 37.510490, 127.008600, ST_SetSRID(ST_MakePoint(127.008600, 37.510490), 4326), NOW()-INTERVAL '29 days', NOW()-INTERVAL '29 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='예술의전당'), '예술의전당 앞 광장에서 카논 라이브 뺨치게', 37.478300, 127.011600, ST_SetSRID(ST_MakePoint(127.011600, 37.478300), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='2IgbYlOlFpiSFYnsqB39lM'), (SELECT id FROM places WHERE place_name='서초동 법원거리 카페'), '법원거리 카페에서 DPR LIVE 작업용 BGM', 37.492700, 127.017200, ST_SetSRID(ST_MakePoint(127.017200, 37.492700), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='0VjIjW4GlUZAMYd2vXMi3b'), (SELECT id FROM places WHERE place_name='반포 세빛섬'), '세빛섬 야경에 Blinding Lights 완벽', 37.512400, 127.001800, ST_SetSRID(ST_MakePoint(127.001800, 37.512400), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),

-- ─── 강남구 (9) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='0a4MMyCrzT0En247IhqZbD'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 별마당에서 Hype Boy 들으면 분위기 UP', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='4fsQ0K37TOXa3hEQfjEic1'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 쇼핑에 르세라핌 ANTIFRAGILE 텐션', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW()-INTERVAL '13 days', NOW()-INTERVAL '13 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='3USxtqRwSYz57Ewm6wWRMp'), (SELECT id FROM places WHERE place_name='테라로사 강남점'), '테라로사 아메리카노 + Heat Waves', 37.508333, 127.061667, ST_SetSRID(ST_MakePoint(127.061667, 37.508333), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='5wANPM4fQCJwkGd4rN57mH'), (SELECT id FROM places WHERE place_name='압구정 로데오거리'), '압구정 걸으면서 drivers license 감성 드라이브', 37.527700, 127.040900, ST_SetSRID(ST_MakePoint(127.040900, 37.527700), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4Dvkj6JhhA12EX05fT7y2e'), (SELECT id FROM places WHERE place_name='가로수길'), '가로수길 카페 호핑하면서 As It Was', 37.519200, 127.023500, ST_SetSRID(ST_MakePoint(127.023500, 37.519200), 4326), NOW()-INTERVAL '32 days', NOW()-INTERVAL '32 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='1YQWosTIljIvxAgHWTp7KP'), (SELECT id FROM places WHERE place_name='선릉공원'), '선릉 점심 산책에 재즈 Take Five 힐링', 37.508700, 127.048900, ST_SetSRID(ST_MakePoint(127.048900, 37.508700), 4326), NOW()-INTERVAL '27 days', NOW()-INTERVAL '27 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='봉은사'), '봉은사 템플스테이에서 이루마 명상', 37.515200, 127.057800, ST_SetSRID(ST_MakePoint(127.057800, 37.515200), 4326), NOW()-INTERVAL '22 days', NOW()-INTERVAL '22 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='0Q5VnK2DYzRyfqQRJuUtvi'), (SELECT id FROM places WHERE place_name='삼성역 파르나스몰'), '파르나스몰에서 IVE LOVE DIVE 쇼핑 텐션', 37.510400, 127.060300, ST_SetSRID(ST_MakePoint(127.060300, 37.510400), 4326), NOW()-INTERVAL '17 days', NOW()-INTERVAL '17 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='69WpV0U7OMNFGyq8I63dcC'), (SELECT id FROM places WHERE place_name='도산공원'), '도산공원 산책 + ENHYPEN Given-Taken', 37.523200, 127.035600, ST_SetSRID(ST_MakePoint(127.035600, 37.523200), 4326), NOW()-INTERVAL '12 days', NOW()-INTERVAL '12 days'),

-- ─── 송파구 (9) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='3r8RuvgbX9s7ammBn07D3W'), (SELECT id FROM places WHERE place_name='석촌호수'), '석촌호수 벚꽃놀이에 뉴진스 Ditto', 37.510760, 127.099430, ST_SetSRID(ST_MakePoint(127.099430, 37.510760), 4326), NOW()-INTERVAL '39 days', NOW()-INTERVAL '39 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='1mWdTewIgB3gtBM3TOSFhB'), (SELECT id FROM places WHERE place_name='석촌호수'), '석촌호수 한 바퀴 돌면서 BTS Butter', 37.510760, 127.099430, ST_SetSRID(ST_MakePoint(127.099430, 37.510760), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='6VObnIkLVruX4UVyxWhlqm'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '123층 전망대에서 Skyfall 들으면 진짜 스카이폴', 37.512460, 127.102470, ST_SetSRID(ST_MakePoint(127.102470, 37.512460), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0V3wPSX9ygBnCm8psDIegu'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '스카이워크에서 Taylor Swift Anti-Hero', 37.512460, 127.102470, ST_SetSRID(ST_MakePoint(127.102470, 37.512460), 4326), NOW()-INTERVAL '7 days', NOW()-INTERVAL '7 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='3AOf6YEpxQ894FmrwI9k96'), (SELECT id FROM places WHERE place_name='올림픽공원'), '올림픽공원 산책에 세븐틴 Super로 에너지 충전', 37.520800, 127.121700, ST_SetSRID(ST_MakePoint(127.121700, 37.520800), 4326), NOW()-INTERVAL '33 days', NOW()-INTERVAL '33 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='72IwoG8tqvIWV10IHjpNNA'), (SELECT id FROM places WHERE place_name='잠실야구장'), '야구 응원에 Dynamite! 홈런 나올듯', 37.512200, 127.071500, ST_SetSRID(ST_MakePoint(127.071500, 37.512200), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='4iJyoBOLtHqaGxP12qzhQI'), (SELECT id FROM places WHERE place_name='방이동 먹자골목'), '방이동 맛집 탐방에 Peaches 달콤하게', 37.514200, 127.116700, ST_SetSRID(ST_MakePoint(127.116700, 37.514200), 4326), NOW()-INTERVAL '23 days', NOW()-INTERVAL '23 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='40riOy7x9W7GXjyGp4pjAv'), (SELECT id FROM places WHERE place_name='잠실한강공원'), '잠실 한강에서 Hotel California 선셋', 37.519300, 127.080600, ST_SetSRID(ST_MakePoint(127.080600, 37.519300), 4326), NOW()-INTERVAL '18 days', NOW()-INTERVAL '18 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='0pYacDCZuRhcrwGUA5nTBe'), (SELECT id FROM places WHERE place_name='송리단길'), '송리단길 카페투어에 IU Eight', 37.509300, 127.098200, ST_SetSRID(ST_MakePoint(127.098200, 37.509300), 4326), NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'),

-- ─── 강동구 (4) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='6bvZRLLkBKkmgpBJTTj3QK'), (SELECT id FROM places WHERE place_name='천호역 로데오거리'), '천호 쇼핑거리에서 블핑으로 텐션업', 37.538500, 127.123400, ST_SetSRID(ST_MakePoint(127.123400, 37.538500), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='7o9uu2GDtVDr9nsR7ZRN73'), (SELECT id FROM places WHERE place_name='암사동 유적지'), '선사시대 유적에서 Time After Time 시공간 초월', 37.551600, 127.131200, ST_SetSRID(ST_MakePoint(127.131200, 37.551600), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='6EJiVf7U0p1BBfs0qqeb1f'), (SELECT id FROM places WHERE place_name='강동 그린웨이'), '그린웨이 자전거 타면서 Cut to the Feeling', 37.545800, 127.143500, ST_SetSRID(ST_MakePoint(127.143500, 37.545800), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='7FXj7Qg3YorUxdrzvrcY25'), (SELECT id FROM places WHERE place_name='광나루한강공원'), '한강 따라 재즈 산책 Fly Me to the Moon', 37.541200, 127.100500, ST_SetSRID(ST_MakePoint(127.100500, 37.541200), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),

-- ─── 추가 인기 스팟 다중 추천 (14) ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='3z8h0TU7ReDPLIbEnYhWZb'), (SELECT id FROM places WHERE place_name='광화문광장'), '광화문에서 퀸 보헤미안 랩소디 웅장함', 37.572280, 126.976890, ST_SetSRID(ST_MakePoint(126.976890, 37.572280), 4326), NOW()-INTERVAL '18 days', NOW()-INTERVAL '18 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='4g6XOg9rvB55GCTJcYchOG'), (SELECT id FROM places WHERE place_name='DDP 동대문디자인플라자'), 'DDP 미디어 파사드 보면서 창모 METEOR', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW()-INTERVAL '12 days', NOW()-INTERVAL '12 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='39LLxExYz6ewLAcYrzQQyP'), (SELECT id FROM places WHERE place_name='명동거리'), '명동에서 Dua Lipa Levitating 쇼핑BGM', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='1mWdTewIgB3gtBM3TOSFhB'), (SELECT id FROM places WHERE place_name='망원한강공원'), '망원 한강 피크닉에 BTS Butter', 37.551930, 126.895230, ST_SetSRID(ST_MakePoint(126.895230, 37.551930), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='69WpV0U7OMNFGyq8I63dcC'), (SELECT id FROM places WHERE place_name='합정역 카페거리'), '합정 카페에서 ENHYPEN Given-Taken 달달하게', 37.549460, 126.913580, ST_SetSRID(ST_MakePoint(126.913580, 37.549460), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='003vvx7Niy0yvhvHt4a68B'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 클럽거리에서 Mr. Brightside 터질듯', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='5c58c6sKc2JK3o75ZBSeL1'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역에서 Gangnam Style 레전드', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='3z8h0TU7ReDPLIbEnYhWZb'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 메가박스에서 Bohemian Rhapsody 영화 후', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='3P3UA61WRQqwCXaoFOTENd'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 사슴 보면서 IU 밤편지 감성', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='6bvZRLLkBKkmgpBJTTj3QK'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원에서 BLACKPINK How You Like That', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='2xLMifQCjDGFmkHkpNLD9h'), (SELECT id FROM places WHERE place_name='한남동 카페거리'), '한남동 밤거리에서 Travis Scott SICKO MODE', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='0ObcVIFoDdBBClvABfJvdz'), (SELECT id FROM places WHERE place_name='올림픽공원'), '올림픽공원 콘서트 갈 때 Stray Kids MANIAC 예열', 37.520800, 127.121700, ST_SetSRID(ST_MakePoint(127.121700, 37.520800), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='0a4MMyCrzT0En247IhqZbD'), (SELECT id FROM places WHERE place_name='잠실야구장'), '야구장에서 뉴진스 Hype Boy로 응원', 37.512200, 127.071500, ST_SetSRID(ST_MakePoint(127.071500, 37.512200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='40riOy7x9W7GXjyGp4pjAv'), (SELECT id FROM places WHERE place_name='잠실한강공원'), '잠실 한강 노을에 Hotel California', 37.519300, 127.080600, ST_SetSRID(ST_MakePoint(127.080600, 37.519300), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- ========================================
-- 7. Recommendation Likes (대규모 반응)
-- ========================================
-- 랜덤하게 다양한 이모지 반응 생성

-- 경복궁 Dynamite
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='궁궐을 걸으며 듣기 좋은 신나는 곡!' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='궁궐을 걸으며 듣기 좋은 신나는 곡!' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👍', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='궁궐을 걸으며 듣기 좋은 신나는 곡!' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='궁궐을 걸으며 듣기 좋은 신나는 곡!' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- N서울타워 Blinding Lights
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야경을 보며 듣는 The Weeknd 최고!' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😍', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야경을 보며 듣는 The Weeknd 최고!' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야경을 보며 듣는 The Weeknd 최고!' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 홍대 Gangnam Style
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 춤추고 싶어지는 곡!' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 춤추고 싶어지는 곡!' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😎', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 춤추고 싶어지는 곡!' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 성수동 Hype Boy
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☕', NOW()-INTERVAL '30 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수동 핫플에서 Hype Boy 텐션 업!' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '29 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수동 핫플에서 Hype Boy 텐션 업!' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '28 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수동 핫플에서 Hype Boy 텐션 업!' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 여의도 Shape of You
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🚴', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 자전거 + Shape of You = 운동 완벽 BGM' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 자전거 + Shape of You = 운동 완벽 BGM' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 자전거 + Shape of You = 운동 완벽 BGM' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 코엑스 Hype Boy
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '✨', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당에서 Hype Boy 들으면 분위기 UP' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당에서 Hype Boy 들으면 분위기 UP' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '39 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당에서 Hype Boy 들으면 분위기 UP' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- DDP LOVE DIVE
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '34 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 야경 + LOVE DIVE = 완벽 조합' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '33 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 야경 + LOVE DIVE = 완벽 조합' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- 블루보틀 Heat Waves
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☕', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커피 마시며 듣는 감성 인디 음악' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커피 마시며 듣는 감성 인디 음악' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커피 마시며 듣는 감성 인디 음악' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 석촌호수 Ditto
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌸', NOW()-INTERVAL '37 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃놀이에 뉴진스 Ditto' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '36 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃놀이에 뉴진스 Ditto' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '35 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃놀이에 뉴진스 Ditto' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 롯데월드타워 Skyfall
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😂', NOW()-INTERVAL '33 days' FROM recommendations r CROSS JOIN users u WHERE r.message='123층 전망대에서 Skyfall 들으면 진짜 스카이폴' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '32 days' FROM recommendations r CROSS JOIN users u WHERE r.message='123층 전망대에서 Skyfall 들으면 진짜 스카이폴' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '31 days' FROM recommendations r CROSS JOIN users u WHERE r.message='123층 전망대에서 Skyfall 들으면 진짜 스카이폴' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 서울숲 새소년
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌳', NOW()-INTERVAL '37 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 산책에 새소년 노래 최고' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '36 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 산책에 새소년 노래 최고' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 강남역 Gangnam Style
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😎', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역에서 Gangnam Style 레전드' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역에서 Gangnam Style 레전드' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역에서 Gangnam Style 레전드' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역에서 Gangnam Style 레전드' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👑', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역에서 Gangnam Style 레전드' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- 잠실야구장 Dynamite
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚾', NOW()-INTERVAL '26 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원에 Dynamite! 홈런 나올듯' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '25 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원에 Dynamite! 홈런 나올듯' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '24 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원에 Dynamite! 홈런 나올듯' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 이태원 Mr. Brightside
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원의 밤 분위기와 딱!' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원의 밤 분위기와 딱!' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 세빛섬 Blinding Lights
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='세빛섬 야경에 Blinding Lights 완벽' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='세빛섬 야경에 Blinding Lights 완벽' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='세빛섬 야경에 Blinding Lights 완벽' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 힙지로 DPR LIVE
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '31 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 감성에 DPR LIVE 찰떡!' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '30 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 감성에 DPR LIVE 찰떡!' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 명동 블핑
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🖤', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 쇼핑하면서 블핑 How You Like That' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💖', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 쇼핑하면서 블핑 How You Like That' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 쇼핑하면서 블핑 How You Like That' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 한남동 DPR LIVE
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '✨', NOW()-INTERVAL '35 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동 카페에서 DPR LIVE' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '34 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동 카페에서 DPR LIVE' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 예술의전당 카논
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '26 days' FROM recommendations r CROSS JOIN users u WHERE r.message='예술의전당 앞 광장에서 카논 라이브 뺨치게' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎶', NOW()-INTERVAL '25 days' FROM recommendations r CROSS JOIN users u WHERE r.message='예술의전당 앞 광장에서 카논 라이브 뺨치게' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- 서울대 Celebrity
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎓', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='캠퍼스를 걸으며 듣는 IU Celebrity' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='캠퍼스를 걸으며 듣는 IU Celebrity' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='캠퍼스를 걸으며 듣는 IU Celebrity' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 선유도 IU 밤편지
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌅', NOW()-INTERVAL '32 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 IU 밤편지 들으면 감성 터짐' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '31 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 IU 밤편지 들으면 감성 터짐' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '30 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 IU 밤편지 들으면 감성 터짐' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 도봉산 Super
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '26 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도봉산 오르면서 세븐틴 Super 들으면 힘남!' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏔️', NOW()-INTERVAL '25 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도봉산 오르면서 세븐틴 Super 들으면 힘남!' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 북한산 Wonderwall
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏔️', NOW()-INTERVAL '28 days' FROM recommendations r CROSS JOIN users u WHERE r.message='등산하면서 Wonderwall 따라 부르기' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '27 days' FROM recommendations r CROSS JOIN users u WHERE r.message='등산하면서 Wonderwall 따라 부르기' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 항동철길 Creep
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📸', NOW()-INTERVAL '8 days' FROM recommendations r CROSS JOIN users u WHERE r.message='폐철길 감성에 Radiohead Creep 완벽 매칭' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='폐철길 감성에 Radiohead Creep 완벽 매칭' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;

-- 건대 Queencard
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💅', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='건대 커먼그라운드에서 Queencard 파워워킹' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👑', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='건대 커먼그라운드에서 Queencard 파워워킹' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 홍대 Queencard
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👑', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대에서 Queencard 들으면 자신감 MAX' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대에서 Queencard 들으면 자신감 MAX' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💅', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대에서 Queencard 들으면 자신감 MAX' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- 올림픽공원 MANIAC
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원 콘서트 갈 때 Stray Kids MANIAC 예열' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원 콘서트 갈 때 Stray Kids MANIAC 예열' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;

-- 63빌딩 Skyfall
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😂', NOW()-INTERVAL '20 days' FROM recommendations r CROSS JOIN users u WHERE r.message='63빌딩 전망대에서 Skyfall 들으면 제임스본드' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '19 days' FROM recommendations r CROSS JOIN users u WHERE r.message='63빌딩 전망대에서 Skyfall 들으면 제임스본드' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 경의선숲길 Fly Me to the Moon
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌙', NOW()-INTERVAL '31 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길 산책에 Fly Me to the Moon' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '30 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길 산책에 Fly Me to the Moon' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 연트럴파크 Hype Boy
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 Hype Boy 산책' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🚶', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 Hype Boy 산책' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 Hype Boy 산책' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- 광화문 Bohemian Rhapsody
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👍', NOW()-INTERVAL '16 days' FROM recommendations r CROSS JOIN users u WHERE r.message='광화문에서 퀸 보헤미안 랩소디 웅장함' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '15 days' FROM recommendations r CROSS JOIN users u WHERE r.message='광화문에서 퀸 보헤미안 랩소디 웅장함' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- 망원한강공원 Butter
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🧈', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='망원 한강 피크닉에 BTS Butter' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='망원 한강 피크닉에 BTS Butter' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 코엑스 Bohemian Rhapsody
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎬', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 메가박스에서 Bohemian Rhapsody 영화 후' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 메가박스에서 Bohemian Rhapsody 영화 후' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 서울숲 IU 밤편지
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🦌', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 사슴 보면서 IU 밤편지 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 사슴 보면서 IU 밤편지 감성' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 수제화거리 IU 밤편지
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👟', NOW()-INTERVAL '23 days' FROM recommendations r CROSS JOIN users u WHERE r.message='수제화거리 장인의 손길 느끼며 IU 밤편지' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '22 days' FROM recommendations r CROSS JOIN users u WHERE r.message='수제화거리 장인의 손길 느끼며 IU 밤편지' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '21 days' FROM recommendations r CROSS JOIN users u WHERE r.message='수제화거리 장인의 손길 느끼며 IU 밤편지' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 수제화거리 재즈
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎷', NOW()-INTERVAL '18 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가죽 냄새와 재즈의 조합이 이렇게 잘 어울리다니' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '17 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가죽 냄새와 재즈의 조합이 이렇게 잘 어울리다니' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '✨', NOW()-INTERVAL '16 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가죽 냄새와 재즈의 조합이 이렇게 잘 어울리다니' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 수제화거리 DPR LIVE
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '13 days' FROM recommendations r CROSS JOIN users u WHERE r.message='수제화 구경하면서 DPR LIVE 감성 뿜뿜' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '12 days' FROM recommendations r CROSS JOIN users u WHERE r.message='수제화 구경하면서 DPR LIVE 감성 뿜뿜' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- 수제화거리 As It Was
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👞', NOW()-INTERVAL '8 days' FROM recommendations r CROSS JOIN users u WHERE r.message='깔끔한 수제화 매장 앞에서 As It Was 딱' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='깔끔한 수제화 매장 앞에서 As It Was 딱' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='깔끔한 수제화 매장 앞에서 As It Was 딱' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 대림창고 Take Five
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎨', NOW()-INTERVAL '24 days' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 전시 보면서 Take Five 재즈 감상' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '23 days' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 전시 보면서 Take Five 재즈 감상' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 대림창고 Creep
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏭', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 인더스트리얼 감성에 Creep 찰떡' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 인더스트리얼 감성에 Creep 찰떡' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 성수연방 drivers license
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏙️', NOW()-INTERVAL '21 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수연방 루프탑에서 drivers license 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '20 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수연방 루프탑에서 drivers license 감성' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '19 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수연방 루프탑에서 drivers license 감성' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;

-- 어니언 River Flows in You
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🍞', NOW()-INTERVAL '19 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵 냄새와 이루마 피아노의 힐링 조합' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '18 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵 냄새와 이루마 피아노의 힐링 조합' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☕', NOW()-INTERVAL '17 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵 냄새와 이루마 피아노의 힐링 조합' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '16 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵 냄새와 이루마 피아노의 힐링 조합' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 어니언 Anti-Hero
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📸', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 2층 창가에서 Anti-Hero 들으면 주인공 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 2층 창가에서 Anti-Hero 들으면 주인공 느낌' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 2층 창가에서 Anti-Hero 들으면 주인공 느낌' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;

-- 할아버지공장 METEOR
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔧', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='할아버지공장에서 창모 METEOR 들으며 작업' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='할아버지공장에서 창모 METEOR 들으며 작업' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='할아버지공장에서 창모 METEOR 들으며 작업' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 뚝도시장 SICKO MODE
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😂', NOW()-INTERVAL '14 days' FROM recommendations r CROSS JOIN users u WHERE r.message='뚝도시장 로컬 감성에 SICKO MODE 묘한 조합' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '13 days' FROM recommendations r CROSS JOIN users u WHERE r.message='뚝도시장 로컬 감성에 SICKO MODE 묘한 조합' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- 갤러리아포레 Levitating
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🚶', NOW()-INTERVAL '17 days' FROM recommendations r CROSS JOIN users u WHERE r.message='갤러리아포레 산책길에 Levitating 기분 좋음' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '16 days' FROM recommendations r CROSS JOIN users u WHERE r.message='갤러리아포레 산책길에 Levitating 기분 좋음' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
