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


-- ================================================================
-- ================================================================
--   EXPANSION BLOCK: Additional Genre Data + 40 New Tracks
--   + 80 New Recommendations + Likes
-- ================================================================
-- ================================================================

-- ========================================
-- 8. Update existing tracks with genres
-- ========================================
UPDATE tracks SET genres = ARRAY['K-Pop'] WHERE spotify_track_id IN (
    '72IwoG8tqvIWV10IHjpNNA', '1mWdTewIgB3gtBM3TOSFhB', '5c58c6sKc2JK3o75ZBSeL1',
    '4RewTiGEGoO7FWNZUmp1f4', '6bvZRLLkBKkmgpBJTTj3QK', '0a4MMyCrzT0En247IhqZbD',
    '0Q5VnK2DYzRyfqQRJuUtvi', '4fsQ0K37TOXa3hEQfjEic1', '68r87x3VZdAMhv8nBVuynz',
    '0ObcVIFoDdBBClvABfJvdz', '3AOf6YEpxQ894FmrwI9k96', '3r8RuvgbX9s7ammBn07D3W',
    '69WpV0U7OMNFGyq8I63dcC'
);
UPDATE tracks SET genres = ARRAY['K-Pop', 'K-Ballad'] WHERE spotify_track_id IN ('3P3UA61WRQqwCXaoFOTENd', '0pYacDCZuRhcrwGUA5nTBe');
UPDATE tracks SET genres = ARRAY['K-Indie', 'K-Rock'] WHERE spotify_track_id = '4TBHfv2isYco3fNKjQ8oSI';
UPDATE tracks SET genres = ARRAY['K-R&B', 'K-Hip-Hop'] WHERE spotify_track_id IN ('2IgbYlOlFpiSFYnsqB39lM', '4g6XOg9rvB55GCTJcYchOG');
UPDATE tracks SET genres = ARRAY['Pop', 'R&B'] WHERE spotify_track_id = '0VjIjW4GlUZAMYd2vXMi3b';
UPDATE tracks SET genres = ARRAY['Pop'] WHERE spotify_track_id IN (
    '7qiZfU4dY1lWllzX7mPBI3', '7qEHsqek33rTcFNT9PFqLf', '39LLxExYz6ewLAcYrzQQyP',
    '4Dvkj6JhhA12EX05fT7y2e', '5wANPM4fQCJwkGd4rN57mH', '0V3wPSX9ygBnCm8psDIegu',
    '3USxtqRwSYz57Ewm6wWRMp', '6EJiVf7U0p1BBfs0qqeb1f'
);
UPDATE tracks SET genres = ARRAY['Rock', 'Indie'] WHERE spotify_track_id = '003vvx7Niy0yvhvHt4a68B';
UPDATE tracks SET genres = ARRAY['Pop', 'Synthpop'] WHERE spotify_track_id = '7o9uu2GDtVDr9nsR7ZRN73';
UPDATE tracks SET genres = ARRAY['Pop', 'Soul'] WHERE spotify_track_id = '6VObnIkLVruX4UVyxWhlqm';
UPDATE tracks SET genres = ARRAY['Hip-Hop', 'Trap'] WHERE spotify_track_id = '2xLMifQCjDGFmkHkpNLD9h';
UPDATE tracks SET genres = ARRAY['Hip-Hop', 'Rap'] WHERE spotify_track_id = '7MJQ9Nfxzh8LPZ9e9u68Fq';
UPDATE tracks SET genres = ARRAY['Pop', 'R&B'] WHERE spotify_track_id = '4iJyoBOLtHqaGxP12qzhQI';
UPDATE tracks SET genres = ARRAY['Jazz', 'Vocal Jazz'] WHERE spotify_track_id = '7FXj7Qg3YorUxdrzvrcY25';
UPDATE tracks SET genres = ARRAY['Jazz', 'Cool Jazz'] WHERE spotify_track_id = '1YQWosTIljIvxAgHWTp7KP';
UPDATE tracks SET genres = ARRAY['Classical', 'Piano'] WHERE spotify_track_id = '2agBDIr9MYDUducQPC1sFU';
UPDATE tracks SET genres = ARRAY['Classical', 'Baroque'] WHERE spotify_track_id = '1c3GkbZBnyrQ1cm4TGHFrK';
UPDATE tracks SET genres = ARRAY['Rock', 'Classic Rock'] WHERE spotify_track_id IN ('3z8h0TU7ReDPLIbEnYhWZb', '40riOy7x9W7GXjyGp4pjAv');
UPDATE tracks SET genres = ARRAY['Rock', 'Britpop'] WHERE spotify_track_id = '41tTCXOzxSWAoVrfeIIh8x';
UPDATE tracks SET genres = ARRAY['Rock', 'Alternative'] WHERE spotify_track_id = '70LcF31zb1H0PyJoS1Sx1r';

-- ========================================
-- 9. Additional Tracks (40 new tracks with real Spotify data)
-- ========================================
INSERT INTO tracks (spotify_track_id, title, artist, album, album_cover_url, track_url, preview_url, genres, created_at, updated_at) VALUES
-- ─── K-Pop (8) ───
('2zrhoHlFKxFTRF5XEAoulP', 'Next Level', 'aespa', 'Next Level', 'https://i.scdn.co/image/ab67616d0000b273c3040848e6ef0e132c5c8340', 'https://open.spotify.com/track/2zrhoHlFKxFTRF5XEAoulP', NULL, '{K-Pop}', NOW(), NOW()),
('7FbrGaHYVDmfr7KoLIZnQ7', 'Cupid (Twin Ver.)', 'FIFTY FIFTY', 'The Beginning: Cupid', 'https://i.scdn.co/image/ab67616d0000b2737e1eeb0d5986e4107adc78c9', 'https://open.spotify.com/track/7FbrGaHYVDmfr7KoLIZnQ7', NULL, '{K-Pop}', NOW(), NOW()),
('6kL4AqU2qdEIXuFCQ10tqM', 'The Feels', 'TWICE', 'Formula of Love: O+T=<3', 'https://i.scdn.co/image/ab67616d0000b2739f456d7e24fe0e4bb7b30879', 'https://open.spotify.com/track/6kL4AqU2qdEIXuFCQ10tqM', NULL, '{K-Pop}', NOW(), NOW()),
('0It6VJoMAare1sdHhQWAN8', 'Love Shot', 'EXO', 'LOVE SHOT - The 5th Album Repackage', 'https://i.scdn.co/image/ab67616d0000b2731214a535b3b984094a8d2d71', 'https://open.spotify.com/track/0It6VJoMAare1sdHhQWAN8', NULL, '{K-Pop}', NOW(), NOW()),
('0lIzj9bwmhiCSOZQMhb3LH', 'Psycho', 'Red Velvet', 'The ReVe Festival Finale', 'https://i.scdn.co/image/ab67616d0000b273e5a366df8e520e30a7a95c4d', 'https://open.spotify.com/track/0lIzj9bwmhiCSOZQMhb3LH', NULL, '{K-Pop,"K-R&B"}', NOW(), NOW()),
('6FBNMJFjexyBfFaEaMNRRs', 'Sugar Rush Ride', 'TOMORROW X TOGETHER', 'The Name Chapter: TEMPTATION', 'https://i.scdn.co/image/ab67616d0000b27356eda7c0e36c2cee95e86667', 'https://open.spotify.com/track/6FBNMJFjexyBfFaEaMNRRs', NULL, '{K-Pop}', NOW(), NOW()),
('5M70hy7bM7gMTKhb6mXOOe', 'Guerrilla', 'ATEEZ', 'THE WORLD EP.1 : MOVEMENT', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd2e495d0060ea430aa', 'https://open.spotify.com/track/5M70hy7bM7gMTKhb6mXOOe', NULL, '{K-Pop}', NOW(), NOW()),
('3Ua0m0YmEjrMi9XErKcNiR', 'TOMBOY', '(G)I-DLE', 'I NEVER DIE', 'https://i.scdn.co/image/ab67616d0000b2738a07e645c3105b5fca0b3ec4', 'https://open.spotify.com/track/3Ua0m0YmEjrMi9XErKcNiR', NULL, '{K-Pop}', NOW(), NOW()),
-- ─── K-R&B / K-Hip-Hop / K-Indie (8) ───
('6n8Wk7vaBmQtGGCgirrgY8', 'Phonecert (폰서트)', '10cm', 'The 3rd EP', 'https://i.scdn.co/image/ab67616d0000b2735c8d09bf43e2e6509bc03e08', 'https://open.spotify.com/track/6n8Wk7vaBmQtGGCgirrgY8', NULL, '{K-Indie,K-Pop}', NOW(), NOW()),
('4dGJf5P2DYPq8Zxgz1XnVp', 'Beautiful', 'Crush', 'Guardian (Goblin) OST', 'https://i.scdn.co/image/ab67616d0000b2733aed4e5b01efbf891810a828', 'https://open.spotify.com/track/4dGJf5P2DYPq8Zxgz1XnVp', NULL, '{"K-R&B",OST}', NOW(), NOW()),
('5r8BNlPXr8VjAXVEb3Rm6n', 'instagram', 'DEAN', '130 mood : TRBL', 'https://i.scdn.co/image/ab67616d0000b27399e3089abc4c0fc95a627732', 'https://open.spotify.com/track/5r8BNlPXr8VjAXVEb3Rm6n', NULL, '{"K-R&B"}', NOW(), NOW()),
('4SLaUXPNB1EVddOQAmhnKO', 'You, Clouds, Rain (비도 오고 그래서)', 'Heize', '/// (너 먹구름 비)', 'https://i.scdn.co/image/ab67616d0000b273c8bfab9e5be9a8fba3798530', 'https://open.spotify.com/track/4SLaUXPNB1EVddOQAmhnKO', NULL, '{"K-R&B",K-Pop}', NOW(), NOW()),
('4PQLAV3O3RMsmNZ3iAYB9D', '200%', 'AKMU', 'PLAY', 'https://i.scdn.co/image/ab67616d0000b27360e7daefb0d02c34ee20e921', 'https://open.spotify.com/track/4PQLAV3O3RMsmNZ3iAYB9D', NULL, '{K-Pop,K-Indie}', NOW(), NOW()),
('2lVk3lmUsBYYxChYnQ5lA7', 'Travel (여행)', '볼빨간사춘기 (BOL4)', 'Two Five', 'https://i.scdn.co/image/ab67616d0000b273e20e357a9b56e1b5b4c3d4c2', 'https://open.spotify.com/track/2lVk3lmUsBYYxChYnQ5lA7', NULL, '{K-Indie,K-Pop}', NOW(), NOW()),
('6HMLFrHl77GoxCXJWq3MFz', 'MOMMAE (몸매) (feat. Ugly Duck)', 'Jay Park', 'Worldwide', 'https://i.scdn.co/image/ab67616d0000b273d12c1e5bbf57b8e91741f786', 'https://open.spotify.com/track/6HMLFrHl77GoxCXJWq3MFz', NULL, '{"K-Hip-Hop","K-R&B"}', NOW(), NOW()),
('7Fy53RtgsGW0wQKlGgPSIZ', 'Yanghwa BRDG (양화대교)', 'Zion.T', 'OO', 'https://i.scdn.co/image/ab67616d0000b273d53c5c389de4c74e8b7e4fb8', 'https://open.spotify.com/track/7Fy53RtgsGW0wQKlGgPSIZ', NULL, '{"K-R&B",K-Hip-Hop}', NOW(), NOW()),
-- ─── Western Pop (8) ───
('2Fxmhks0bxGSBdJ92vM42m', 'bad guy', 'Billie Eilish', 'WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?', 'https://i.scdn.co/image/ab67616d0000b27350a3147b4edd7701a876c6ce', 'https://open.spotify.com/track/2Fxmhks0bxGSBdJ92vM42m', NULL, '{Pop,Electropop}', NOW(), NOW()),
('0pqnGHJpmpxLKifKRmU0WP', 'Believer', 'Imagine Dragons', 'Evolve', 'https://i.scdn.co/image/ab67616d0000b2735675e83f707f1d7271e5cf8a', 'https://open.spotify.com/track/0pqnGHJpmpxLKifKRmU0WP', NULL, '{Rock,Pop}', NOW(), NOW()),
('3AJwUDP919kvQ9QcozQPxg', 'Yellow', 'Coldplay', 'Parachutes', 'https://i.scdn.co/image/ab67616d0000b2739164bafe9adc0a3990584832', 'https://open.spotify.com/track/3AJwUDP919kvQ9QcozQPxg', NULL, '{Rock,Alternative}', NOW(), NOW()),
('6b8Be6ljOzmkOmFslEb23P', '24K Magic', 'Bruno Mars', '24K Magic', 'https://i.scdn.co/image/ab67616d0000b273232711f7d2fabb4ec8b6e036', 'https://open.spotify.com/track/6b8Be6ljOzmkOmFslEb23P', NULL, '{Pop,Funk}', NOW(), NOW()),
('0SiywuOBRcynK0uKGWdCnn', 'Bad Romance', 'Lady Gaga', 'The Fame Monster (Deluxe)', 'https://i.scdn.co/image/ab67616d0000b273424e7db45cb60eb9fa1bcdfc', 'https://open.spotify.com/track/0SiywuOBRcynK0uKGWdCnn', NULL, '{Pop,Dance}', NOW(), NOW()),
('6ocbgoVGwYJhOv1GgI9NsC', '7 rings', 'Ariana Grande', 'thank u, next', 'https://i.scdn.co/image/ab67616d0000b2736c3be3b0e67b4f803cdb6dbc', 'https://open.spotify.com/track/6ocbgoVGwYJhOv1GgI9NsC', NULL, '{Pop,Trap}', NOW(), NOW()),
('21jGcNKet2qwijlDFuPiPb', 'Circles', 'Post Malone', 'Hollywood''s Bleeding', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'https://open.spotify.com/track/21jGcNKet2qwijlDFuPiPb', NULL, '{Pop,Rock}', NOW(), NOW()),
('3PfIrDoz19wz7qK7tYeu7w', 'Don''t Start Now', 'Dua Lipa', 'Future Nostalgia', 'https://i.scdn.co/image/ab67616d0000b273c88bae7846e62a8ba59ee0bd', 'https://open.spotify.com/track/3PfIrDoz19wz7qK7tYeu7w', NULL, '{Pop,Disco}', NOW(), NOW()),
-- ─── Hip-Hop / Rap (4) ───
('7KXjTSCq5nL1LoYtL7XAwS', 'HUMBLE.', 'Kendrick Lamar', 'DAMN.', 'https://i.scdn.co/image/ab67616d0000b2738b52c6b9bc4e43d873869699', 'https://open.spotify.com/track/7KXjTSCq5nL1LoYtL7XAwS', NULL, '{"Hip-Hop",Rap}', NOW(), NOW()),
('0kL3TYRsSXnu0iJvFO3rit', 'Hotline Bling', 'Drake', 'Views', 'https://i.scdn.co/image/ab67616d0000b273f16ab998b8f59f6e1e18eb27', 'https://open.spotify.com/track/0kL3TYRsSXnu0iJvFO3rit', NULL, '{"Hip-Hop",Pop}', NOW(), NOW()),
('4fzsfWzRhPawzqhX8Qt9F3', 'Stronger', 'Kanye West', 'Graduation', 'https://i.scdn.co/image/ab67616d0000b273cd1f1118aa5de7c07a3ad8cc', 'https://open.spotify.com/track/4fzsfWzRhPawzqhX8Qt9F3', NULL, '{"Hip-Hop",Electronic}', NOW(), NOW()),
('7lQ8MOhq6IN2w8EYcFNSUk', 'Without Me', 'Eminem', 'The Eminem Show', 'https://i.scdn.co/image/ab67616d0000b2736ca5c90113b30c3c43ffb8f4', 'https://open.spotify.com/track/7lQ8MOhq6IN2w8EYcFNSUk', NULL, '{"Hip-Hop",Rap}', NOW(), NOW()),
-- ─── Electronic / Dance (4) ───
('0nrRP2bk19rLc0NV8nRBOE', 'Wake Me Up', 'Avicii', 'True', 'https://i.scdn.co/image/ab67616d0000b2e37e4e98f6c1c2c06bb8a2de06', 'https://open.spotify.com/track/0nrRP2bk19rLc0NV8nRBOE', NULL, '{EDM,Dance}', NOW(), NOW()),
('2Foc5Q5nqNiosCNqttzHof', 'Get Lucky (feat. Pharrell Williams & Nile Rodgers)', 'Daft Punk', 'Random Access Memories', 'https://i.scdn.co/image/ab67616d0000b2739b9b36b0e22870b9f542d937', 'https://open.spotify.com/track/2Foc5Q5nqNiosCNqttzHof', NULL, '{Disco,Electronic}', NOW(), NOW()),
('7BKLCZ1jbUBVqRi2FVlTVw', 'Closer', 'The Chainsmokers, Halsey', 'Closer', 'https://i.scdn.co/image/ab67616d0000b2739aa289e10d011baf078d964b', 'https://open.spotify.com/track/7BKLCZ1jbUBVqRi2FVlTVw', NULL, '{EDM,Pop}', NOW(), NOW()),
('2dpaYNEQHiRxtZbfNsse99', 'Happier', 'Marshmello, Bastille', 'Happier', 'https://i.scdn.co/image/ab67616d0000b2730e7e25c0f9a66e9316429bd5', 'https://open.spotify.com/track/2dpaYNEQHiRxtZbfNsse99', NULL, '{EDM,Pop}', NOW(), NOW()),
-- ─── Rock / Alternative (4) ───
('5ghIJDpPoe3CfHMGu71E6T', 'Smells Like Teen Spirit', 'Nirvana', 'Nevermind', 'https://i.scdn.co/image/ab67616d0000b2739e4e1b6eb0aa2ec6e4a4ad24', 'https://open.spotify.com/track/5ghIJDpPoe3CfHMGu71E6T', NULL, '{Rock,Grunge}', NOW(), NOW()),
('60a0Rd6pjrkxjPbaKzXjfq', 'In The End', 'Linkin Park', 'Hybrid Theory', 'https://i.scdn.co/image/ab67616d0000b273e2f039481babe23658fc719a', 'https://open.spotify.com/track/60a0Rd6pjrkxjPbaKzXjfq', NULL, '{Rock,"Nu Metal"}', NOW(), NOW()),
('6lgczhmJUHKJbFiB2iFerF', 'Basket Case', 'Green Day', 'Dookie', 'https://i.scdn.co/image/ab67616d0000b273b2b2747c89d2157b5131e5b6', 'https://open.spotify.com/track/6lgczhmJUHKJbFiB2iFerF', NULL, '{Punk,Rock}', NOW(), NOW()),
('5FVd6KXrgO9B3JPmGrhqHb', 'Do I Wanna Know?', 'Arctic Monkeys', 'AM', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'https://open.spotify.com/track/5FVd6KXrgO9B3JPmGrhqHb', NULL, '{Rock,Indie}', NOW(), NOW()),
-- ─── R&B / Soul (4) ───
('7DfFc7a3mEsPTaLBCfNJRK', 'Thinkin Bout You', 'Frank Ocean', 'channel ORANGE', 'https://i.scdn.co/image/ab67616d0000b273c66cc282eab3565ac79cfecb', 'https://open.spotify.com/track/7DfFc7a3mEsPTaLBCfNJRK', NULL, '{"R&B",Soul}', NOW(), NOW()),
('1Qrg8KqiBpW07V7PNxwwwL', 'Kill Bill', 'SZA', 'SOS', 'https://i.scdn.co/image/ab67616d0000b27370dbc9f47669d120ad874ec1', 'https://open.spotify.com/track/1Qrg8KqiBpW07V7PNxwwwL', NULL, '{"R&B",Pop}', NOW(), NOW()),
('5QO79kh1waicV47BqGRL3g', 'Save Your Tears', 'The Weeknd', 'After Hours', 'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36', 'https://open.spotify.com/track/5QO79kh1waicV47BqGRL3g', NULL, '{"R&B",Synthpop}', NOW(), NOW()),
('1blficLzeYlqZ9dGROOhCy', 'Best Part (feat. H.E.R.)', 'Daniel Caesar', 'Freudian', 'https://i.scdn.co/image/ab67616d0000b273bc3e6b9b8b6803b3a2ab1e79', 'https://open.spotify.com/track/1blficLzeYlqZ9dGROOhCy', NULL, '{"R&B",Neo-Soul}', NOW(), NOW()),
-- ─── J-Pop / Latin (4) ───
('1ypMnktCB2eTkiPBOk2vCv', 'Idol (アイドル)', 'YOASOBI', 'Idol', 'https://i.scdn.co/image/ab67616d0000b273583c60a10af3d3e48c330860', 'https://open.spotify.com/track/1ypMnktCB2eTkiPBOk2vCv', NULL, '{J-Pop,Anime}', NOW(), NOW()),
('53RF5JR4dVaJapJbweexyH', 'Shinunoga E-Wa', 'Fujii Kaze', 'HELP EVER HURT NEVER', 'https://i.scdn.co/image/ab67616d0000b273e394f2782bcc0e8c1affc437', 'https://open.spotify.com/track/53RF5JR4dVaJapJbweexyH', NULL, '{J-Pop}', NOW(), NOW()),
('1IHWl5LamUGEuP4ozKQSXZ', 'Titi Me Preguntó', 'Bad Bunny', 'Un Verano Sin Ti', 'https://i.scdn.co/image/ab67616d0000b273497edb0f09eccd49ac8e60fb', 'https://open.spotify.com/track/1IHWl5LamUGEuP4ozKQSXZ', NULL, '{Reggaeton,Latin}', NOW(), NOW()),
('6habFhsceSTjwMFa8CqA8A', 'Despacito', 'Luis Fonsi, Daddy Yankee', 'VIDA', 'https://i.scdn.co/image/ab67616d0000b2736b5e65f1eaf4ecfe5ab0e7a0', 'https://open.spotify.com/track/6habFhsceSTjwMFa8CqA8A', NULL, '{Latin,Reggaeton}', NOW(), NOW())
ON CONFLICT (spotify_track_id) DO NOTHING;


-- ========================================
-- 10. Additional Recommendations (서울 전역 - 신규 트랙 활용 80+)
-- ========================================
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at) VALUES
-- ─── 종로구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='2zrhoHlFKxFTRF5XEAoulP'), (SELECT id FROM places WHERE place_name='경복궁'), 'aespa Next Level 들으면 경복궁도 광야 느낌', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW()-INTERVAL '9 days', NOW()-INTERVAL '9 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='4dGJf5P2DYPq8Zxgz1XnVp'), (SELECT id FROM places WHERE place_name='북촌한옥마을'), '한옥마을에서 크러쉬 Beautiful 들으니 도깨비 느낌', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW()-INTERVAL '7 days', NOW()-INTERVAL '7 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7Fy53RtgsGW0wQKlGgPSIZ'), (SELECT id FROM places WHERE place_name='광화문광장'), '광화문에서 양화대교 들으면 서울 감성 제대로', 37.572280, 126.976890, ST_SetSRID(ST_MakePoint(126.976890, 37.572280), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='53RF5JR4dVaJapJbweexyH'), (SELECT id FROM places WHERE place_name='인사동 쌈지길'), '인사동에서 Fujii Kaze 들으니 아시아 감성 믹스', 37.573924, 126.985019, ST_SetSRID(ST_MakePoint(126.985019, 37.573924), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),

