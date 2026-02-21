"""Initial schema with PostGIS support

Revision ID: 001
Revises: 
Create Date: 2026-02-20 12:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
import geoalchemy2


# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Enable PostGIS extension
    op.execute('CREATE EXTENSION IF NOT EXISTS postgis')
    
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('spotify_id', sa.String(length=255), nullable=False),
        sa.Column('display_name', sa.String(length=255), nullable=True),
        sa.Column('email', sa.String(length=255), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)
    op.create_index(op.f('ix_users_spotify_id'), 'users', ['spotify_id'], unique=True)
    
    # Create oauth_accounts table
    op.create_table(
        'oauth_accounts',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('provider', sa.String(length=50), nullable=False),
        sa.Column('access_token', sa.Text(), nullable=False),
        sa.Column('refresh_token', sa.Text(), nullable=True),
        sa.Column('expires_at', sa.DateTime(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_oauth_accounts_id'), 'oauth_accounts', ['id'], unique=False)
    
    # Create tracks table
    op.create_table(
        'tracks',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('spotify_track_id', sa.String(length=255), nullable=False),
        sa.Column('title', sa.String(length=512), nullable=False),
        sa.Column('artist', sa.String(length=512), nullable=False),
        sa.Column('album', sa.String(length=512), nullable=True),
        sa.Column('album_cover_url', sa.Text(), nullable=True),
        sa.Column('track_url', sa.Text(), nullable=True),
        sa.Column('preview_url', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_tracks_id'), 'tracks', ['id'], unique=False)
    op.create_index(op.f('ix_tracks_spotify_track_id'), 'tracks', ['spotify_track_id'], unique=True)
    
    # Create places table with PostGIS geometry
    op.create_table(
        'places',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('google_place_id', sa.String(length=255), nullable=True),
        sa.Column('place_name', sa.String(length=512), nullable=False),
        sa.Column('address', sa.Text(), nullable=True),
        sa.Column('lat', sa.Float(), nullable=False),
        sa.Column('lng', sa.Float(), nullable=False),
        sa.Column('geom', geoalchemy2.types.Geometry(
            geometry_type='POINT', 
            srid=4326,
            from_text='ST_GeomFromEWKT',
            name='geometry'
        ), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_places_id'), 'places', ['id'], unique=False)
    op.create_index(op.f('ix_places_google_place_id'), 'places', ['google_place_id'], unique=True)
    
    # Create recommendations table with PostGIS geometry
    op.create_table(
        'recommendations',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('track_id', sa.Integer(), nullable=False),
        sa.Column('place_id', sa.Integer(), nullable=True),
        sa.Column('lat', sa.Float(), nullable=False),
        sa.Column('lng', sa.Float(), nullable=False),
        sa.Column('geom', geoalchemy2.types.Geometry(
            geometry_type='POINT',
            srid=4326,
            from_text='ST_GeomFromEWKT',
            name='geometry'
        ), nullable=False),
        sa.Column('message', sa.String(length=500), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('deleted_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['place_id'], ['places.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['track_id'], ['tracks.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_recommendations_id'), 'recommendations', ['id'], unique=False)
    op.create_index(op.f('ix_recommendations_user_id'), 'recommendations', ['user_id'], unique=False)
    op.create_index(op.f('ix_recommendations_track_id'), 'recommendations', ['track_id'], unique=False)
    op.create_index(op.f('ix_recommendations_created_at'), 'recommendations', ['created_at'], unique=False)
    
    # Create GIST index for spatial queries
    op.execute('CREATE INDEX IF NOT EXISTS idx_recommendations_geom ON recommendations USING GIST (geom)')
    
    # Create recommendation_likes table
    op.create_table(
        'recommendation_likes',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('recommendation_id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('emoji', sa.String(length=50), nullable=False, server_default='❤️'),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['recommendation_id'], ['recommendations.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('recommendation_id', 'user_id', name='unique_recommendation_user_like')
    )
    op.create_index(op.f('ix_recommendation_likes_id'), 'recommendation_likes', ['id'], unique=False)
    op.create_index(op.f('ix_recommendation_likes_recommendation_id'), 'recommendation_likes', ['recommendation_id'], unique=False)
    op.create_index(op.f('ix_recommendation_likes_user_id'), 'recommendation_likes', ['user_id'], unique=False)
    
    # Create follows table
    op.create_table(
        'follows',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('follower_id', sa.Integer(), nullable=False),
        sa.Column('following_id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['follower_id'], ['users.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['following_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('follower_id', 'following_id', name='unique_follower_following')
    )
    op.create_index(op.f('ix_follows_id'), 'follows', ['id'], unique=False)
    op.create_index(op.f('ix_follows_follower_id'), 'follows', ['follower_id'], unique=False)
    op.create_index(op.f('ix_follows_following_id'), 'follows', ['following_id'], unique=False)


def downgrade() -> None:
    # Drop tables in reverse order
    op.drop_table('follows')
    op.drop_table('recommendation_likes')
    op.drop_table('recommendations')
    op.drop_table('places')
    op.drop_table('tracks')
    op.drop_table('oauth_accounts')
    op.drop_table('users')
    
    # Note: We don't drop PostGIS extension as it might be used by other schemas
