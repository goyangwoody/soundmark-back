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
            scope="user-read-email user-read-private user-read-recently-played",
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
        Get track metadata and artist genres from Spotify
        
        Args:
            spotify_track_id: Spotify track ID
            
        Returns:
            Track metadata dict with title, artist, album, urls, genres
        """
        try:
            # Use client credentials for track lookup (doesn't require user auth)
            client_credentials_manager = SpotifyClientCredentials(
                client_id=self.client_id,
                client_secret=self.client_secret
            )
            sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
            
            track = sp.track(spotify_track_id)
            
            # Fetch genres from artist data
            artist_ids = [artist["id"] for artist in track["artists"]]
            genres = set()
            if artist_ids:
                for i in range(0, len(artist_ids), 50):
                    batch = artist_ids[i:i + 50]
                    artists_response = sp.artists(batch)
                    for artist in artists_response.get("artists", []):
                        if artist:
                            genres.update(artist.get("genres", []))
            
            return {
                "spotify_track_id": track["id"],
                "title": track["name"],
                "artist": ", ".join([artist["name"] for artist in track["artists"]]),
                "album": track["album"]["name"],
                "album_cover_url": track["album"]["images"][0]["url"] if track["album"]["images"] else None,
                "track_url": track["external_urls"]["spotify"],
                "preview_url": track.get("preview_url"),
                "genres": list(genres),
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


    def get_recently_played(self, access_token: str, limit: int = 3) -> Optional[list[Dict[str, Any]]]:
        """
        Get user's recently played tracks from Spotify
        
        Args:
            access_token: Valid Spotify access token (requires user-read-recently-played scope)
            limit: Maximum number of recently played tracks to return (default: 3)
            
        Returns:
            List of recently played track dicts, or None on error
        """
        try:
            sp = spotipy.Spotify(auth=access_token, requests_timeout=15)
            results = sp.current_user_recently_played(limit=limit)
            items = results.get("items", [])
            
            return [
                {
                    "spotify_track_id": item["track"]["id"],
                    "title": item["track"]["name"],
                    "artist": ", ".join([artist["name"] for artist in item["track"]["artists"]]),
                    "album": item["track"]["album"]["name"],
                    "album_cover_url": item["track"]["album"]["images"][0]["url"] if item["track"]["album"]["images"] else None,
                    "track_url": item["track"]["external_urls"]["spotify"],
                    "preview_url": item["track"].get("preview_url"),
                    "played_at": item["played_at"],
                }
                for item in items
            ]
        except Exception as e:
            logger.error(f"Failed to get recently played tracks: {str(e)}", exc_info=True)
            return None

    def get_recently_played_with_genres(self, access_token: str, limit: int = 3) -> Optional[list[Dict[str, Any]]]:
        """
        Get user's recently played tracks with artist genres from Spotify
        
        Args:
            access_token: Valid Spotify access token (requires user-read-recently-played scope)
            limit: Maximum number of recently played tracks to return (default: 3)
            
        Returns:
            List of track dicts with spotify_track_id, title, artist, genres.
            Returns None on error (e.g. expired token, network issue).
        """
        try:
            sp = spotipy.Spotify(auth=access_token, requests_timeout=15)
            results = sp.current_user_recently_played(limit=limit)
            items = results.get("items", [])
            
            # Collect all unique artist IDs
            all_artist_ids = set()
            tracks_data = []
            for item in items:
                track = item["track"]
                artist_ids = [a["id"] for a in track["artists"]]
                all_artist_ids.update(artist_ids)
                tracks_data.append({
                    "spotify_track_id": track["id"],
                    "title": track["name"],
                    "artist": ", ".join([a["name"] for a in track["artists"]]),
                    "album": track["album"]["name"] if track.get("album") else None,
                    "album_cover_url": (track["album"]["images"][0]["url"]
                                        if track.get("album", {}).get("images")
                                        else None),
                    "track_url": track.get("external_urls", {}).get("spotify"),
                    "_artist_ids": artist_ids,
                })
            
            # Batch fetch genres for all artists
            artist_genres = {}
            artist_ids_list = list(all_artist_ids)
            for i in range(0, len(artist_ids_list), 50):
                batch = artist_ids_list[i:i + 50]
                response = sp.artists(batch)
                for artist in response.get("artists", []):
                    if artist:
                        artist_genres[artist["id"]] = artist.get("genres", [])
            
            # Assign genres to each track
            for track in tracks_data:
                genres = set()
                for aid in track["_artist_ids"]:
                    genres.update(artist_genres.get(aid, []))
                track["genres"] = list(genres)
                del track["_artist_ids"]
            
            return tracks_data
        except Exception as e:
            logger.error(f"Failed to get recently played with genres: {str(e)}", exc_info=True)
            return None

    def get_artist_genres_batch(self, artist_ids: list[str]) -> Dict[str, list[str]]:
        """
        Batch get genres for multiple Spotify artists (uses client credentials)
        
        Args:
            artist_ids: List of Spotify artist IDs
            
        Returns:
            Dict mapping artist_id -> list of genres
        """
        try:
            client_credentials_manager = SpotifyClientCredentials(
                client_id=self.client_id,
                client_secret=self.client_secret
            )
            sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
            
            result = {}
            for i in range(0, len(artist_ids), 50):
                batch = artist_ids[i:i + 50]
                response = sp.artists(batch)
                for artist in response.get("artists", []):
                    if artist:
                        result[artist["id"]] = artist.get("genres", [])
            return result
        except Exception as e:
            logger.error(f"Failed to get artist genres batch: {str(e)}")
            return {}

    def get_tracks_artist_ids_batch(self, track_ids: list[str]) -> Dict[str, list[str]]:
        """
        Batch get artist IDs for multiple Spotify tracks (uses client credentials)
        
        Args:
            track_ids: List of Spotify track IDs
            
        Returns:
            Dict mapping track_id -> list of artist IDs
        """
        try:
            client_credentials_manager = SpotifyClientCredentials(
                client_id=self.client_id,
                client_secret=self.client_secret
            )
            sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)
            
            result = {}
            for i in range(0, len(track_ids), 50):
                batch = track_ids[i:i + 50]
                response = sp.tracks(batch)
                for track in response.get("tracks", []):
                    if track:
                        result[track["id"]] = [a["id"] for a in track["artists"]]
            return result
        except Exception as e:
            logger.error(f"Failed to get tracks artist IDs batch: {str(e)}")
            return {}

    def get_genres_for_tracks(self, track_ids: list[str]) -> Dict[str, list[str]]:
        """
        Get genres for multiple tracks by looking up their artists' genres
        
        Args:
            track_ids: List of Spotify track IDs
            
        Returns:
            Dict mapping track_id -> list of genres
        """
        if not track_ids:
            return {}
        
        # Step 1: Get artist IDs for all tracks
        track_artist_map = self.get_tracks_artist_ids_batch(track_ids)
        
        # Step 2: Collect all unique artist IDs
        all_artist_ids = set()
        for artist_ids in track_artist_map.values():
            all_artist_ids.update(artist_ids)
        
        # Step 3: Get genres for all artists
        artist_genres = self.get_artist_genres_batch(list(all_artist_ids))
        
        # Step 4: Build track -> genres mapping
        track_genres = {}
        for track_id, artist_ids in track_artist_map.items():
            genres = set()
            for aid in artist_ids:
                genres.update(artist_genres.get(aid, []))
            track_genres[track_id] = list(genres)
        
        return track_genres


# Global instance
spotify_service = SpotifyService()