-- ─── 중구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='7FbrGaHYVDmfr7KoLIZnQ7'), (SELECT id FROM places WHERE place_name='명동거리'), '명동에서 FIFTY FIFTY Cupid 들으면 사랑에 빠질듯', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0SiywuOBRcynK0uKGWdCnn'), (SELECT id FROM places WHERE place_name='DDP 동대문디자인플라자'), 'DDP 미래적 건물에 Lady Gaga Bad Romance 찰떡', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW()-INTERVAL '7 days', NOW()-INTERVAL '7 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='5r8BNlPXr8VjAXVEb3Rm6n'), (SELECT id FROM places WHERE place_name='을지로3가 힙지로'), '힙지로 노포에서 DEAN instagram 감성 제대로', 37.566010, 126.991350, ST_SetSRID(ST_MakePoint(126.991350, 37.566010), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),

-- ─── 용산구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='5QO79kh1waicV47BqGRL3g'), (SELECT id FROM places WHERE place_name='N서울타워'), '남산타워에서 Save Your Tears 들으며 야경 감상', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='6HMLFrHl77GoxCXJWq3MFz'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원 클럽 분위기에 Jay Park MOMMAE 찰떡', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='1blficLzeYlqZ9dGROOhCy'), (SELECT id FROM places WHERE place_name='한남동 카페거리'), '한남동 분위기에 Daniel Caesar Best Part 감성', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='2Foc5Q5nqNiosCNqttzHof'), (SELECT id FROM places WHERE place_name='경리단길'), '경리단길 밤산책에 Daft Punk Get Lucky 기분 좋음', 37.537300, 126.987450, ST_SetSRID(ST_MakePoint(126.987450, 37.537300), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 성동구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='3Ua0m0YmEjrMi9XErKcNiR'), (SELECT id FROM places WHERE place_name='성수동 카페거리'), '성수 카페에서 (G)I-DLE TOMBOY 들으면 자신감 뿜뿜', 37.544200, 127.055800, ST_SetSRID(ST_MakePoint(127.055800, 37.544200), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='7DfFc7a3mEsPTaLBCfNJRK'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 벤치에서 Frank Ocean Thinkin Bout You 감성', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='4SLaUXPNB1EVddOQAmhnKO'), (SELECT id FROM places WHERE place_name='뚝섬역 벽화골목'), '비 오는 날 벽화골목에서 Heize 비도 오고 그래서', 37.547300, 127.047100, ST_SetSRID(ST_MakePoint(127.047100, 37.547300), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0lIzj9bwmhiCSOZQMhb3LH'), (SELECT id FROM places WHERE place_name='성수 대림창고'), '대림창고 전시에 Red Velvet Psycho 분위기', 37.544100, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.544100), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='3PfIrDoz19wz7qK7tYeu7w'), (SELECT id FROM places WHERE place_name='어니언 성수점'), '어니언에서 Dua Lipa Don''t Start Now 기분 전환', 37.545200, 127.056800, ST_SetSRID(ST_MakePoint(127.056800, 37.545200), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='6FBNMJFjexyBfFaEaMNRRs'), (SELECT id FROM places WHERE place_name='성수연방'), '성수연방에서 TXT Sugar Rush Ride 달달하게', 37.543900, 127.054700, ST_SetSRID(ST_MakePoint(127.054700, 37.543900), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),

-- ─── 광진구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='0It6VJoMAare1sdHhQWAN8'), (SELECT id FROM places WHERE place_name='건대입구 커먼그라운드'), '커먼그라운드에서 EXO Love Shot 들으면 텐션', 37.542470, 127.068100, ST_SetSRID(ST_MakePoint(127.068100, 37.542470), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='뚝섬유원지'), '한강에서 Avicii Wake Me Up 들으면 자유 느낌', 37.531600, 127.066800, ST_SetSRID(ST_MakePoint(127.066800, 37.531600), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='6kL4AqU2qdEIXuFCQ10tqM'), (SELECT id FROM places WHERE place_name='어린이대공원'), '어린이대공원에서 TWICE The Feels 봄나들이', 37.548300, 127.080200, ST_SetSRID(ST_MakePoint(127.080200, 37.548300), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 동대문구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='60a0Rd6pjrkxjPbaKzXjfq'), (SELECT id FROM places WHERE place_name='경희대학교'), '경희대 시험기간 린킨파크 In The End 공감 MAX', 37.597010, 127.051480, ST_SetSRID(ST_MakePoint(127.051480, 37.597010), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='4PQLAV3O3RMsmNZ3iAYB9D'), (SELECT id FROM places WHERE place_name='회기역 먹자골목'), '회기 떡볶이 + AKMU 200% = 행복 200%', 37.589500, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.589500), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 성북구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='3AJwUDP919kvQ9QcozQPxg'), (SELECT id FROM places WHERE place_name='고려대학교'), '고대 가을 캠퍼스에서 Coldplay Yellow 낭만', 37.589610, 127.032400, ST_SetSRID(ST_MakePoint(127.032400, 37.589610), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='2lVk3lmUsBYYxChYnQ5lA7'), (SELECT id FROM places WHERE place_name='길상사'), '길상사에서 볼빨간사춘기 여행 들으며 힐링', 37.600970, 127.006900, ST_SetSRID(ST_MakePoint(127.006900, 37.600970), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),

