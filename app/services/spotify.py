"""
Spotify API integration service
"""
import logging
from typing import Optional, Dict, Any
from datetime import datetime, timedelta
import spotipy
from spotipy.oauth2 import SpotifyOAuth, SpotifyClientCredentials

from app.core.config import settings

logger = logging.getLogger(__name__)


class SpotifyService:
    """Service for interacting with Spotify API"""
    
    def __init__(self):
        self.client_id = settings.SPOTIFY_CLIENT_ID
        self.client_secret = settings.SPOTIFY_CLIENT_SECRET
        self.redirect_uri = settings.SPOTIFY_REDIRECT_URI
        
    def get_oauth_manager(self) -> SpotifyOAuth:
        """
        Get SpotifyOAuth manager for user authentication
        
        Returns:
            SpotifyOAuth instance
        """
        return SpotifyOAuth(
            client_id=self.client_id,
            client_secret=self.client_secret,
            redirect_uri=self.redirect_uri,
            scope="user-read-email user-read-private",
            show_dialog=True
        )
    
    def get_authorization_url(self) -> str:
        """
        Get Spotify authorization URL for user to login
        
        Returns:
            Authorization URL string
        """
        oauth = self.get_oauth_manager()
        auth_url = oauth.get_authorize_url()
        return auth_url
    
    def exchange_code_for_token(self, code: str) -> Optional[Dict[str, Any]]:
        """
        Exchange authorization code for access token
        
        Args:
            code: Authorization code from Spotify callback
            
        Returns:
            Token info dict with access_token, refresh_token, expires_at
        """
        try:
            oauth = self.get_oauth_manager()
            token_info = oauth.get_access_token(code, as_dict=True, check_cache=False)
            return token_info
        except Exception as e:
            logger.error(f"Failed to exchange code for token: {str(e)}")
            return None
    
    def refresh_access_token(self, refresh_token: str) -> Optional[Dict[str, Any]]:
        """
        Refresh access token using refresh token
        
        Args:
            refresh_token: Spotify refresh token
            
        Returns:
            New token info dict
        """
        try:
            oauth = self.get_oauth_manager()
            token_info = oauth.refresh_access_token(refresh_token)
            return token_info
        except Exception as e:
            logger.error(f"Failed to refresh token: {str(e)}")
            return None
    
    def get_user_profile(self, access_token: str) -> Optional[Dict[str, Any]]:
        """
        Get user profile information from Spotify
        
        Args:
            access_token: Valid Spotify access token
            
        Returns:
            User profile dict with id, display_name, email, images
        """
        try:
            sp = spotipy.Spotify(auth=access_token)
            user_profile = sp.current_user()
            
            return {
                "spotify_id": user_profile.get("id"),
                "display_name": user_profile.get("display_name"),
                "email": user_profile.get("email")
            }
        except Exception as e:
            logger.error(f"Failed to get user profile: {str(e)}")
            return None
    
    def get_track_metadata(self, spotify_track_id: str) -> Optional[Dict[str, Any]]:
        """
        Get track metadata from Spotify
        
        Args:
            spotify_track_id: Spotify track ID
            
        Returns:
            Track metadata dict with title, artist, album, urls
        """
        try:
            # Use client credentials for track lookup (doesn't require user auth)
            client_credentials_manager = SpotifyClientCredentials(
                client_id=self.client_id,
                client_secret=self.client_secret
            )
            sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
            
            track = sp.track(spotify_track_id)
            
            return {
                "spotify_track_id": track["id"],
                "title": track["name"],
                "artist": ", ".join([artist["name"] for artist in track["artists"]]),
                "album": track["album"]["name"],
                "album_cover_url": track["album"]["images"][0]["url"] if track["album"]["images"] else None,
                "track_url": track["external_urls"]["spotify"],
                "preview_url": track.get("preview_url"),
            }
        except Exception as e:
            logger.error(f"Failed to get track metadata for {spotify_track_id}: {str(e)}")
            return None
    
    def search_tracks(self, query: str, limit: int = 10) -> list[Dict[str, Any]]:
        """
        Search for tracks on Spotify
        
        Args:
            query: Search query string
            limit: Maximum number of results
            
        Returns:
            List of track metadata dicts
        """
        try:
            client_credentials_manager = SpotifyClientCredentials(
                client_id=self.client_id,
                client_secret=self.client_secret
            )
            sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
            
            results = sp.search(q=query, type="track", limit=limit)
            tracks = results.get("tracks", {}).get("items", [])
            
            return [
                {
                    "spotify_track_id": track["id"],
                    "title": track["name"],
                    "artist": ", ".join([artist["name"] for artist in track["artists"]]),
                    "album": track["album"]["name"],
                    "album_cover_url": track["album"]["images"][0]["url"] if track["album"]["images"] else None,
                    "track_url": track["external_urls"]["spotify"],
                    "preview_url": track.get("preview_url"),
                }
                for track in tracks
            ]
        except Exception as e:
            logger.error(f"Failed to search tracks: {str(e)}")
            return []


# Global instance
spotify_service = SpotifyService()
