-- Database schema for Soundmark
-- Auto-generated from Alembic migration for Docker init

-- ========================================
-- 1. Users Table
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    spotify_id VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(255),
    email VARCHAR(255),
    profile_image INTEGER NOT NULL DEFAULT 1,
    status_message VARCHAR(20) NOT NULL DEFAULT '',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_users_id ON users (id);
CREATE INDEX IF NOT EXISTS ix_users_spotify_id ON users (spotify_id);

-- ========================================
-- 2. OAuth Accounts Table
-- ========================================
CREATE TABLE IF NOT EXISTS oauth_accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    expires_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_oauth_accounts_id ON oauth_accounts (id);

-- ========================================
-- 3. Tracks Table
-- ========================================
CREATE TABLE IF NOT EXISTS tracks (
    id SERIAL PRIMARY KEY,
    spotify_track_id VARCHAR(255) NOT NULL UNIQUE,
    title VARCHAR(512) NOT NULL,
    artist VARCHAR(512) NOT NULL,
    album VARCHAR(512),
    album_cover_url TEXT,
    track_url TEXT,
    preview_url TEXT,
    genres VARCHAR[] DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_tracks_id ON tracks (id);
CREATE INDEX IF NOT EXISTS ix_tracks_spotify_track_id ON tracks (spotify_track_id);

-- ========================================
-- 4. Places Table (with PostGIS geometry)
-- ========================================
CREATE TABLE IF NOT EXISTS places (
    id SERIAL PRIMARY KEY,
    google_place_id VARCHAR(255) UNIQUE,
    place_name VARCHAR(512) NOT NULL,
    address TEXT,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_places_id ON places (id);
CREATE INDEX IF NOT EXISTS ix_places_google_place_id ON places (google_place_id);

-- ========================================
-- 5. Recommendations Table (with PostGIS geometry)
-- ========================================
CREATE TABLE IF NOT EXISTS recommendations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    place_id INTEGER REFERENCES places(id) ON DELETE SET NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    geom GEOMETRY(POINT, 4326) NOT NULL,
    message VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS ix_recommendations_id ON recommendations (id);
CREATE INDEX IF NOT EXISTS ix_recommendations_user_id ON recommendations (user_id);
CREATE INDEX IF NOT EXISTS ix_recommendations_track_id ON recommendations (track_id);
CREATE INDEX IF NOT EXISTS ix_recommendations_created_at ON recommendations (created_at);

-- Create GIST index for spatial queries (PostGIS)
CREATE INDEX IF NOT EXISTS idx_recommendations_geom ON recommendations USING GIST (geom);

-- ========================================
-- 6. Recommendation Likes Table
-- ========================================
CREATE TABLE IF NOT EXISTS recommendation_likes (
    id SERIAL PRIMARY KEY,
    recommendation_id INTEGER NOT NULL REFERENCES recommendations(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    emoji VARCHAR(50) NOT NULL DEFAULT '❤️',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(recommendation_id, user_id)
);

CREATE INDEX IF NOT EXISTS ix_recommendation_likes_id ON recommendation_likes (id);
CREATE INDEX IF NOT EXISTS ix_recommendation_likes_recommendation_id ON recommendation_likes (recommendation_id);
CREATE INDEX IF NOT EXISTS ix_recommendation_likes_user_id ON recommendation_likes (user_id);

-- ========================================
-- 7. Follows Table
-- ========================================
CREATE TABLE IF NOT EXISTS follows (
    id SERIAL PRIMARY KEY,
    follower_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

CREATE INDEX IF NOT EXISTS ix_follows_id ON follows (id);
CREATE INDEX IF NOT EXISTS ix_follows_follower_id ON follows (follower_id);
CREATE INDEX IF NOT EXISTS ix_follows_following_id ON follows (following_id);

-- ========================================
-- 8. Refresh Tokens Table (JWT refresh tokens)
-- ========================================
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id SERIAL PRIMARY KEY,
    token VARCHAR NOT NULL UNIQUE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at TIMESTAMP NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS ix_refresh_tokens_id ON refresh_tokens (id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_refresh_tokens_token ON refresh_tokens (token);