-- ─── 강북구/도봉구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='0pqnGHJpmpxLKifKRmU0WP'), (SELECT id FROM places WHERE place_name='북한산 우이령길'), '북한산 정상 가면서 Imagine Dragons Believer 파이팅', 37.641580, 127.011900, ST_SetSRID(ST_MakePoint(127.011900, 37.641580), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='5ghIJDpPoe3CfHMGu71E6T'), (SELECT id FROM places WHERE place_name='도봉산역 등산로입구'), '등산길에 Nirvana Smells Like Teen Spirit 에너지', 37.689480, 127.044250, ST_SetSRID(ST_MakePoint(127.044250, 37.689480), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),

-- ─── 노원구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='7BKLCZ1jbUBVqRi2FVlTVw'), (SELECT id FROM places WHERE place_name='서울과학기술대학교'), '과기대 야경에 The Chainsmokers Closer 분위기', 37.632040, 127.077750, ST_SetSRID(ST_MakePoint(127.077750, 37.632040), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 은평구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='6n8Wk7vaBmQtGGCgirrgY8'), (SELECT id FROM places WHERE place_name='은평한옥마을'), '한옥마을에서 10cm 폰서트 들으면 고즈넉 감성', 37.636400, 126.918300, ST_SetSRID(ST_MakePoint(126.918300, 37.636400), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 서대문구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4fzsfWzRhPawzqhX8Qt9F3'), (SELECT id FROM places WHERE place_name='연세대학교'), '연대 공대 밤샘 코딩에 Kanye West Stronger', 37.566536, 126.939370, ST_SetSRID(ST_MakePoint(126.939370, 37.566536), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='1ypMnktCB2eTkiPBOk2vCv'), (SELECT id FROM places WHERE place_name='연남동 연트럴파크'), '연트럴파크에서 YOASOBI Idol 들으면 애니 주인공', 37.566100, 126.925800, ST_SetSRID(ST_MakePoint(126.925800, 37.566100), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='6ocbgoVGwYJhOv1GgI9NsC'), (SELECT id FROM places WHERE place_name='신촌 거리'), '신촌에서 Ariana Grande 7 rings 쇼핑 기분', 37.559700, 126.942200, ST_SetSRID(ST_MakePoint(126.942200, 37.559700), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),

-- ─── 마포구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='2Fxmhks0bxGSBdJ92vM42m'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 버스킹 보면서 Billie Eilish bad guy 분위기', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='7KXjTSCq5nL1LoYtL7XAwS'), (SELECT id FROM places WHERE place_name='합정역 카페거리'), '합정 카페에서 Kendrick Lamar HUMBLE 작업용', 37.549460, 126.913580, ST_SetSRID(ST_MakePoint(126.913580, 37.549460), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='5FVd6KXrgO9B3JPmGrhqHb'), (SELECT id FROM places WHERE place_name='상수역 책방골목'), '독립서점에서 Arctic Monkeys 감성 독서', 37.547650, 126.922600, ST_SetSRID(ST_MakePoint(126.922600, 37.547650), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='6habFhsceSTjwMFa8CqA8A'), (SELECT id FROM places WHERE place_name='망원한강공원'), '한강 피크닉에 Despacito 여름 바이브', 37.551930, 126.895230, ST_SetSRID(ST_MakePoint(126.895230, 37.551930), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='1ypMnktCB2eTkiPBOk2vCv'), (SELECT id FROM places WHERE place_name='연남동 골목길'), '연남동에서 YOASOBI 아이돌 들으면서 카페 투어', 37.562400, 126.925500, ST_SetSRID(ST_MakePoint(126.925500, 37.562400), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='2Foc5Q5nqNiosCNqttzHof'), (SELECT id FROM places WHERE place_name='경의선숲길'), '경의선숲길에서 Daft Punk Get Lucky 기분UP', 37.544900, 126.913200, ST_SetSRID(ST_MakePoint(126.913200, 37.544900), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 영등포구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='6b8Be6ljOzmkOmFslEb23P'), (SELECT id FROM places WHERE place_name='한강공원 여의도'), '여의도 한강에서 Bruno Mars 24K Magic 파티', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='2dpaYNEQHiRxtZbfNsse99'), (SELECT id FROM places WHERE place_name='여의도공원'), '여의도공원 산책에 Marshmello Happier 기분전환', 37.525800, 126.922400, ST_SetSRID(ST_MakePoint(126.922400, 37.525800), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='21jGcNKet2qwijlDFuPiPb'), (SELECT id FROM places WHERE place_name='선유도공원'), '선유도 일몰에 Post Malone Circles 루프', 37.541700, 126.899700, ST_SetSRID(ST_MakePoint(126.899700, 37.541700), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),

-- ─── 동작구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='0kL3TYRsSXnu0iJvFO3rit'), (SELECT id FROM places WHERE place_name='노량진 수산시장'), '노량진 시장 활기에 Drake Hotline Bling 바이브', 37.513600, 126.940800, ST_SetSRID(ST_MakePoint(126.940800, 37.513600), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='1Qrg8KqiBpW07V7PNxwwwL'), (SELECT id FROM places WHERE place_name='흑석동 중앙대학교'), '중앙대에서 SZA Kill Bill 들으면 영화 주인공', 37.505300, 126.957600, ST_SetSRID(ST_MakePoint(126.957600, 37.505300), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),

-- ─── 관악구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='7lQ8MOhq6IN2w8EYcFNSUk'), (SELECT id FROM places WHERE place_name='서울대학교'), '서울대 도서관에서 Eminem Without Me 각성제', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='6lgczhmJUHKJbFiB2iFerF'), (SELECT id FROM places WHERE place_name='관악산 등산로'), '관악산에서 Green Day Basket Case 에너지 폭발', 37.446700, 126.964100, ST_SetSRID(ST_MakePoint(126.964100, 37.446700), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),

-- ─── 서초구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='7FbrGaHYVDmfr7KoLIZnQ7'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역에서 FIFTY FIFTY Cupid 달달하게', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='5M70hy7bM7gMTKhb6mXOOe'), (SELECT id FROM places WHERE place_name='반포한강공원'), '반포 분수쇼에 ATEEZ Guerrilla 퍼포먼스 느낌', 37.510490, 127.008600, ST_SetSRID(ST_MakePoint(127.008600, 37.510490), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='1IHWl5LamUGEuP4ozKQSXZ'), (SELECT id FROM places WHERE place_name='반포 세빛섬'), '세빛섬에서 Bad Bunny 들으니 라틴 파티 느낌', 37.512400, 127.001800, ST_SetSRID(ST_MakePoint(127.001800, 37.512400), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4dGJf5P2DYPq8Zxgz1XnVp'), (SELECT id FROM places WHERE place_name='예술의전당'), '예술의전당에서 Crush Beautiful 들으면 감동 두배', 37.478300, 127.011600, ST_SetSRID(ST_MakePoint(127.011600, 37.478300), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 강남구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='6kL4AqU2qdEIXuFCQ10tqM'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스에서 TWICE The Feels 들으면 행복 가득', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='5QO79kh1waicV47BqGRL3g'), (SELECT id FROM places WHERE place_name='테라로사 강남점'), '테라로사에서 The Weeknd Save Your Tears 감성', 37.508333, 127.061667, ST_SetSRID(ST_MakePoint(127.061667, 37.508333), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='3PfIrDoz19wz7qK7tYeu7w'), (SELECT id FROM places WHERE place_name='압구정 로데오거리'), '압구정에서 Dua Lipa Don''t Start Now 쇼핑BGM', 37.527700, 127.040900, ST_SetSRID(ST_MakePoint(127.040900, 37.527700), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='6b8Be6ljOzmkOmFslEb23P'), (SELECT id FROM places WHERE place_name='가로수길'), '가로수길에서 Bruno Mars 24K Magic 워킹', 37.519200, 127.023500, ST_SetSRID(ST_MakePoint(127.023500, 37.519200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='2zrhoHlFKxFTRF5XEAoulP'), (SELECT id FROM places WHERE place_name='도산공원'), '도산공원에서 aespa Next Level 산책 모드', 37.523200, 127.035600, ST_SetSRID(ST_MakePoint(127.035600, 37.523200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='0SiywuOBRcynK0uKGWdCnn'), (SELECT id FROM places WHERE place_name='봉은사'), '봉은사 야경에 Lady Gaga Bad Romance 묘한 매력', 37.515200, 127.057800, ST_SetSRID(ST_MakePoint(127.057800, 37.515200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 송파구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='2zrhoHlFKxFTRF5XEAoulP'), (SELECT id FROM places WHERE place_name='석촌호수'), '석촌호수 걸으면서 aespa Next Level 기분전환', 37.510760, 127.099430, ST_SetSRID(ST_MakePoint(127.099430, 37.510760), 4326), NOW()-INTERVAL '4 days', NOW()-INTERVAL '4 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0pqnGHJpmpxLKifKRmU0WP'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '123층에서 Imagine Dragons Believer 외치면', 37.512460, 127.102470, ST_SetSRID(ST_MakePoint(127.102470, 37.512460), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='5M70hy7bM7gMTKhb6mXOOe'), (SELECT id FROM places WHERE place_name='올림픽공원'), '올림픽공원에서 ATEEZ Guerrilla 콘서트 느낌', 37.520800, 127.121700, ST_SetSRID(ST_MakePoint(127.121700, 37.520800), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='잠실한강공원'), '잠실 한강 러닝에 Avicii Wake Me Up 최고', 37.519300, 127.080600, ST_SetSRID(ST_MakePoint(127.080600, 37.519300), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='6habFhsceSTjwMFa8CqA8A'), (SELECT id FROM places WHERE place_name='송리단길'), '송리단길 맛집 투어에 Despacito 라틴 바이브', 37.509300, 127.098200, ST_SetSRID(ST_MakePoint(127.098200, 37.509300), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 강동구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='53RF5JR4dVaJapJbweexyH'), (SELECT id FROM places WHERE place_name='암사동 유적지'), '유적지에서 Fujii Kaze Shinunoga E-Wa 아시아 感', 37.551600, 127.131200, ST_SetSRID(ST_MakePoint(127.131200, 37.551600), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='광나루한강공원'), '한강 러닝에 Avicii Wake Me Up 활력 충전', 37.541200, 127.100500, ST_SetSRID(ST_MakePoint(127.100500, 37.541200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 강서구/구로구/금천구 신규 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='2dpaYNEQHiRxtZbfNsse99'), (SELECT id FROM places WHERE place_name='마곡나루역 서울식물원'), '식물원에서 Marshmello Happier 힐링', 37.569000, 126.835400, ST_SetSRID(ST_MakePoint(126.835400, 37.569000), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='0kL3TYRsSXnu0iJvFO3rit'), (SELECT id FROM places WHERE place_name='구로디지털단지역'), '퇴근길에 Drake Hotline Bling 들으면 기분전환', 37.485300, 126.901500, ST_SetSRID(ST_MakePoint(126.901500, 37.485300), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='7DfFc7a3mEsPTaLBCfNJRK'), (SELECT id FROM places WHERE place_name='가산디지털단지'), '가디 카페에서 Frank Ocean Thinkin Bout You 몽환', 37.478200, 126.882800, ST_SetSRID(ST_MakePoint(126.882800, 37.478200), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 양천구/영등포구 추가 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4fzsfWzRhPawzqhX8Qt9F3'), (SELECT id FROM places WHERE place_name='목동운동장'), '운동장 조깅에 Kanye West Stronger 파이팅', 37.525700, 126.873600, ST_SetSRID(ST_MakePoint(126.873600, 37.525700), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='1blficLzeYlqZ9dGROOhCy'), (SELECT id FROM places WHERE place_name='63빌딩'), '63빌딩 전망대에서 Daniel Caesar Best Part 낭만', 37.519780, 126.940120, ST_SetSRID(ST_MakePoint(126.940120, 37.519780), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 중랑구/서초구 추가 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='5ghIJDpPoe3CfHMGu71E6T'), (SELECT id FROM places WHERE place_name='용마폭포공원'), '폭포 소리와 Nirvana Smells Like Teen Spirit 조합', 37.575400, 127.084300, ST_SetSRID(ST_MakePoint(127.084300, 37.575400), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='4SLaUXPNB1EVddOQAmhnKO'), (SELECT id FROM places WHERE place_name='양재시민의숲'), '비 오는 숲에서 Heize 비도 오고 그래서 완벽', 37.471400, 127.037800, ST_SetSRID(ST_MakePoint(127.037800, 37.471400), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),

-- ─── 인기 장소 다중추천 추가 ───
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='3Ua0m0YmEjrMi9XErKcNiR'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대에서 (G)I-DLE TOMBOY 들으면 자기 자신 되기', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='6ocbgoVGwYJhOv1GgI9NsC'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 별마당에서 Ariana Grande 7 rings 플렉스', 37.512010, 127.058670, ST_SetSRID(ST_MakePoint(127.058670, 37.512010), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='6HMLFrHl77GoxCXJWq3MFz'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원에서 Jay Park MOMMAE 클럽 분위기', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='0It6VJoMAare1sdHhQWAN8'), (SELECT id FROM places WHERE place_name='명동거리'), '명동에서 EXO Love Shot 들으면 쇼핑 텐션 MAX', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='1Qrg8KqiBpW07V7PNxwwwL'), (SELECT id FROM places WHERE place_name='한남동 카페거리'), '한남동에서 SZA Kill Bill 들으면 쿨한 여자 느낌', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='7Fy53RtgsGW0wQKlGgPSIZ'), (SELECT id FROM places WHERE place_name='한강공원 여의도'), '여의도 한강 자전거에 Zion.T 양화대교 노을', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day')
ON CONFLICT DO NOTHING;


-- ========================================
-- 11. Additional Likes (신규 추천에 대한 반응)
-- ========================================

