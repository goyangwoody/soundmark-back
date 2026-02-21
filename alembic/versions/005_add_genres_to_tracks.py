"""Add genres column to tracks table

Revision ID: 005
Revises: 004
Create Date: 2026-02-22 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import ARRAY


# revision identifiers, used by Alembic.
revision: str = '005'
down_revision: Union[str, None] = '004'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'tracks',
        sa.Column('genres', ARRAY(sa.String()), nullable=True, server_default='{}')
    )


def downgrade() -> None:
    op.drop_column('tracks', 'genres')
