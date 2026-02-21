"""
API v1 routes aggregation
"""
from fastapi import APIRouter

from app.api.v1 import auth, recommendations, map, users

# Create v1 router
api_router = APIRouter()

# Include all route modules
api_router.include_router(auth.router)
api_router.include_router(recommendations.router)
api_router.include_router(map.router)
api_router.include_router(users.router)