-- aespa Next Level @ 경복궁
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌌', NOW()-INTERVAL '8 days' FROM recommendations r CROSS JOIN users u WHERE r.message='aespa Next Level 들으면 경복궁도 광야 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='aespa Next Level 들으면 경복궁도 광야 느낌' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='aespa Next Level 들으면 경복궁도 광야 느낌' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- Crush Beautiful @ 북촌한옥마을
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😍', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한옥마을에서 크러쉬 Beautiful 들으니 도깨비 느낌' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한옥마을에서 크러쉬 Beautiful 들으니 도깨비 느낌' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- FIFTY FIFTY Cupid @ 명동
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💘', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 FIFTY FIFTY Cupid 들으면 사랑에 빠질듯' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 FIFTY FIFTY Cupid 들으면 사랑에 빠질듯' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 FIFTY FIFTY Cupid 들으면 사랑에 빠질듯' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- Lady Gaga Bad Romance @ DDP
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 미래적 건물에 Lady Gaga Bad Romance 찰떡' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 미래적 건물에 Lady Gaga Bad Romance 찰떡' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- DEAN instagram @ 힙지로
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📸', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 노포에서 DEAN instagram 감성 제대로' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 노포에서 DEAN instagram 감성 제대로' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 노포에서 DEAN instagram 감성 제대로' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- Save Your Tears @ N서울타워
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='남산타워에서 Save Your Tears 들으며 야경 감상' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😭', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='남산타워에서 Save Your Tears 들으며 야경 감상' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- Daniel Caesar Best Part @ 한남동
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💕', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동 분위기에 Daniel Caesar Best Part 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동 분위기에 Daniel Caesar Best Part 감성' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- (G)I-DLE TOMBOY @ 성수카페
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수 카페에서 (G)I-DLE TOMBOY 들으면 자신감 뿜뿜' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수 카페에서 (G)I-DLE TOMBOY 들으면 자신감 뿜뿜' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👑', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수 카페에서 (G)I-DLE TOMBOY 들으면 자신감 뿜뿜' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;

-- Frank Ocean @ 서울숲
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌳', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 벤치에서 Frank Ocean Thinkin Bout You 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 벤치에서 Frank Ocean Thinkin Bout You 감성' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- Heize @ 뚝섬역 벽화골목
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌧️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 날 벽화골목에서 Heize 비도 오고 그래서' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 날 벽화골목에서 Heize 비도 오고 그래서' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 날 벽화골목에서 Heize 비도 오고 그래서' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- Billie Eilish bad guy @ 홍대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😈', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 보면서 Billie Eilish bad guy 분위기' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 보면서 Billie Eilish bad guy 분위기' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 보면서 Billie Eilish bad guy 분위기' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- YOASOBI Idol @ 연트럴파크
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⭐', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 YOASOBI Idol 들으면 애니 주인공' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 YOASOBI Idol 들으면 애니 주인공' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='연트럴파크에서 YOASOBI Idol 들으면 애니 주인공' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- (G)I-DLE TOMBOY @ 홍대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대에서 (G)I-DLE TOMBOY 들으면 자기 자신 되기' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '👑', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대에서 (G)I-DLE TOMBOY 들으면 자기 자신 되기' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- Bruno Mars 24K Magic @ 여의도
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '✨', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강에서 Bruno Mars 24K Magic 파티' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강에서 Bruno Mars 24K Magic 파티' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강에서 Bruno Mars 24K Magic 파티' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- Imagine Dragons Believer @ 롯데월드타워
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏙️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='123층에서 Imagine Dragons Believer 외치면' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='123층에서 Imagine Dragons Believer 외치면' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='123층에서 Imagine Dragons Believer 외치면' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- TWICE The Feels @ 코엑스
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💖', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스에서 TWICE The Feels 들으면 행복 가득' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스에서 TWICE The Feels 들으면 행복 가득' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- Ariana Grande 7 rings @ 코엑스
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💎', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당에서 Ariana Grande 7 rings 플렉스' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '✨', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당에서 Ariana Grande 7 rings 플렉스' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- ATEEZ Guerrilla @ 반포한강공원
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 분수쇼에 ATEEZ Guerrilla 퍼포먼스 느낌' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 분수쇼에 ATEEZ Guerrilla 퍼포먼스 느낌' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;

-- SZA Kill Bill @ 중앙대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚔️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='중앙대에서 SZA Kill Bill 들으면 영화 주인공' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='중앙대에서 SZA Kill Bill 들으면 영화 주인공' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- Zion.T 양화대교 @ 여의도
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌅', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강 자전거에 Zion.T 양화대교 노을' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강 자전거에 Zion.T 양화대교 노을' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '3 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 한강 자전거에 Zion.T 양화대교 노을' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- Coldplay Yellow @ 고대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🍂', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='고대 가을 캠퍼스에서 Coldplay Yellow 낭만' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='고대 가을 캠퍼스에서 Coldplay Yellow 낭만' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- EXO Love Shot @ 건대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 EXO Love Shot 들으면 텐션' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 EXO Love Shot 들으면 텐션' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- Jay Park MOMMAE @ 이태원 (new)
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원에서 Jay Park MOMMAE 클럽 분위기' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😎', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원에서 Jay Park MOMMAE 클럽 분위기' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- Kendrick HUMBLE @ 합정
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎤', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='합정 카페에서 Kendrick Lamar HUMBLE 작업용' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='합정 카페에서 Kendrick Lamar HUMBLE 작업용' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- Red Velvet Psycho @ 대림창고
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🖤', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 전시에 Red Velvet Psycho 분위기' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='대림창고 전시에 Red Velvet Psycho 분위기' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;

-- Dua Lipa Don't Start Now @ 어니언
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언에서 Dua Lipa Don''t Start Now 기분 전환' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언에서 Dua Lipa Don''t Start Now 기분 전환' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- Avicii Wake Me Up @ 뚝섬유원지
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☀️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한강에서 Avicii Wake Me Up 들으면 자유 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한강에서 Avicii Wake Me Up 들으면 자유 느낌' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- Daft Punk Get Lucky @ 경의선숲길
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🤖', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길에서 Daft Punk Get Lucky 기분UP' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길에서 Daft Punk Get Lucky 기분UP' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- Nirvana @ 도봉산
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏔️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='등산길에 Nirvana Smells Like Teen Spirit 에너지' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='등산길에 Nirvana Smells Like Teen Spirit 에너지' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- Post Malone Circles @ 선유도
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌅', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 일몰에 Post Malone Circles 루프' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 일몰에 Post Malone Circles 루프' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- ATEEZ Guerrilla @ 올림픽공원
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎤', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원에서 ATEEZ Guerrilla 콘서트 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원에서 ATEEZ Guerrilla 콘서트 느낌' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- Heize @ 양재시민의숲
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌧️', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 숲에서 Heize 비도 오고 그래서 완벽' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 숲에서 Heize 비도 오고 그래서 완벽' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '3 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='비 오는 숲에서 Heize 비도 오고 그래서 완벽' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- SZA Kill Bill @ 한남동
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚔️', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동에서 SZA Kill Bill 들으면 쿨한 여자 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='한남동에서 SZA Kill Bill 들으면 쿨한 여자 느낌' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- EXO Love Shot @ 명동
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 EXO Love Shot 들으면 쇼핑 텐션 MAX' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 EXO Love Shot 들으면 쇼핑 텐션 MAX' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '3 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='명동에서 EXO Love Shot 들으면 쇼핑 텐션 MAX' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- =============================================
-- BATCH 3: Additional Recommendations (장소×트랙 새 조합)
-- =============================================

INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at) VALUES
-- 종로구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='3Ua0m0YmEjrMi9XErKcNiR'), (SELECT id FROM places WHERE place_name='경복궁'), '경복궁 야간개장에서 (G)I-DLE TOMBOY 텐션', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW()-INTERVAL '55 days', NOW()-INTERVAL '55 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='4PQLAV3O3RMsmNZ3iAYB9D'), (SELECT id FROM places WHERE place_name='북촌한옥마을'), '북촌 골목길에 AKMU 200% 흥겨움이 번짐', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW()-INTERVAL '52 days', NOW()-INTERVAL '52 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='6n8Wk7vaBmQtGGCgirrgY8'), (SELECT id FROM places WHERE place_name='인사동 쌈지길'), '쌈지길 3층 테라스에서 10cm 폰서트 들으면 눈물', 37.573924, 126.985019, ST_SetSRID(ST_MakePoint(126.985019, 37.573924), 4326), NOW()-INTERVAL '49 days', NOW()-INTERVAL '49 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='5QO79kh1waicV47BqGRL3g'), (SELECT id FROM places WHERE place_name='광화문광장'), '광화문 분수 앞에서 Save Your Tears 멜로 감성', 37.572280, 126.976890, ST_SetSRID(ST_MakePoint(126.976890, 37.572280), 4326), NOW()-INTERVAL '46 days', NOW()-INTERVAL '46 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='4dGJf5P2DYPq8Zxgz1XnVp'), (SELECT id FROM places WHERE place_name='창덕궁'), '창덕궁 후원에서 Crush Beautiful 감동 두 배', 37.579400, 126.991100, ST_SetSRID(ST_MakePoint(126.991100, 37.579400), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='7Fy53RtgsGW0wQKlGgPSIZ'), (SELECT id FROM places WHERE place_name='블루보틀 삼청점'), '블루보틀 라떼와 Zion.T 양화대교 조합 힐링', 37.584028, 126.982900, ST_SetSRID(ST_MakePoint(126.982900, 37.584028), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='2lVk3lmUsBYYxChYnQ5lA7'), (SELECT id FROM places WHERE place_name='종묘'), '종묘 산책길에 BOL4 여행 듣기 감성 충전', 37.574240, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.574240), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),

-- 중구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='0SiywuOBRcynK0uKGWdCnn'), (SELECT id FROM places WHERE place_name='명동거리'), '명동 네온사인 아래서 Lady Gaga Bad Romance', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '53 days', NOW()-INTERVAL '53 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='6b8Be6ljOzmkOmFslEb23P'), (SELECT id FROM places WHERE place_name='남대문시장'), '남대문 칼국수 먹고 Bruno Mars 24K Magic 기분', 37.559398, 126.977600, ST_SetSRID(ST_MakePoint(126.977600, 37.559398), 4326), NOW()-INTERVAL '50 days', NOW()-INTERVAL '50 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='2zrhoHlFKxFTRF5XEAoulP'), (SELECT id FROM places WHERE place_name='DDP 동대문디자인플라자'), 'DDP 미래건축 앞에서 aespa Next Level 찰떡', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='5r8BNlPXr8VjAXVEb3Rm6n'), (SELECT id FROM places WHERE place_name='을지로3가 힙지로'), '힙지로 공구 골목에서 DEAN instagram 감성', 37.566010, 126.991350, ST_SetSRID(ST_MakePoint(126.991350, 37.566010), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='4SLaUXPNB1EVddOQAmhnKO'), (SELECT id FROM places WHERE place_name='남산골한옥마을'), '비 오는 남산골에서 Heize 비도 오고 그래서 완벽 매칭', 37.559050, 126.994170, ST_SetSRID(ST_MakePoint(126.994170, 37.559050), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),

-- 용산구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7DfFc7a3mEsPTaLBCfNJRK'), (SELECT id FROM places WHERE place_name='N서울타워'), '남산타워 꼭대기에서 Frank Ocean Thinkin Bout You 로맨틱', 37.551169, 126.988227, ST_SetSRID(ST_MakePoint(126.988227, 37.551169), 4326), NOW()-INTERVAL '54 days', NOW()-INTERVAL '54 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='6HMLFrHl77GoxCXJWq3MFz'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원 밤거리에서 Jay Park MOMMAE 분위기 미쳤다', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '51 days', NOW()-INTERVAL '51 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='1blficLzeYlqZ9dGROOhCy'), (SELECT id FROM places WHERE place_name='국립중앙박물관'), '박물관 정원에서 Daniel Caesar Best Part 로맨스', 37.523800, 126.980620, ST_SetSRID(ST_MakePoint(126.980620, 37.523800), 4326), NOW()-INTERVAL '48 days', NOW()-INTERVAL '48 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='1Qrg8KqiBpW07V7PNxwwwL'), (SELECT id FROM places WHERE place_name='한남동 카페거리'), '한남동 카페투어 중 SZA Kill Bill 쿨한 바이브', 37.534600, 127.000450, ST_SetSRID(ST_MakePoint(127.000450, 37.534600), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='경리단길'), '경리단길 야경에 Avicii Wake Me Up 에너지 충전', 37.537300, 126.987450, ST_SetSRID(ST_MakePoint(126.987450, 37.537300), 4326), NOW()-INTERVAL '42 days', NOW()-INTERVAL '42 days'),

-- 성동구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='5FVd6KXrgO9B3JPmGrhqHb'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 벤치에서 Arctic Monkeys 인디 감성 폭발', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '56 days', NOW()-INTERVAL '56 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='6FBNMJFjexyBfFaEaMNRRs'), (SELECT id FROM places WHERE place_name='성수동 카페거리'), '성수 카페 호핑하면서 TXT Sugar Rush Ride 기분', 37.544200, 127.055800, ST_SetSRID(ST_MakePoint(127.055800, 37.544200), 4326), NOW()-INTERVAL '53 days', NOW()-INTERVAL '53 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7FbrGaHYVDmfr7KoLIZnQ7'), (SELECT id FROM places WHERE place_name='뚝섬역 벽화골목'), '벽화 배경으로 FIFTY FIFTY Cupid 사진 찍기', 37.547300, 127.047100, ST_SetSRID(ST_MakePoint(127.047100, 37.547300), 4326), NOW()-INTERVAL '50 days', NOW()-INTERVAL '50 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='6kL4AqU2qdEIXuFCQ10tqM'), (SELECT id FROM places WHERE place_name='성수역 앞 광장'), '성수역 퇴근길에 TWICE The Feels 기분 전환', 37.544580, 127.055900, ST_SetSRID(ST_MakePoint(127.055900, 37.544580), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='3PfIrDoz19wz7qK7tYeu7w'), (SELECT id FROM places WHERE place_name='성수 대림창고'), '대림창고 전시 끝나고 Dua Lipa Don''t Start Now 댄스', 37.544100, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.544100), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='21jGcNKet2qwijlDFuPiPb'), (SELECT id FROM places WHERE place_name='성수연방'), '성수연방 옥상에서 Post Malone Circles 석양 감상', 37.543900, 127.054700, ST_SetSRID(ST_MakePoint(127.054700, 37.543900), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='6ocbgoVGwYJhOv1GgI9NsC'), (SELECT id FROM places WHERE place_name='어니언 성수점'), '어니언 빵과 Ariana Grande 7 rings 럭셔리 감성', 37.545200, 127.056800, ST_SetSRID(ST_MakePoint(127.056800, 37.545200), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='0lIzj9bwmhiCSOZQMhb3LH'), (SELECT id FROM places WHERE place_name='성수 갤러리아포레'), '갤러리아포레 야경에 Red Velvet Psycho 분위기', 37.545100, 127.053500, ST_SetSRID(ST_MakePoint(127.053500, 37.545100), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='5M70hy7bM7gMTKhb6mXOOe'), (SELECT id FROM places WHERE place_name='뚝도시장'), '뚝도시장 에너지에 ATEEZ Guerrilla 매칭', 37.547800, 127.048200, ST_SetSRID(ST_MakePoint(127.048200, 37.547800), 4326), NOW()-INTERVAL '32 days', NOW()-INTERVAL '32 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='2Foc5Q5nqNiosCNqttzHof'), (SELECT id FROM places WHERE place_name='할아버지공장'), '할아버지공장 레트로 인테리어에 Daft Punk Get Lucky', 37.544400, 127.051800, ST_SetSRID(ST_MakePoint(127.051800, 37.544400), 4326), NOW()-INTERVAL '29 days', NOW()-INTERVAL '29 days'),

