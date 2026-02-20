"""
Recommendation Like model - stores like relationships for recommendations
"""
from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class RecommendationLike(Base):
    __tablename__ = "recommendation_likes"
    
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    recommendation_id: Mapped[int] = mapped_column(
        ForeignKey("recommendations.id", ondelete="CASCADE"), 
        nullable=False,
        index=True
    )
    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Relationships
    recommendation: Mapped["Recommendation"] = relationship("Recommendation", back_populates="likes")
    user: Mapped["User"] = relationship("User", back_populates="likes")
    
    # Ensure one user can only like a recommendation once
    __table_args__ = (
        UniqueConstraint('recommendation_id', 'user_id', name='unique_recommendation_user_like'),
    )
    
    def __repr__(self) -> str:
        return f"<RecommendationLike(id={self.id}, recommendation_id={self.recommendation_id}, user_id={self.user_id})>"
