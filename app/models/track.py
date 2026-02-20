"""
Track model - stores Spotify track metadata
"""
from datetime import datetime
from sqlalchemy import String, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import Optional

from app.database import Base


class Track(Base):
    __tablename__ = "tracks"
    
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    spotify_track_id: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    artist: Mapped[str] = mapped_column(String(512), nullable=False)
    album: Mapped[Optional[str]] = mapped_column(String(512), nullable=True)
    album_cover_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    track_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    preview_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False
    )
    
    # Relationships
    recommendations: Mapped[list["Recommendation"]] = relationship(
        "Recommendation",
        back_populates="track"
    )
    
    def __repr__(self) -> str:
        return f"<Track(id={self.id}, spotify_track_id={self.spotify_track_id}, title={self.title})>"