-- 광진구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='7BKLCZ1jbUBVqRi2FVlTVw'), (SELECT id FROM places WHERE place_name='건대입구 커먼그라운드'), '커먼그라운드에서 Chainsmokers Closer 불금', 37.542470, 127.068100, ST_SetSRID(ST_MakePoint(127.068100, 37.542470), 4326), NOW()-INTERVAL '57 days', NOW()-INTERVAL '57 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='2dpaYNEQHiRxtZbfNsse99'), (SELECT id FROM places WHERE place_name='뚝섬유원지'), '한강 따라 자전거 타면서 Marshmello Happier', 37.531600, 127.066800, ST_SetSRID(ST_MakePoint(127.066800, 37.531600), 4326), NOW()-INTERVAL '54 days', NOW()-INTERVAL '54 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='1ypMnktCB2eTkiPBOk2vCv'), (SELECT id FROM places WHERE place_name='어린이대공원'), '어린이대공원에서 YOASOBI Idol 들으면 더 즐거움', 37.548300, 127.080200, ST_SetSRID(ST_MakePoint(127.080200, 37.548300), 4326), NOW()-INTERVAL '51 days', NOW()-INTERVAL '51 days'),

-- 동대문구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='0pqnGHJpmpxLKifKRmU0WP'), (SELECT id FROM places WHERE place_name='경희대학교'), '경희대 평화의전당 앞에서 Imagine Dragons Believer', 37.597010, 127.051480, ST_SetSRID(ST_MakePoint(127.051480, 37.597010), 4326), NOW()-INTERVAL '48 days', NOW()-INTERVAL '48 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='6lgczhmJUHKJbFiB2iFerF'), (SELECT id FROM places WHERE place_name='회기역 먹자골목'), '회기 맛집 탐방하면서 Green Day Basket Case 파워', 37.589500, 127.057200, ST_SetSRID(ST_MakePoint(127.057200, 37.589500), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),

-- 성북구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='53RF5JR4dVaJapJbweexyH'), (SELECT id FROM places WHERE place_name='고려대학교'), '고대 중앙광장에서 Fujii Kaze 일본 감성', 37.589610, 127.032400, ST_SetSRID(ST_MakePoint(127.032400, 37.589610), 4326), NOW()-INTERVAL '55 days', NOW()-INTERVAL '55 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4SLaUXPNB1EVddOQAmhnKO'), (SELECT id FROM places WHERE place_name='성북동 수연산방'), '수연산방 빗소리에 Heize 비도 오고 그래서', 37.593880, 127.007200, ST_SetSRID(ST_MakePoint(127.007200, 37.593880), 4326), NOW()-INTERVAL '52 days', NOW()-INTERVAL '52 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='3AJwUDP919kvQ9QcozQPxg'), (SELECT id FROM places WHERE place_name='길상사'), '길상사 고즈넉함에 Coldplay Yellow 잔잔함', 37.600970, 127.006900, ST_SetSRID(ST_MakePoint(127.006900, 37.600970), 4326), NOW()-INTERVAL '49 days', NOW()-INTERVAL '49 days'),

-- 강북구·도봉구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='60a0Rd6pjrkxjPbaKzXjfq'), (SELECT id FROM places WHERE place_name='북한산 우이령길'), '북한산 등산 중 Linkin Park In The End 파이팅', 37.641580, 127.011900, ST_SetSRID(ST_MakePoint(127.011900, 37.641580), 4326), NOW()-INTERVAL '46 days', NOW()-INTERVAL '46 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='5ghIJDpPoe3CfHMGu71E6T'), (SELECT id FROM places WHERE place_name='도봉산역 등산로입구'), '도봉산 가는 길에 Nirvana Smells Like Teen Spirit', 37.689480, 127.044250, ST_SetSRID(ST_MakePoint(127.044250, 37.689480), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),

-- 노원구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='4fsQ0K37TOXa3hEQfjEic1'), (SELECT id FROM places WHERE place_name='노원역 로데오거리'), '노원 로데오에서 LE SSERAFIM ANTIFRAGILE 쇼핑', 37.656020, 127.061580, ST_SetSRID(ST_MakePoint(127.061580, 37.656020), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='3z8h0TU7ReDPLIbEnYhWZb'), (SELECT id FROM places WHERE place_name='수락산 등산로'), '수락산 정상에서 Queen Bohemian Rhapsody 질러!', 37.671800, 127.072200, ST_SetSRID(ST_MakePoint(127.072200, 37.671800), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),

-- 은평구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='2Fxmhks0bxGSBdJ92vM42m'), (SELECT id FROM places WHERE place_name='은평한옥마을'), '은평한옥마을 조용한 밤에 Billie Eilish bad guy 반전매력', 37.636400, 126.918300, ST_SetSRID(ST_MakePoint(126.918300, 37.636400), 4326), NOW()-INTERVAL '34 days', NOW()-INTERVAL '34 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='7o9uu2GDtVDr9nsR7ZRN73'), (SELECT id FROM places WHERE place_name='서오릉'), '서오릉 가을 단풍길에 Cyndi Lauper Time After Time', 37.638500, 126.900200, ST_SetSRID(ST_MakePoint(126.900200, 37.638500), 4326), NOW()-INTERVAL '31 days', NOW()-INTERVAL '31 days'),

-- 서대문구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='0kL3TYRsSXnu0iJvFO3rit'), (SELECT id FROM places WHERE place_name='연세대학교'), '연대 백양로에서 Drake Hotline Bling 힙하게', 37.566536, 126.939370, ST_SetSRID(ST_MakePoint(126.939370, 37.566536), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='6n8Wk7vaBmQtGGCgirrgY8'), (SELECT id FROM places WHERE place_name='연남동 연트럴파크'), '연트럴파크 산책로에서 10cm 폰서트 감성 폭발', 37.566100, 126.925800, ST_SetSRID(ST_MakePoint(126.925800, 37.566100), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='4fzsfWzRhPawzqhX8Qt9F3'), (SELECT id FROM places WHERE place_name='신촌 거리'), '신촌 불금에 Kanye West Stronger 텐션 올리기', 37.559700, 126.942200, ST_SetSRID(ST_MakePoint(126.942200, 37.559700), 4326), NOW()-INTERVAL '22 days', NOW()-INTERVAL '22 days'),

-- 마포구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='1IHWl5LamUGEuP4ozKQSXZ'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 버스킹 거리에서 Bad Bunny 라틴 바이브', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '58 days', NOW()-INTERVAL '58 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='2Fxmhks0bxGSBdJ92vM42m'), (SELECT id FROM places WHERE place_name='합정역 카페거리'), '합정 카페에서 Billie Eilish bad guy 분위기 있게', 37.549460, 126.913580, ST_SetSRID(ST_MakePoint(126.913580, 37.549460), 4326), NOW()-INTERVAL '55 days', NOW()-INTERVAL '55 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='4dGJf5P2DYPq8Zxgz1XnVp'), (SELECT id FROM places WHERE place_name='상수역 책방골목'), '독서 후 Crush Beautiful 들으면 마음이 따뜻해짐', 37.547650, 126.922600, ST_SetSRID(ST_MakePoint(126.922600, 37.547650), 4326), NOW()-INTERVAL '52 days', NOW()-INTERVAL '52 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='6habFhsceSTjwMFa8CqA8A'), (SELECT id FROM places WHERE place_name='망원한강공원'), '한강 피크닉에 Despacito 라틴 감성 여름 바이브', 37.551930, 126.895230, ST_SetSRID(ST_MakePoint(126.895230, 37.551930), 4326), NOW()-INTERVAL '49 days', NOW()-INTERVAL '49 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='7lQ8MOhq6IN2w8EYcFNSUk'), (SELECT id FROM places WHERE place_name='연남동 골목길'), '연남동 밤산책에 Eminem Without Me 역전 에너지', 37.562400, 126.925500, ST_SetSRID(ST_MakePoint(126.925500, 37.562400), 4326), NOW()-INTERVAL '46 days', NOW()-INTERVAL '46 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='2dpaYNEQHiRxtZbfNsse99'), (SELECT id FROM places WHERE place_name='경의선숲길'), '경의선숲길 벚꽃에 Marshmello Happier 기분좋음', 37.544900, 126.913200, ST_SetSRID(ST_MakePoint(126.913200, 37.544900), 4326), NOW()-INTERVAL '43 days', NOW()-INTERVAL '43 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='5c58c6sKc2JK3o75ZBSeL1'), (SELECT id FROM places WHERE place_name='월드컵경기장'), '월드컵경기장에서 PSY 강남스타일 응원 열기', 37.568330, 126.897200, ST_SetSRID(ST_MakePoint(126.897200, 37.568330), 4326), NOW()-INTERVAL '40 days', NOW()-INTERVAL '40 days'),

-- 강서구·양천구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='3AJwUDP919kvQ9QcozQPxg'), (SELECT id FROM places WHERE place_name='마곡나루역 서울식물원'), '식물원 온실에서 Coldplay Yellow 초록초록 감성', 37.569000, 126.835400, ST_SetSRID(ST_MakePoint(126.835400, 37.569000), 4326), NOW()-INTERVAL '37 days', NOW()-INTERVAL '37 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='7KXjTSCq5nL1LoYtL7XAwS'), (SELECT id FROM places WHERE place_name='김포공항 하늘길'), '비행기 이착륙 보며 Kendrick Lamar HUMBLE 기분', 37.558990, 126.794540, ST_SetSRID(ST_MakePoint(126.794540, 37.558990), 4326), NOW()-INTERVAL '34 days', NOW()-INTERVAL '34 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='69WpV0U7OMNFGyq8I63dcC'), (SELECT id FROM places WHERE place_name='목동운동장'), '목동 조깅 중 ENHYPEN Given-Taken 달리기 잘됨', 37.525700, 126.873600, ST_SetSRID(ST_MakePoint(126.873600, 37.525700), 4326), NOW()-INTERVAL '31 days', NOW()-INTERVAL '31 days'),

-- 구로구·금천구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='7BKLCZ1jbUBVqRi2FVlTVw'), (SELECT id FROM places WHERE place_name='구로디지털단지역'), '퇴근길 G밸리에서 Chainsmokers Closer 기분전환', 37.485300, 126.901500, ST_SetSRID(ST_MakePoint(126.901500, 37.485300), 4326), NOW()-INTERVAL '28 days', NOW()-INTERVAL '28 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='5FVd6KXrgO9B3JPmGrhqHb'), (SELECT id FROM places WHERE place_name='항동철길'), '폐철길 인스타 감성에 Arctic Monkeys 인디록', 37.482500, 126.863200, ST_SetSRID(ST_MakePoint(126.863200, 37.482500), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='3r8RuvgbX9s7ammBn07D3W'), (SELECT id FROM places WHERE place_name='가산디지털단지'), '가디 점심시간에 NewJeans Ditto 들으면 힐링', 37.478200, 126.882800, ST_SetSRID(ST_MakePoint(126.882800, 37.478200), 4326), NOW()-INTERVAL '22 days', NOW()-INTERVAL '22 days'),

-- 영등포구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='한강공원 여의도'), '여의도 불꽃축제에 Avicii Wake Me Up 축제 기분', 37.529030, 126.932570, ST_SetSRID(ST_MakePoint(126.932570, 37.529030), 4326), NOW()-INTERVAL '56 days', NOW()-INTERVAL '56 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='6kL4AqU2qdEIXuFCQ10tqM'), (SELECT id FROM places WHERE place_name='영등포 타임스퀘어'), '타임스퀘어에서 TWICE The Feels 쇼핑 댄스', 37.517150, 126.903200, ST_SetSRID(ST_MakePoint(126.903200, 37.517150), 4326), NOW()-INTERVAL '53 days', NOW()-INTERVAL '53 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='4PQLAV3O3RMsmNZ3iAYB9D'), (SELECT id FROM places WHERE place_name='선유도공원'), '선유도 석양에 AKMU 200% 행복 에너지', 37.541700, 126.899700, ST_SetSRID(ST_MakePoint(126.899700, 37.541700), 4326), NOW()-INTERVAL '50 days', NOW()-INTERVAL '50 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='0It6VJoMAare1sdHhQWAN8'), (SELECT id FROM places WHERE place_name='63빌딩'), '63빌딩 전망대에서 EXO Love Shot 시티팝 느낌', 37.519780, 126.940120, ST_SetSRID(ST_MakePoint(126.940120, 37.519780), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='1ypMnktCB2eTkiPBOk2vCv'), (SELECT id FROM places WHERE place_name='여의도공원'), '여의도공원 산책에 YOASOBI Idol 들으면 기분↑', 37.525800, 126.922400, ST_SetSRID(ST_MakePoint(126.922400, 37.525800), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),

-- 동작구·관악구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='0pqnGHJpmpxLKifKRmU0WP'), (SELECT id FROM places WHERE place_name='노량진 수산시장'), '노량진 활기에 Imagine Dragons Believer 의지', 37.513600, 126.940800, ST_SetSRID(ST_MakePoint(126.940800, 37.513600), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='6b8Be6ljOzmkOmFslEb23P'), (SELECT id FROM places WHERE place_name='사당역 먹자골목'), '사당 뒷골목 포장마차에서 Bruno Mars 24K Magic', 37.476600, 126.981700, ST_SetSRID(ST_MakePoint(126.981700, 37.476600), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='7Fy53RtgsGW0wQKlGgPSIZ'), (SELECT id FROM places WHERE place_name='흑석동 중앙대학교'), '중대 캠퍼스에서 Zion.T 양화대교 한강뷰 감성', 37.505300, 126.957600, ST_SetSRID(ST_MakePoint(126.957600, 37.505300), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='2lVk3lmUsBYYxChYnQ5lA7'), (SELECT id FROM places WHERE place_name='보라매공원'), '보라매공원 벤치에서 BOL4 여행 들으며 떠나고싶다', 37.493100, 126.927800, ST_SetSRID(ST_MakePoint(126.927800, 37.493100), 4326), NOW()-INTERVAL '32 days', NOW()-INTERVAL '32 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='5r8BNlPXr8VjAXVEb3Rm6n'), (SELECT id FROM places WHERE place_name='서울대학교'), '서울대 샤로수길에서 DEAN instagram 힙한 저녁', 37.460800, 126.951900, ST_SetSRID(ST_MakePoint(126.951900, 37.460800), 4326), NOW()-INTERVAL '29 days', NOW()-INTERVAL '29 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0SiywuOBRcynK0uKGWdCnn'), (SELECT id FROM places WHERE place_name='신림역 순대타운'), '순대국 먹고 Lady Gaga Bad Romance 힘내기', 37.484200, 126.929500, ST_SetSRID(ST_MakePoint(126.929500, 37.484200), 4326), NOW()-INTERVAL '26 days', NOW()-INTERVAL '26 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='5ghIJDpPoe3CfHMGu71E6T'), (SELECT id FROM places WHERE place_name='관악산 등산로'), '관악산 등반 중 Nirvana Smells Like Teen Spirit 질주', 37.445800, 126.964200, ST_SetSRID(ST_MakePoint(126.964200, 37.445800), 4326), NOW()-INTERVAL '23 days', NOW()-INTERVAL '23 days'),

