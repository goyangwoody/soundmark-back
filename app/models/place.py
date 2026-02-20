"""
Place model - stores place information (optional, for Google Places or manual input)
"""
from datetime import datetime
from sqlalchemy import String, DateTime, Float, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import Optional
from geoalchemy2 import Geometry

from app.database import Base


class Place(Base):
    __tablename__ = "places"
    
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    google_place_id: Mapped[Optional[str]] = mapped_column(String(255), unique=True, index=True, nullable=True)
    place_name: Mapped[str] = mapped_column(String(512), nullable=False)
    address: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    
    lat: Mapped[float] = mapped_column(Float, nullable=False)
    lng: Mapped[float] = mapped_column(Float, nullable=False)
    geom = mapped_column(Geometry(geometry_type='POINT', srid=4326), nullable=False)
    
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
        back_populates="place"
    )
    
    def __repr__(self) -> str:
        return f"<Place(id={self.id}, place_name={self.place_name}, lat={self.lat}, lng={self.lng})>"
