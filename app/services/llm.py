"""
LLM (OpenAI) integration service for AI-powered recommendations
"""
import json
import logging
from typing import Optional
from openai import AsyncOpenAI

from app.core.config import settings

logger = logging.getLogger(__name__)


class LLMService:
    """Service for interacting with OpenAI API"""

    def __init__(self):
        self._client: Optional[AsyncOpenAI] = None

    @property
    def client(self) -> AsyncOpenAI:
        if self._client is None:
            self._client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        return self._client

    async def analyze_user_taste_and_recommend(
        self,
        recommendations_json: list[dict],
    ) -> dict:
        """
        Analyse the user's recommendation history and return:
        - keywords: list of keywords that describe the user's taste
        - recommended_tracks: list of 10 {title, artist} dicts

        Args:
            recommendations_json: list of user's past recommendation dicts
                each containing keys like title, artist, genres, message, place_name

        Returns:
            {
                "keywords": ["indie", "chill", ...],
                "recommended_tracks": [
                    {"title": "...", "artist": "..."},
                    ...
                ]
            }
        """
        system_prompt = (
            "You are a music recommendation expert. "
            "The user will provide their past music recommendations in JSON format. "
            "Each recommendation contains a track (title, artist, genres), "
            "an optional message the user wrote, and an optional place name.\n\n"
            "Based on this data:\n"
            "1. Extract 5-10 keywords (in Korean or English) that describe the user's music taste, mood, and vibe.\n"
            "2. Recommend exactly 10 songs (title + artist) that the user would likely enjoy. "
            "Try to pick songs that are somewhat well-known so they might exist in our database.\n\n"
            "IMPORTANT: Respond ONLY with valid JSON. No markdown, no explanation.\n"
            "Response format:\n"
            '{\n'
            '  "keywords": ["keyword1", "keyword2", ...],\n'
            '  "recommended_tracks": [\n'
            '    {"title": "Song Name", "artist": "Artist Name"},\n'
            '    ...\n'
            '  ]\n'
            '}'
        )

        user_content = json.dumps(recommendations_json, ensure_ascii=False)

        try:
            response = await self.client.chat.completions.create(
                model=settings.OPENAI_MODEL,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_content},
                ],
                temperature=0.8,
                max_tokens=1500,
                response_format={"type": "json_object"},
            )

            result_text = response.choices[0].message.content
            result = json.loads(result_text)

            # Validate structure
            if "keywords" not in result or "recommended_tracks" not in result:
                logger.error(f"LLM response missing required fields: {result_text}")
                return {"keywords": [], "recommended_tracks": []}

            return result

        except Exception as e:
            logger.error(f"LLM analyze_user_taste_and_recommend failed: {e}")
            return {"keywords": [], "recommended_tracks": []}

    async def extract_keywords_batch(
        self,
        groups: dict[str, list[str]],
    ) -> dict[str, list[str]]:
        """
        Extract keywords from multiple groups of messages in a single LLM call.

        Args:
            groups: dict mapping group key (e.g. track identifier) to a list
                    of recommendation message strings

        Returns:
            dict mapping the same group keys to extracted keyword lists
        """
        # Filter out empty groups
        non_empty = {k: v for k, v in groups.items() if v}
        if not non_empty:
            return {k: [] for k in groups}

        system_prompt = (
            "You are a keyword extraction expert. "
            "The user will provide a JSON object where each key is a track identifier "
            "and each value is a list of short messages people wrote about that track at specific places.\n"
            "For EACH key, extract 3-8 representative keywords (in Korean or English) that capture "
            "the mood, atmosphere, emotions, and themes from those messages.\n\n"
            "IMPORTANT: Respond ONLY with valid JSON. No markdown, no explanation.\n"
            "Response format (same keys as input):\n"
            '{\n'
            '  "key1": ["keyword1", "keyword2", ...],\n'
            '  "key2": ["keyword1", "keyword2", ...]\n'
            '}'
        )

        user_content = json.dumps(non_empty, ensure_ascii=False)

        try:
            response = await self.client.chat.completions.create(
                model=settings.OPENAI_MODEL,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_content},
                ],
                temperature=0.5,
                max_tokens=2000,
                response_format={"type": "json_object"},
            )

            result_text = response.choices[0].message.content
            result = json.loads(result_text)

            # Build final dict, falling back to [] for missing/empty keys
            return {k: result.get(k, []) for k in groups}

        except Exception as e:
            logger.error(f"LLM extract_keywords_batch failed: {e}")
            return {k: [] for k in groups}


# Singleton instance
llm_service = LLMService()
