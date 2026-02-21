"""Add profile_image and status_message to users

Revision ID: 004
Revises: 003
Create Date: 2026-02-22 00:00:00.000000

"""
import random
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.sql import table, column


# revision identifiers, used by Alembic.
revision: str = '004'
down_revision: Union[str, None] = '003'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add profile_image column with a temporary default
    op.add_column('users', sa.Column('profile_image', sa.Integer(), nullable=False, server_default='1'))
    # Add status_message column with empty string default
    op.add_column('users', sa.Column('status_message', sa.String(20), nullable=False, server_default=''))

    # Assign random profile_image (1-9) to existing users
    users_table = table('users', column('id', sa.Integer), column('profile_image', sa.Integer))
    conn = op.get_bind()
    rows = conn.execute(sa.select(users_table.c.id)).fetchall()
    for row in rows:
        conn.execute(
            users_table.update()
            .where(users_table.c.id == row[0])
            .values(profile_image=random.randint(1, 9))
        )

    # Remove server_default for profile_image (app handles default via Python)
    op.alter_column('users', 'profile_image', server_default=None)


def downgrade() -> None:
    op.drop_column('users', 'status_message')
    op.drop_column('users', 'profile_image')