-- 서초구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='4fzsfWzRhPawzqhX8Qt9F3'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역 불금에 Kanye West Stronger 시작', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '57 days', NOW()-INTERVAL '57 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='4SLaUXPNB1EVddOQAmhnKO'), (SELECT id FROM places WHERE place_name='양재시민의숲'), '양재숲 산책길에 Heize 비도 오고 그래서 분위기', 37.470300, 127.037900, ST_SetSRID(ST_MakePoint(127.037900, 37.470300), 4326), NOW()-INTERVAL '54 days', NOW()-INTERVAL '54 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='3PfIrDoz19wz7qK7tYeu7w'), (SELECT id FROM places WHERE place_name='반포한강공원'), '반포 달빛무지개 분수에 Dua Lipa Don''t Start Now', 37.509600, 126.995800, ST_SetSRID(ST_MakePoint(126.995800, 37.509600), 4326), NOW()-INTERVAL '51 days', NOW()-INTERVAL '51 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='1c3GkbZBnyrQ1cm4TGHFrK'), (SELECT id FROM places WHERE place_name='예술의전당'), '예술의전당 공연 전 카논 들으며 기다리는 설렘', 37.478600, 127.013000, ST_SetSRID(ST_MakePoint(127.013000, 37.478600), 4326), NOW()-INTERVAL '48 days', NOW()-INTERVAL '48 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_junho'), (SELECT id FROM tracks WHERE spotify_track_id='5QO79kh1waicV47BqGRL3g'), (SELECT id FROM places WHERE place_name='서초동 법원거리카페'), '법원거리 카페에서 The Weeknd Save Your Tears 무드', 37.490200, 127.006700, ST_SetSRID(ST_MakePoint(127.006700, 37.490200), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='6ocbgoVGwYJhOv1GgI9NsC'), (SELECT id FROM places WHERE place_name='반포 세빛섬'), '세빛섬 야경에 Ariana Grande 7 rings 럭셔리', 37.510400, 126.996200, ST_SetSRID(ST_MakePoint(126.996200, 37.510400), 4326), NOW()-INTERVAL '42 days', NOW()-INTERVAL '42 days'),

-- 강남구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='0kL3TYRsSXnu0iJvFO3rit'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 별마당 도서관에서 Drake Hotline Bling', 37.513100, 127.058200, ST_SetSRID(ST_MakePoint(127.058200, 37.513100), 4326), NOW()-INTERVAL '59 days', NOW()-INTERVAL '59 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='2zrhoHlFKxFTRF5XEAoulP'), (SELECT id FROM places WHERE place_name='테라로사 강남점'), '테라로사 커피 마시면서 aespa Next Level 활력', 37.504200, 127.024800, ST_SetSRID(ST_MakePoint(127.024800, 37.504200), 4326), NOW()-INTERVAL '56 days', NOW()-INTERVAL '56 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='0SiywuOBRcynK0uKGWdCnn'), (SELECT id FROM places WHERE place_name='압구정로데오거리'), '압구정에서 Lady Gaga Bad Romance 패션쇼 느낌', 37.527500, 127.040100, ST_SetSRID(ST_MakePoint(127.040100, 37.527500), 4326), NOW()-INTERVAL '53 days', NOW()-INTERVAL '53 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='7DfFc7a3mEsPTaLBCfNJRK'), (SELECT id FROM places WHERE place_name='가로수길'), '가로수길 걸으면서 Frank Ocean Thinkin Bout You 감성', 37.521700, 127.023200, ST_SetSRID(ST_MakePoint(127.023200, 37.521700), 4326), NOW()-INTERVAL '50 days', NOW()-INTERVAL '50 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='3Ua0m0YmEjrMi9XErKcNiR'), (SELECT id FROM places WHERE place_name='선릉공원'), '선릉 점심산책에 (G)I-DLE TOMBOY 기분 전환', 37.510500, 127.049000, ST_SetSRID(ST_MakePoint(127.049000, 37.510500), 4326), NOW()-INTERVAL '47 days', NOW()-INTERVAL '47 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='53RF5JR4dVaJapJbweexyH'), (SELECT id FROM places WHERE place_name='봉은사'), '봉은사 고요한 경내에 Fujii Kaze 일본 감성 힐링', 37.514700, 127.057800, ST_SetSRID(ST_MakePoint(127.057800, 37.514700), 4326), NOW()-INTERVAL '44 days', NOW()-INTERVAL '44 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='1Qrg8KqiBpW07V7PNxwwwL'), (SELECT id FROM places WHERE place_name='삼성역 파르나스몰'), '파르나스몰에서 SZA Kill Bill 파워 쇼핑', 37.508400, 127.060900, ST_SetSRID(ST_MakePoint(127.060900, 37.508400), 4326), NOW()-INTERVAL '41 days', NOW()-INTERVAL '41 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='1blficLzeYlqZ9dGROOhCy'), (SELECT id FROM places WHERE place_name='도산공원'), '도산공원 벤치에서 Daniel Caesar Best Part 감성', 37.523400, 127.037100, ST_SetSRID(ST_MakePoint(127.037100, 37.523400), 4326), NOW()-INTERVAL '38 days', NOW()-INTERVAL '38 days'),

-- 송파구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='6FBNMJFjexyBfFaEaMNRRs'), (SELECT id FROM places WHERE place_name='석촌호수'), '석촌호수 벚꽃길에 TXT Sugar Rush Ride 봄 감성', 37.510700, 127.098400, ST_SetSRID(ST_MakePoint(127.098400, 37.510700), 4326), NOW()-INTERVAL '60 days', NOW()-INTERVAL '60 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='0lIzj9bwmhiCSOZQMhb3LH'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '롯데타워 전망대에서 Red Velvet Psycho 도시 야경', 37.512600, 127.102500, ST_SetSRID(ST_MakePoint(127.102500, 37.512600), 4326), NOW()-INTERVAL '57 days', NOW()-INTERVAL '57 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='2Foc5Q5nqNiosCNqttzHof'), (SELECT id FROM places WHERE place_name='올림픽공원'), '올림픽공원 잔디밭에서 Daft Punk Get Lucky 여유', 37.521100, 127.121700, ST_SetSRID(ST_MakePoint(127.121700, 37.521100), 4326), NOW()-INTERVAL '54 days', NOW()-INTERVAL '54 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='1mWdTewIgB3gtBM3TOSFhB'), (SELECT id FROM places WHERE place_name='잠실야구장'), '야구 응원하면서 BTS Butter 떼창 분위기', 37.512200, 127.071900, ST_SetSRID(ST_MakePoint(127.071900, 37.512200), 4326), NOW()-INTERVAL '51 days', NOW()-INTERVAL '51 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='6HMLFrHl77GoxCXJWq3MFz'), (SELECT id FROM places WHERE place_name='방이동 먹자골목'), '방이동 먹자골목에서 Jay Park MOMMAE 야식 타임', 37.515800, 127.117500, ST_SetSRID(ST_MakePoint(127.117500, 37.515800), 4326), NOW()-INTERVAL '48 days', NOW()-INTERVAL '48 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='21jGcNKet2qwijlDFuPiPb'), (SELECT id FROM places WHERE place_name='잠실한강공원'), '잠실 한강에서 Post Malone Circles 석양 힐링', 37.520600, 127.079200, ST_SetSRID(ST_MakePoint(127.079200, 37.520600), 4326), NOW()-INTERVAL '45 days', NOW()-INTERVAL '45 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='7FbrGaHYVDmfr7KoLIZnQ7'), (SELECT id FROM places WHERE place_name='송리단길'), '송리단길 핫플에서 FIFTY FIFTY Cupid 분위기', 37.511900, 127.108700, ST_SetSRID(ST_MakePoint(127.108700, 37.511900), 4326), NOW()-INTERVAL '42 days', NOW()-INTERVAL '42 days'),

-- 강동구 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='60a0Rd6pjrkxjPbaKzXjfq'), (SELECT id FROM places WHERE place_name='천호역 로데오거리'), '천호 로데오에서 Linkin Park In The End 추억 감성', 37.539100, 127.123600, ST_SetSRID(ST_MakePoint(127.123600, 37.539100), 4326), NOW()-INTERVAL '39 days', NOW()-INTERVAL '39 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='2agBDIr9MYDUducQPC1sFU'), (SELECT id FROM places WHERE place_name='암사동 유적지'), '암사동 선사 유적지에서 이루마 River Flows in You 명상', 37.551200, 127.131800, ST_SetSRID(ST_MakePoint(127.131800, 37.551200), 4326), NOW()-INTERVAL '36 days', NOW()-INTERVAL '36 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='3AJwUDP919kvQ9QcozQPxg'), (SELECT id FROM places WHERE place_name='강동그린웨이'), '강동그린웨이 자전거길에 Coldplay Yellow 감성 라이딩', 37.553400, 127.145600, ST_SetSRID(ST_MakePoint(127.145600, 37.553400), 4326), NOW()-INTERVAL '33 days', NOW()-INTERVAL '33 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='7BKLCZ1jbUBVqRi2FVlTVw'), (SELECT id FROM places WHERE place_name='광나루한강공원'), '광나루 한강에서 Chainsmokers Closer 일몰 감상', 37.547200, 127.109800, ST_SetSRID(ST_MakePoint(127.109800, 37.547200), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),

-- 중랑구·도봉구 교차 추가
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='0nrRP2bk19rLc0NV8nRBOE'), (SELECT id FROM places WHERE place_name='용마폭포공원'), '용마폭포 물소리에 Avicii Wake Me Up 에너지', 37.575400, 127.084300, ST_SetSRID(ST_MakePoint(127.084300, 37.575400), 4326), NOW()-INTERVAL '27 days', NOW()-INTERVAL '27 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='6lgczhmJUHKJbFiB2iFerF'), (SELECT id FROM places WHERE place_name='무수골 계곡'), '계곡에서 Green Day Basket Case 시원하게 듣기', 37.680300, 127.040100, ST_SetSRID(ST_MakePoint(127.040100, 37.680300), 4326), NOW()-INTERVAL '24 days', NOW()-INTERVAL '24 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='4iJyoBOLtHqaGxP12qzhQI'), (SELECT id FROM places WHERE place_name='4.19민주묘지'), '4.19묘지 산책길에 Justin Bieber Peaches 봄날', 37.647200, 127.017800, ST_SetSRID(ST_MakePoint(127.017800, 37.647200), 4326), NOW()-INTERVAL '21 days', NOW()-INTERVAL '21 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='7lQ8MOhq6IN2w8EYcFNSUk'), (SELECT id FROM places WHERE place_name='서울과학기술대학교'), '과기대 야간에 Eminem Without Me 파워 공부', 37.632040, 127.077750, ST_SetSRID(ST_MakePoint(127.077750, 37.632040), 4326), NOW()-INTERVAL '18 days', NOW()-INTERVAL '18 days'),

