"""
Recommendation model - stores location-based music recommendations
"""
from datetime import datetime
from sqlalchemy import String, DateTime, Float, Text, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import Optional
from geoalchemy2 import Geometry

from app.database import Base


class Recommendation(Base):
    __tablename__ = "recommendations"
    
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    track_id: Mapped[int] = mapped_column(ForeignKey("tracks.id", ondelete="CASCADE"), nullable=False, index=True)
    place_id: Mapped[Optional[int]] = mapped_column(ForeignKey("places.id", ondelete="SET NULL"), nullable=True)
    
    # Location data
    lat: Mapped[float] = mapped_column(Float, nullable=False)
    lng: Mapped[float] = mapped_column(Float, nullable=False)
    geom = mapped_column(Geometry(geometry_type='POINT', srid=4326), nullable=False, index=True)
    
    # User's message/note about this recommendation
    message: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)  # Short message
    note: Mapped[Optional[str]] = mapped_column(Text, nullable=True)  # Longer note
    
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False
    )
    deleted_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)  # Soft delete
    
    # Relationships
    user: Mapped["User"] = relationship("User", back_populates="recommendations")
    track: Mapped["Track"] = relationship("Track", back_populates="recommendations")
    place: Mapped[Optional["Place"]] = relationship("Place", back_populates="recommendations")
    likes: Mapped[list["RecommendationLike"]] = relationship(
        "RecommendationLike",
        back_populates="recommendation",
        cascade="all, delete-orphan"
    )
    
    def __repr__(self) -> str:
        return f"<Recommendation(id={self.id}, user_id={self.user_id}, track_id={self.track_id}, lat={self.lat}, lng={self.lng})>"
