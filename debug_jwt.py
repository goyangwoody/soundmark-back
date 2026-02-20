"""Debug JWT issue"""
from app.core.security import create_access_token, decode_access_token
from app.core.config import settings
from jose import jwt, JWTError

token = create_access_token(data={"sub": 1})
print(f"Token: {token}")
print(f"Key: {settings.JWT_SECRET_KEY[:10]}...")
print(f"Algorithm: {settings.JWT_ALGORITHM}")

# Try decode with error details
try:
    payload = jwt.decode(
        token,
        settings.JWT_SECRET_KEY,
        algorithms=[settings.JWT_ALGORITHM]
    )
    print(f"Decode OK: {payload}")
except JWTError as e:
    print(f"JWTError: {e}")
except Exception as e:
    print(f"Other error: {type(e).__name__}: {e}")