-- 추가 교차 조합 (다양한 장소-트랙)
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='1IHWl5LamUGEuP4ozKQSXZ'), (SELECT id FROM places WHERE place_name='이태원 거리'), '이태원 글로벌 감성에 Bad Bunny 라틴 댄스', 37.534540, 126.994360, ST_SetSRID(ST_MakePoint(126.994360, 37.534540), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyunwoo'), (SELECT id FROM tracks WHERE spotify_track_id='6habFhsceSTjwMFa8CqA8A'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 클럽 근처에서 Despacito 라틴파티 분위기', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '12 days', NOW()-INTERVAL '12 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_seoyeon'), (SELECT id FROM tracks WHERE spotify_track_id='7KXjTSCq5nL1LoYtL7XAwS'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스 지하에서 Kendrick Lamar HUMBLE 헤드뱅잉', 37.513100, 127.058200, ST_SetSRID(ST_MakePoint(127.058200, 37.513100), 4326), NOW()-INTERVAL '9 days', NOW()-INTERVAL '9 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_sohee'), (SELECT id FROM tracks WHERE spotify_track_id='5M70hy7bM7gMTKhb6mXOOe'), (SELECT id FROM places WHERE place_name='잠실야구장'), '야구장에서 ATEEZ Guerrilla 응원 에너지 MAX', 37.512200, 127.071900, ST_SetSRID(ST_MakePoint(127.071900, 37.512200), 4326), NOW()-INTERVAL '6 days', NOW()-INTERVAL '6 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_doyoon'), (SELECT id FROM tracks WHERE spotify_track_id='6n8Wk7vaBmQtGGCgirrgY8'), (SELECT id FROM places WHERE place_name='이화여자대학교'), '이대 학생회관 앞에서 10cm 폰서트 잔잔 감성', 37.562850, 126.946500, ST_SetSRID(ST_MakePoint(126.946500, 37.562850), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minjae'), (SELECT id FROM tracks WHERE spotify_track_id='0lIzj9bwmhiCSOZQMhb3LH'), (SELECT id FROM places WHERE place_name='경복궁'), '경복궁 달빛투어에 Red Velvet Psycho 몽환미 폭발', 37.579617, 126.977041, ST_SetSRID(ST_MakePoint(126.977041, 37.579617), 4326), NOW()-INTERVAL '60 days', NOW()-INTERVAL '60 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_nayeon'), (SELECT id FROM tracks WHERE spotify_track_id='2Fxmhks0bxGSBdJ92vM42m'), (SELECT id FROM places WHERE place_name='반포한강공원'), '반포 야경에 Billie Eilish bad guy 몽환 감성', 37.509600, 126.995800, ST_SetSRID(ST_MakePoint(126.995800, 37.509600), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='6b8Be6ljOzmkOmFslEb23P'), (SELECT id FROM places WHERE place_name='강남역 사거리'), '강남역 주말에 Bruno Mars 24K Magic으로 파티', 37.497942, 127.027621, ST_SetSRID(ST_MakePoint(127.027621, 37.497942), 4326), NOW()-INTERVAL '17 days', NOW()-INTERVAL '17 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jiho'), (SELECT id FROM tracks WHERE spotify_track_id='4dGJf5P2DYPq8Zxgz1XnVp'), (SELECT id FROM places WHERE place_name='석촌호수'), '석촌호수 야경에 Crush Beautiful OST 감성', 37.510700, 127.098400, ST_SetSRID(ST_MakePoint(127.098400, 37.510700), 4326), NOW()-INTERVAL '14 days', NOW()-INTERVAL '14 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hyejin'), (SELECT id FROM tracks WHERE spotify_track_id='7FbrGaHYVDmfr7KoLIZnQ7'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 피크닉에 FIFTY FIFTY Cupid 달달한 오후', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '11 days', NOW()-INTERVAL '11 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='0It6VJoMAare1sdHhQWAN8'), (SELECT id FROM places WHERE place_name='명동거리'), '명동 화장품 쇼핑하면서 EXO Love Shot 기분 업', 37.563576, 126.985820, ST_SetSRID(ST_MakePoint(126.985820, 37.563576), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_woojin'), (SELECT id FROM tracks WHERE spotify_track_id='6kL4AqU2qdEIXuFCQ10tqM'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '롯데타워에서 TWICE The Feels 쇼핑 BGM', 37.512600, 127.102500, ST_SetSRID(ST_MakePoint(127.102500, 37.512600), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='2Foc5Q5nqNiosCNqttzHof'), (SELECT id FROM places WHERE place_name='DDP 동대문디자인플라자'), 'DDP 앞에서 Daft Punk Get Lucky 일렉트로 감성', 37.567030, 127.009520, ST_SetSRID(ST_MakePoint(127.009520, 37.567030), 4326), NOW()-INTERVAL '2 days', NOW()-INTERVAL '2 days')
ON CONFLICT DO NOTHING;


-- =============================================
-- BATCH 3: Additional Reaction Likes
-- =============================================

-- 경복궁 (G)I-DLE TOMBOY
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 야간개장에서 (G)I-DLE TOMBOY 텐션' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 야간개장에서 (G)I-DLE TOMBOY 텐션' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 야간개장에서 (G)I-DLE TOMBOY 텐션' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 북촌 AKMU
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😊', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='북촌 골목길에 AKMU 200% 흥겨움이 번짐' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='북촌 골목길에 AKMU 200% 흥겨움이 번짐' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- 인사동 10cm
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😭', NOW()-INTERVAL '48 days' FROM recommendations r CROSS JOIN users u WHERE r.message='쌈지길 3층 테라스에서 10cm 폰서트 들으면 눈물' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='쌈지길 3층 테라스에서 10cm 폰서트 들으면 눈물' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='쌈지길 3층 테라스에서 10cm 폰서트 들으면 눈물' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 광화문 Save Your Tears
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='광화문 분수 앞에서 Save Your Tears 멜로 감성' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💜', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='광화문 분수 앞에서 Save Your Tears 멜로 감성' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- 창덕궁 Crush Beautiful
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='창덕궁 후원에서 Crush Beautiful 감동 두 배' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌸', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='창덕궁 후원에서 Crush Beautiful 감동 두 배' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;

-- 명동 Lady Gaga
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 네온사인 아래서 Lady Gaga Bad Romance' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 네온사인 아래서 Lady Gaga Bad Romance' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='명동 네온사인 아래서 Lady Gaga Bad Romance' AND u.spotify_id='spotify_user_minjae' ON CONFLICT DO NOTHING;

-- DDP aespa
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 미래건축 앞에서 aespa Next Level 찰떡' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💜', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 미래건축 앞에서 aespa Next Level 찰떡' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;

-- 을지로 DEAN
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 공구 골목에서 DEAN instagram 감성' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='힙지로 공구 골목에서 DEAN instagram 감성' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;

-- N서울타워 Frank Ocean
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='남산타워 꼭대기에서 Frank Ocean Thinkin Bout You 로맨틱' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌙', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='남산타워 꼭대기에서 Frank Ocean Thinkin Bout You 로맨틱' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='남산타워 꼭대기에서 Frank Ocean Thinkin Bout You 로맨틱' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 이태원 Jay Park
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원 밤거리에서 Jay Park MOMMAE 분위기 미쳤다' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '49 days' FROM recommendations r CROSS JOIN users u WHERE r.message='이태원 밤거리에서 Jay Park MOMMAE 분위기 미쳤다' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- 국립중앙박물관 Daniel Caesar
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='박물관 정원에서 Daniel Caesar Best Part 로맨스' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='박물관 정원에서 Daniel Caesar Best Part 로맨스' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;

-- 서울숲 Arctic Monkeys
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎸', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 벤치에서 Arctic Monkeys 인디 감성 폭발' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 벤치에서 Arctic Monkeys 인디 감성 폭발' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 벤치에서 Arctic Monkeys 인디 감성 폭발' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;

-- 성수 카페 TXT
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💜', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수 카페 호핑하면서 TXT Sugar Rush Ride 기분' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수 카페 호핑하면서 TXT Sugar Rush Ride 기분' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- 성수연방 Post Malone
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌅', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수연방 옥상에서 Post Malone Circles 석양 감상' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '39 days' FROM recommendations r CROSS JOIN users u WHERE r.message='성수연방 옥상에서 Post Malone Circles 석양 감상' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;

-- 어니언 Ariana Grande
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '37 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵과 Ariana Grande 7 rings 럭셔리 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💎', NOW()-INTERVAL '36 days' FROM recommendations r CROSS JOIN users u WHERE r.message='어니언 빵과 Ariana Grande 7 rings 럭셔리 감성' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 커먼그라운드 Chainsmokers
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '56 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 Chainsmokers Closer 불금' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 Chainsmokers Closer 불금' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 Chainsmokers Closer 불금' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- 경희대 Imagine Dragons
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경희대 평화의전당 앞에서 Imagine Dragons Believer' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경희대 평화의전당 앞에서 Imagine Dragons Believer' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;

-- 고려대 Fujii Kaze
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='고대 중앙광장에서 Fujii Kaze 일본 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌊', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='고대 중앙광장에서 Fujii Kaze 일본 감성' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- 북한산 Linkin Park
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='북한산 등산 중 Linkin Park In The End 파이팅' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '44 days' FROM recommendations r CROSS JOIN users u WHERE r.message='북한산 등산 중 Linkin Park In The End 파이팅' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎸', NOW()-INTERVAL '43 days' FROM recommendations r CROSS JOIN users u WHERE r.message='북한산 등산 중 Linkin Park In The End 파이팅' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;

-- 도봉산 Nirvana
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎸', NOW()-INTERVAL '42 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도봉산 가는 길에 Nirvana Smells Like Teen Spirit' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도봉산 가는 길에 Nirvana Smells Like Teen Spirit' AND u.spotify_id='spotify_user_minjae' ON CONFLICT DO NOTHING;

-- 은평한옥마을 Billie Eilish
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '33 days' FROM recommendations r CROSS JOIN users u WHERE r.message='은평한옥마을 조용한 밤에 Billie Eilish bad guy 반전매력' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🖤', NOW()-INTERVAL '32 days' FROM recommendations r CROSS JOIN users u WHERE r.message='은평한옥마을 조용한 밤에 Billie Eilish bad guy 반전매력' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 연대 Drake
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '27 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연대 백양로에서 Drake Hotline Bling 힙하게' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📱', NOW()-INTERVAL '26 days' FROM recommendations r CROSS JOIN users u WHERE r.message='연대 백양로에서 Drake Hotline Bling 힙하게' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;

-- 홍대 Bad Bunny
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '57 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 거리에서 Bad Bunny 라틴 바이브' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '56 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 거리에서 Bad Bunny 라틴 바이브' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 버스킹 거리에서 Bad Bunny 라틴 바이브' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- 망원한강 Despacito
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☀️', NOW()-INTERVAL '48 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한강 피크닉에 Despacito 라틴 감성 여름 바이브' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한강 피크닉에 Despacito 라틴 감성 여름 바이브' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;

-- 상수역 Crush Beautiful
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='독서 후 Crush Beautiful 들으면 마음이 따뜻해짐' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📚', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='독서 후 Crush Beautiful 들으면 마음이 따뜻해짐' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;

-- 여의도 Avicii
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 불꽃축제에 Avicii Wake Me Up 축제 기분' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎆', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 불꽃축제에 Avicii Wake Me Up 축제 기분' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='여의도 불꽃축제에 Avicii Wake Me Up 축제 기분' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 63빌딩 EXO
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='63빌딩 전망대에서 EXO Love Shot 시티팝 느낌' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='63빌딩 전망대에서 EXO Love Shot 시티팝 느낌' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;

-- 강남역 Kanye
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '56 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역 불금에 Kanye West Stronger 시작' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역 불금에 Kanye West Stronger 시작' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '54 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역 불금에 Kanye West Stronger 시작' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- 반포한강공원 Dua Lipa
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 달빛무지개 분수에 Dua Lipa Don''t Start Now' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌈', NOW()-INTERVAL '49 days' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 달빛무지개 분수에 Dua Lipa Don''t Start Now' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;

-- 예술의전당 카논
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎻', NOW()-INTERVAL '47 days' FROM recommendations r CROSS JOIN users u WHERE r.message='예술의전당 공연 전 카논 들으며 기다리는 설렘' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '46 days' FROM recommendations r CROSS JOIN users u WHERE r.message='예술의전당 공연 전 카논 들으며 기다리는 설렘' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '45 days' FROM recommendations r CROSS JOIN users u WHERE r.message='예술의전당 공연 전 카논 들으며 기다리는 설렘' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;

-- 코엑스 Drake
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '58 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당 도서관에서 Drake Hotline Bling' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '📱', NOW()-INTERVAL '57 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 별마당 도서관에서 Drake Hotline Bling' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;

-- 가로수길 Frank Ocean
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '49 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가로수길 걸으면서 Frank Ocean Thinkin Bout You 감성' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '48 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가로수길 걸으면서 Frank Ocean Thinkin Bout You 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- 석촌호수 TXT
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌸', NOW()-INTERVAL '59 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃길에 TXT Sugar Rush Ride 봄 감성' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '58 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃길에 TXT Sugar Rush Ride 봄 감성' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💜', NOW()-INTERVAL '57 days' FROM recommendations r CROSS JOIN users u WHERE r.message='석촌호수 벚꽃길에 TXT Sugar Rush Ride 봄 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- 롯데월드타워 Red Velvet
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '56 days' FROM recommendations r CROSS JOIN users u WHERE r.message='롯데타워 전망대에서 Red Velvet Psycho 도시 야경' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '55 days' FROM recommendations r CROSS JOIN users u WHERE r.message='롯데타워 전망대에서 Red Velvet Psycho 도시 야경' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- 올림픽공원 Daft Punk
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '53 days' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원 잔디밭에서 Daft Punk Get Lucky 여유' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '☀️', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='올림픽공원 잔디밭에서 Daft Punk Get Lucky 여유' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 잠실야구장 BTS Butter
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원하면서 BTS Butter 떼창 분위기' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚾', NOW()-INTERVAL '49 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원하면서 BTS Butter 떼창 분위기' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '48 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구 응원하면서 BTS Butter 떼창 분위기' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;

-- 송리단길 FIFTY FIFTY
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '41 days' FROM recommendations r CROSS JOIN users u WHERE r.message='송리단길 핫플에서 FIFTY FIFTY Cupid 분위기' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='송리단길 핫플에서 FIFTY FIFTY Cupid 분위기' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;

-- 천호역 Linkin Park
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎸', NOW()-INTERVAL '38 days' FROM recommendations r CROSS JOIN users u WHERE r.message='천호 로데오에서 Linkin Park In The End 추억 감성' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '37 days' FROM recommendations r CROSS JOIN users u WHERE r.message='천호 로데오에서 Linkin Park In The End 추억 감성' AND u.spotify_id='spotify_user_minjae' ON CONFLICT DO NOTHING;

-- 암사동 유적지 이루마
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎹', NOW()-INTERVAL '35 days' FROM recommendations r CROSS JOIN users u WHERE r.message='암사동 선사 유적지에서 이루마 River Flows in You 명상' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '34 days' FROM recommendations r CROSS JOIN users u WHERE r.message='암사동 선사 유적지에서 이루마 River Flows in You 명상' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '33 days' FROM recommendations r CROSS JOIN users u WHERE r.message='암사동 선사 유적지에서 이루마 River Flows in You 명상' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;

-- 노량진 Imagine Dragons
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💪', NOW()-INTERVAL '40 days' FROM recommendations r CROSS JOIN users u WHERE r.message='노량진 활기에 Imagine Dragons Believer 의지' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '39 days' FROM recommendations r CROSS JOIN users u WHERE r.message='노량진 활기에 Imagine Dragons Believer 의지' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;

-- 서울대 DEAN
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '28 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울대 샤로수길에서 DEAN instagram 힙한 저녁' AND u.spotify_id='spotify_user_doyoon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '27 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울대 샤로수길에서 DEAN instagram 힙한 저녁' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- 코엑스 Kendrick
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '8 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 지하에서 Kendrick Lamar HUMBLE 헤드뱅잉' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스 지하에서 Kendrick Lamar HUMBLE 헤드뱅잉' AND u.spotify_id='spotify_user_junho' ON CONFLICT DO NOTHING;

-- 잠실야구장 ATEEZ
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚾', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구장에서 ATEEZ Guerrilla 응원 에너지 MAX' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구장에서 ATEEZ Guerrilla 응원 에너지 MAX' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='야구장에서 ATEEZ Guerrilla 응원 에너지 MAX' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;

-- 이대 10cm
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='이대 학생회관 앞에서 10cm 폰서트 잔잔 감성' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😭', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='이대 학생회관 앞에서 10cm 폰서트 잔잔 감성' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;

-- 압구정 Lady Gaga
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '52 days' FROM recommendations r CROSS JOIN users u WHERE r.message='압구정에서 Lady Gaga Bad Romance 패션쇼 느낌' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '51 days' FROM recommendations r CROSS JOIN users u WHERE r.message='압구정에서 Lady Gaga Bad Romance 패션쇼 느낌' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💎', NOW()-INTERVAL '50 days' FROM recommendations r CROSS JOIN users u WHERE r.message='압구정에서 Lady Gaga Bad Romance 패션쇼 느낌' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;

-- 도산공원 Daniel Caesar
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '37 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도산공원 벤치에서 Daniel Caesar Best Part 감성' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '36 days' FROM recommendations r CROSS JOIN users u WHERE r.message='도산공원 벤치에서 Daniel Caesar Best Part 감성' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- 경복궁 Red Velvet (최신)
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '59 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 달빛투어에 Red Velvet Psycho 몽환미 폭발' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💜', NOW()-INTERVAL '58 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 달빛투어에 Red Velvet Psycho 몽환미 폭발' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '57 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경복궁 달빛투어에 Red Velvet Psycho 몽환미 폭발' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;

-- 반포 Billie Eilish
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌙', NOW()-INTERVAL '19 days' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 야경에 Billie Eilish bad guy 몽환 감성' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🖤', NOW()-INTERVAL '18 days' FROM recommendations r CROSS JOIN users u WHERE r.message='반포 야경에 Billie Eilish bad guy 몽환 감성' AND u.spotify_id='spotify_user_hyejin' ON CONFLICT DO NOTHING;

-- 강남역 Bruno Mars
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '16 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역 주말에 Bruno Mars 24K Magic으로 파티' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '15 days' FROM recommendations r CROSS JOIN users u WHERE r.message='강남역 주말에 Bruno Mars 24K Magic으로 파티' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- DDP Daft Punk
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 앞에서 Daft Punk Get Lucky 일렉트로 감성' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 앞에서 Daft Punk Get Lucky 일렉트로 감성' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💃', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='DDP 앞에서 Daft Punk Get Lucky 일렉트로 감성' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- =============================================
-- BATCH 4: J-Pop Tracks 추가
-- =============================================

INSERT INTO tracks (spotify_track_id, title, artist, album, album_cover_url, track_url, preview_url, genres, created_at, updated_at) VALUES
('6MCjWGwHt1bMY350SEGSIa', 'Lemon', '米津玄師 (Kenshi Yonezu)', 'BOOTLEG', 'https://i.scdn.co/image/ab67616d0000b2730a2c15c78e27367a14b0e1a2', 'https://open.spotify.com/track/6MCjWGwHt1bMY350SEGSIa', NULL, '{J-Pop}', NOW(), NOW()),
('2ksyzVfU0WPbCjICWMPJEE', '紅蓮華 (Gurenge)', 'LiSA', '紅蓮華', 'https://i.scdn.co/image/ab67616d0000b27376ff8e52f8f3b7f8b1e2e0a1', 'https://open.spotify.com/track/2ksyzVfU0WPbCjICWMPJEE', NULL, '{J-Pop,Anime,J-Rock}', NOW(), NOW()),
('50nfwHmKT4dJ3zzSKGaOjN', 'KICK BACK', '米津玄師 (Kenshi Yonezu)', 'KICK BACK', 'https://i.scdn.co/image/ab67616d0000b273363184e8bfa47a161e3a9faa', 'https://open.spotify.com/track/50nfwHmKT4dJ3zzSKGaOjN', NULL, '{J-Pop,Anime}', NOW(), NOW()),
('7BY005dacJkbO6EPiOh2wb', '新時代 (New Genesis)', 'Ado', 'ウタの歌 ONE PIECE FILM RED', 'https://i.scdn.co/image/ab67616d0000b273cbf89be3fc2dc84b1468e13f', 'https://open.spotify.com/track/7BY005dacJkbO6EPiOh2wb', NULL, '{J-Pop,Anime}', NOW(), NOW()),
('17XPUJv3RQGF4ePJjdBfIv', 'Pretender', 'Official髭男dism', 'Traveler', 'https://i.scdn.co/image/ab67616d0000b273b36949bee43217351ebbabc1', 'https://open.spotify.com/track/17XPUJv3RQGF4ePJjdBfIv', NULL, '{J-Pop,J-Rock}', NOW(), NOW()),
('0tHjkiOiNZeNgzGbhCSucP', 'マリーゴールド (Marigold)', 'あいみょん (Aimyon)', 'おいしいパスタがあると聞いて', 'https://i.scdn.co/image/ab67616d0000b27390e4a8042c6b0e5e89c8e6a4', 'https://open.spotify.com/track/0tHjkiOiNZeNgzGbhCSucP', NULL, '{J-Pop,J-Indie}', NOW(), NOW())
ON CONFLICT (spotify_track_id) DO NOTHING;

-- J-Pop Recommendations
INSERT INTO recommendations (user_id, track_id, place_id, message, lat, lng, geom, created_at, updated_at) VALUES
((SELECT id FROM users WHERE spotify_id='spotify_user_taehyung'), (SELECT id FROM tracks WHERE spotify_track_id='6MCjWGwHt1bMY350SEGSIa'), (SELECT id FROM places WHERE place_name='서울숲'), '서울숲 가을 낙엽에 요네즈 켄시 Lemon 감성 터짐', 37.544540, 127.037700, ST_SetSRID(ST_MakePoint(127.037700, 37.544540), 4326), NOW()-INTERVAL '35 days', NOW()-INTERVAL '35 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_yuna'), (SELECT id FROM tracks WHERE spotify_track_id='2ksyzVfU0WPbCjICWMPJEE'), (SELECT id FROM places WHERE place_name='건대입구 커먼그라운드'), '커먼그라운드에서 LiSA 구렌게 들으면 텐션 MAX', 37.542470, 127.068100, ST_SetSRID(ST_MakePoint(127.068100, 37.542470), 4326), NOW()-INTERVAL '30 days', NOW()-INTERVAL '30 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_siwoo'), (SELECT id FROM tracks WHERE spotify_track_id='50nfwHmKT4dJ3zzSKGaOjN'), (SELECT id FROM places WHERE place_name='홍익대학교'), '홍대 거리에서 체인소맨 KICK BACK 헤드뱅잉', 37.550970, 126.925620, ST_SetSRID(ST_MakePoint(126.925620, 37.550970), 4326), NOW()-INTERVAL '25 days', NOW()-INTERVAL '25 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_chaewon'), (SELECT id FROM tracks WHERE spotify_track_id='7BY005dacJkbO6EPiOh2wb'), (SELECT id FROM places WHERE place_name='코엑스몰'), '코엑스에서 Ado 신시대 들으면 원피스 세계관 돌입', 37.513100, 127.058200, ST_SetSRID(ST_MakePoint(127.058200, 37.513100), 4326), NOW()-INTERVAL '20 days', NOW()-INTERVAL '20 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_jieun'), (SELECT id FROM tracks WHERE spotify_track_id='17XPUJv3RQGF4ePJjdBfIv'), (SELECT id FROM places WHERE place_name='경의선숲길'), '경의선숲길 산책에 히게단 Pretender 잔잔 감성', 37.544900, 126.913200, ST_SetSRID(ST_MakePoint(126.913200, 37.544900), 4326), NOW()-INTERVAL '15 days', NOW()-INTERVAL '15 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minsu'), (SELECT id FROM tracks WHERE spotify_track_id='0tHjkiOiNZeNgzGbhCSucP'), (SELECT id FROM places WHERE place_name='선유도공원'), '선유도 석양에 아이묭 마리골드 들으면 일본 여행 온 기분', 37.541700, 126.899700, ST_SetSRID(ST_MakePoint(126.899700, 37.541700), 4326), NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_minji'), (SELECT id FROM tracks WHERE spotify_track_id='6MCjWGwHt1bMY350SEGSIa'), (SELECT id FROM places WHERE place_name='북촌한옥마을'), '한옥마을에서 Lemon 들으니 묘하게 일본 감성과 한국 감성이 만남', 37.582604, 126.983880, ST_SetSRID(ST_MakePoint(126.983880, 37.582604), 4326), NOW()-INTERVAL '5 days', NOW()-INTERVAL '5 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_donghyun'), (SELECT id FROM tracks WHERE spotify_track_id='2ksyzVfU0WPbCjICWMPJEE'), (SELECT id FROM places WHERE place_name='월드컵경기장'), '월드컵경기장에서 구렌게 들으면 전집중 응원', 37.568330, 126.897200, ST_SetSRID(ST_MakePoint(126.897200, 37.568330), 4326), NOW()-INTERVAL '3 days', NOW()-INTERVAL '3 days'),
((SELECT id FROM users WHERE spotify_id='spotify_user_hayoung'), (SELECT id FROM tracks WHERE spotify_track_id='7BY005dacJkbO6EPiOh2wb'), (SELECT id FROM places WHERE place_name='롯데월드타워'), '롯데타워 전망대에서 Ado 신시대 들으면 새로운 세계', 37.512600, 127.102500, ST_SetSRID(ST_MakePoint(127.102500, 37.512600), 4326), NOW()-INTERVAL '1 day', NOW()-INTERVAL '1 day'),
((SELECT id FROM users WHERE spotify_id='spotify_user_eunji'), (SELECT id FROM tracks WHERE spotify_track_id='17XPUJv3RQGF4ePJjdBfIv'), (SELECT id FROM places WHERE place_name='가로수길'), '가로수길 카페에서 Pretender 듣다가 전 애인 생각남', 37.521700, 127.023200, ST_SetSRID(ST_MakePoint(127.023200, 37.521700), 4326), NOW()-INTERVAL '8 days', NOW()-INTERVAL '8 days')
ON CONFLICT DO NOTHING;

