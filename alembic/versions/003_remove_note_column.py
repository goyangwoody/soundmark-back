"""Remove note column from recommendations

Revision ID: 003
Revises: 002
Create Date: 2026-02-22 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '003'
down_revision: Union[str, None] = '002'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_column('recommendations', 'note')


def downgrade() -> None:
    op.add_column('recommendations', sa.Column('note', sa.Text(), nullable=True))