-- J-Pop Reaction Likes
-- Lemon @ 서울숲
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🍋', NOW()-INTERVAL '34 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 가을 낙엽에 요네즈 켄시 Lemon 감성 터짐' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '33 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 가을 낙엽에 요네즈 켄시 Lemon 감성 터짐' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '32 days' FROM recommendations r CROSS JOIN users u WHERE r.message='서울숲 가을 낙엽에 요네즈 켄시 Lemon 감성 터짐' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- Gurenge @ 커먼그라운드
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '29 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 LiSA 구렌게 들으면 텐션 MAX' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚔️', NOW()-INTERVAL '28 days' FROM recommendations r CROSS JOIN users u WHERE r.message='커먼그라운드에서 LiSA 구렌게 들으면 텐션 MAX' AND u.spotify_id='spotify_user_donghyun' ON CONFLICT DO NOTHING;

-- KICK BACK @ 홍대
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '24 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 체인소맨 KICK BACK 헤드뱅잉' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎸', NOW()-INTERVAL '23 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 체인소맨 KICK BACK 헤드뱅잉' AND u.spotify_id='spotify_user_jiho' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '22 days' FROM recommendations r CROSS JOIN users u WHERE r.message='홍대 거리에서 체인소맨 KICK BACK 헤드뱅잉' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;

-- Ado 신시대 @ 코엑스
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '19 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스에서 Ado 신시대 들으면 원피스 세계관 돌입' AND u.spotify_id='spotify_user_hyunwoo' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🏴‍☠️', NOW()-INTERVAL '18 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스에서 Ado 신시대 들으면 원피스 세계관 돌입' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '17 days' FROM recommendations r CROSS JOIN users u WHERE r.message='코엑스에서 Ado 신시대 들으면 원피스 세계관 돌입' AND u.spotify_id='spotify_user_eunji' ON CONFLICT DO NOTHING;

-- Pretender @ 경의선숲길
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😭', NOW()-INTERVAL '14 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길 산책에 히게단 Pretender 잔잔 감성' AND u.spotify_id='spotify_user_seoyeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '13 days' FROM recommendations r CROSS JOIN users u WHERE r.message='경의선숲길 산책에 히게단 Pretender 잔잔 감성' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 마리골드 @ 선유도
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌻', NOW()-INTERVAL '9 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 아이묭 마리골드 들으면 일본 여행 온 기분' AND u.spotify_id='spotify_user_hayoung' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '8 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 아이묭 마리골드 들으면 일본 여행 온 기분' AND u.spotify_id='spotify_user_yuna' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌅', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='선유도 석양에 아이묭 마리골드 들으면 일본 여행 온 기분' AND u.spotify_id='spotify_user_taehyung' ON CONFLICT DO NOTHING;

-- Lemon @ 북촌
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🍋', NOW()-INTERVAL '4 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한옥마을에서 Lemon 들으니 묘하게 일본 감성과 한국 감성이 만남' AND u.spotify_id='spotify_user_jieun' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '❤️', NOW()-INTERVAL '3 days' FROM recommendations r CROSS JOIN users u WHERE r.message='한옥마을에서 Lemon 들으니 묘하게 일본 감성과 한국 감성이 만남' AND u.spotify_id='spotify_user_sohee' ON CONFLICT DO NOTHING;

-- 구렌게 @ 월드컵경기장
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '⚔️', NOW()-INTERVAL '2 days' FROM recommendations r CROSS JOIN users u WHERE r.message='월드컵경기장에서 구렌게 들으면 전집중 응원' AND u.spotify_id='spotify_user_woojin' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '1 day' FROM recommendations r CROSS JOIN users u WHERE r.message='월드컵경기장에서 구렌게 들으면 전집중 응원' AND u.spotify_id='spotify_user_siwoo' ON CONFLICT DO NOTHING;

-- Ado @ 롯데월드타워
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🌃', NOW()-INTERVAL '12 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='롯데타워 전망대에서 Ado 신시대 들으면 새로운 세계' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🔥', NOW()-INTERVAL '6 hours' FROM recommendations r CROSS JOIN users u WHERE r.message='롯데타워 전망대에서 Ado 신시대 들으면 새로운 세계' AND u.spotify_id='spotify_user_minji' ON CONFLICT DO NOTHING;

-- Pretender @ 가로수길
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '💔', NOW()-INTERVAL '7 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가로수길 카페에서 Pretender 듣다가 전 애인 생각남' AND u.spotify_id='spotify_user_chaewon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '😭', NOW()-INTERVAL '6 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가로수길 카페에서 Pretender 듣다가 전 애인 생각남' AND u.spotify_id='spotify_user_nayeon' ON CONFLICT DO NOTHING;
INSERT INTO recommendation_likes (recommendation_id, user_id, emoji, created_at)
SELECT r.id, u.id, '🎵', NOW()-INTERVAL '5 days' FROM recommendations r CROSS JOIN users u WHERE r.message='가로수길 카페에서 Pretender 듣다가 전 애인 생각남' AND u.spotify_id='spotify_user_minsu' ON CONFLICT DO NOTHING;
