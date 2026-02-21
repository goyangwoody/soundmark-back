# Soundmark API - Frontend Integration Guide

프론트엔드(Kotlin Android) 연동 가이드

## 📋 OpenAPI 스키마

### 스키마 파일
- **JSON**: `openapi/openapi.json`
- **YAML**: `openapi/openapi.yaml`

### 생성 방법
```bash
# OpenAPI 스키마 생성
python generate_openapi.py

# 스키마 검증
python validate_openapi.py
```

---

## 🔗 API 문서

**로컬 개발 환경:**
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- OpenAPI JSON: http://localhost:8000/openapi.json

**프로덕션:**
- Swagger UI: https://yourdomain.com/docs
- ReDoc: https://yourdomain.com/redoc
- OpenAPI JSON: https://yourdomain.com/openapi.json

---

## 🚀 Kotlin/Android 클라이언트 생성

### 방법 1: OpenAPI Generator (추천)

**설치:**
```bash
# Homebrew (Mac)
brew install openapi-generator

# npm
npm install -g @openapitools/openapi-generator-cli

# 또는 Docker
alias openapi-generator='docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli'
```

**Retrofit2 클라이언트 생성:**
```bash
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g kotlin \
  -o android-client \
  --additional-properties=\
library=jvm-retrofit2,\
dateLibrary=java8,\
serializationLibrary=kotlinx_serialization,\
useCoroutines=true,\
packageName=com.soundmark.api
```

**Ktor 클라이언트 생성:**
```bash
openapi-generator-cli generate \
  -i openapi/openapi.json \
  -g kotlin \
  -o android-client \
  --additional-properties=\
library=jvm-ktor,\
dateLibrary=java8,\
serializationLibrary=kotlinx_serialization,\
packageName=com.soundmark.api
```

### 방법 2: 수동 구현

#### build.gradle.kts (app)
```kotlin
dependencies {
    // Retrofit
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    
    // Kotlin Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    
    // Gson
    implementation("com.google.code.gson:gson:2.10.1")
}
```

#### API Client 예시
```kotlin
// ApiClient.kt
package com.soundmark.api

import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object ApiClient {
    private const val BASE_URL = "http://10.0.2.2:8000" // Android emulator localhost
    // private const val BASE_URL = "https://api.soundmark.com" // Production
    
    private val loggingInterceptor = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }
    
    private val okHttpClient = OkHttpClient.Builder()
        .addInterceptor(loggingInterceptor)
        .addInterceptor { chain ->
            val request = chain.request().newBuilder()
                .addHeader("Content-Type", "application/json")
                .build()
            chain.proceed(request)
        }
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build()
    
    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(okHttpClient)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
    
    val authService: AuthService by lazy {
        retrofit.create(AuthService::class.java)
    }
    
    val recommendationService: RecommendationService by lazy {
        retrofit.create(RecommendationService::class.java)
    }
    
    val mapService: MapService by lazy {
        retrofit.create(MapService::class.java)
    }
}

// AuthService.kt
interface AuthService {
    // 권장: 클라이언트가 Spotify OAuth 직접 처리 후 토큰 검증
    @POST("/api/v1/auth/spotify/verify")
    suspend fun verifySpotifyToken(
        @Body request: SpotifyVerifyRequest
    ): TokenResponse
    
    // Deprecated: 레거시 엔드포인트
    @GET("/api/v1/auth/spotify/login")
    @Deprecated("Use client-side Spotify OAuth with PKCE instead")
    suspend fun getSpotifyLoginUrl(): SpotifyLoginResponse
    
    @POST("/api/v1/auth/spotify/callback")
    @Deprecated("Use verifySpotifyToken instead")
    suspend fun spotifyCallback(@Query("code") code: String): TokenResponse
    
    @GET("/api/v1/auth/me")
    suspend fun getCurrentUser(
        @Header("Authorization") token: String
    ): UserResponse
    
    @POST("/api/v1/auth/refresh")
    suspend fun refreshToken(
        @Header("Authorization") token: String
    ): TokenResponse
}

// RecommendationService.kt
interface RecommendationService {
    @POST("/api/v1/recommendations")
    suspend fun createRecommendation(
        @Header("Authorization") token: String,
        @Body request: CreateRecommendationRequest
    ): RecommendationResponse
    
    @GET("/api/v1/recommendations/{recommendation_id}")
    suspend fun getRecommendation(
        @Path("recommendation_id") recommendationId: Int,
        @Header("Authorization") token: String
    ): RecommendationResponse
    
    @PUT("/api/v1/recommendations/{recommendation_id}/like")
    suspend fun toggleLike(
        @Path("recommendation_id") recommendationId: Int,
        @Header("Authorization") token: String
    ): LikeResponse
}

// MapService.kt
interface MapService {
    @GET("/api/v1/map/nearby")
    suspend fun getNearbyRecommendations(
        @Query("lat") lat: Double,
        @Query("lng") lng: Double,
        @Query("radius") radius: Int = 5000,
        @Query("limit") limit: Int = 50,
        @Header("Authorization") token: String
    ): NearbyResponse
}

// UserService.kt
interface UserService {
    @GET("/api/v1/users/me")
    suspend fun getMyProfile(
        @Header("Authorization") token: String
    ): UserWithStatsResponse

    @GET("/api/v1/users/{user_id}")
    suspend fun getUserProfile(
        @Path("user_id") userId: Int,
        @Header("Authorization") token: String? = null
    ): UserWithStatsResponse
    
    @POST("/api/v1/users/{user_id}/follow")
    suspend fun followUser((
        @Path("user_id") userId: Int,
        @Header("Authorization") token: String
    ): FollowResponse
    
    @DELETE("/api/v1/users/{user_id}/follow")
    suspend fun unfollowUser(
        @Path("user_id") userId: Int,
        @Header("Authorization") token: String
    ): FollowResponse
    
    @GET("/api/v1/users/{user_id}/followers")
    suspend fun getFollowers(
        @Path("user_id") userId: Int,
        @Query("limit") limit: Int = 50,
        @Query("offset") offset: Int = 0
    ): FollowersResponse
    
    @GET("/api/v1/users/{user_id}/following")
    suspend fun getFollowing(
        @Path("user_id") userId: Int,
        @Query("limit") limit: Int = 50,
        @Query("offset") offset: Int = 0
    ): FollowingResponse
}
```

#### Data Models
```kotlin
// Models.kt
data class SpotifyVerifyRequest(
    val spotifyAccessToken: String,
    val spotifyRefreshToken: String,
    val expiresIn: Int = 3600
)

data class SpotifyLoginResponse(
    val url: String
)

data class TokenResponse(
    val accessToken: String,
    val tokenType: String = "bearer",
    val expiresIn: Int
)

data class UserResponse(
    val id: Int,
    val spotifyId: String,
    val displayName: String?,
    val email: String?,
    val createdAt: String
)

data class CreateRecommendationRequest(
    val spotifyTrackId: String,
    val lat: Double,
    val lng: Double,
    val message: String?,
    val note: String?,
    val placeName: String?,
    val address: String?
)

data class RecommendationResponse(
    val id: Int,
    val user: UserResponse,
    val track: TrackResponse,
    val place: PlaceResponse?,
    val lat: Double,
    val lng: Double,
    val message: String?,
    val note: String?,
    val likesCount: Int,
    val isLiked: Boolean,
    val createdAt: String
)

data class TrackResponse(
    val id: Int,
    val spotifyTrackId: String,
    val title: String,
    val artist: String,
    val album: String?,
    val albumCoverUrl: String?,
    val trackUrl: String?,
    val previewUrl: String?
)

data class PlaceResponse(
    val id: Int,
    val googlePlaceId: String?,
    val placeName: String,
    val address: String?,
    val lat: Double,
    val lng: Double
)

data class LikeResponse(
    val liked: Boolean,
    val likesCount: Int
)

data class NearbyResponse(
    val recommendations: List<RecommendationResponse>,
    val total: Int
)

data class UserWithStatsResponse(
    val id: Int,
    val spotifyId: String,
    val displayName: String?,
    val email: String?,
    val createdAt: String,
    val followerCount: Int,
    val followingCount: Int,
    val recommendationCount: Int,
    val isFollowing: Boolean,
    val isFollowedBy: Boolean,
    val recommendations: List<RecommendationSummary>
)

data class RecommendationSummary(
    val id: Int,
    val trackTitle: String,
    val trackArtist: String,
    val albumCoverUrl: String?,
    val message: String?,
    val placeName: String?,
    val createdAt: String
)

data class FollowResponse(
    val success: Boolean,
    val message: String,
    val followerCount: Int
)

data class UserPublic(
    val id: Int,
    val spotifyId: String,
    val displayName: String?
)

data class FollowersResponse(
    val followers: List<UserPublic>,
    val total: Int
)

data class FollowingResponse(
    val following: List<UserPublic>,
    val total: Int
)
```

#### 사용 예시
```kotlin
// ViewModel 예시
class MapViewModel : ViewModel() {
    private val authToken = "Bearer YOUR_JWT_TOKEN"
    
    fun loadNearbyRecommendations(lat: Double, lng: Double) {
        viewModelScope.launch {
            try {
                val response = ApiClient.mapService.getNearbyRecommendations(
                    lat = lat,
                    lng = lng,
                    radius = 200, // 200m 반경
                    limit = 50,
                    token = authToken
                )
                
                // UI 업데이트
                _recommendations.value = response.recommendations
                
            } catch (e: Exception) {
                Log.e("MapViewModel", "Error loading recommendations", e)
            }
        }
    }
}

// Activity 예시
class MainActivity : AppCompatActivity() {
    private val viewModel: MapViewModel by viewModels()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 현재 위치에서 주변 추천 로드
        viewModel.loadNearbyRecommendations(37.5665, 126.9780)
    }
}

// UserViewModel 예시
class UserViewModel : ViewModel() {
    private val authToken = "Bearer YOUR_JWT_TOKEN"
    
    fun loadMyProfile() {
        viewModelScope.launch {
            try {
                val profile = ApiClient.userService.getMyProfile(
                    token = authToken
                )
                
                // UI 업데이트 - 프로필 + 추천 피드
                _userProfile.value = profile
                _recommendations.value = profile.recommendations
                
            } catch (e: Exception) {
                Log.e("UserViewModel", "Error loading my profile", e)
            }
        }
    }
    
    fun loadUserProfile(userId: Int) {
        viewModelScope.launch {
            try {
                val profile = ApiClient.userService.getUserProfile(
                    userId = userId,
                    token = authToken
                )
                
                // UI 업데이트 - 프로필 + 추천 피드
                _userProfile.value = profile
                _recommendations.value = profile.recommendations
                
            } catch (e: Exception) {
                Log.e("UserViewModel", "Error loading profile", e)
            }
        }
    }
    
    fun followUser(userId: Int) {
        viewModelScope.launch {
            try {
                val response = ApiClient.userService.followUser(
                    userId = userId,
                    token = authToken
                )
                
                if (response.success) {
                    _followStatus.value = true
                    _followerCount.value = response.followerCount
                }
                
            } catch (e: Exception) {
                Log.e("UserViewModel", "Error following user", e)
            }
        }
    }
    
    fun loadFollowers(userId: Int) {
        viewModelScope.launch {
            try {
                val response = ApiClient.userService.getFollowers(
                    userId = userId,
                    limit = 50,
                    offset = 0
                )
                
                _followers.value = response.followers
                
            } catch (e: Exception) {
                Log.e("UserViewModel", "Error loading followers", e)
            }
        }
    }
}
```

---

## 🔐 Authentication Flow

### 방법 1: 클라이언트 직접 Spotify OAuth (PKCE) ⭐ **권장**

클라이언트가 Spotify OAuth를 직접 처리합니다. 더 안전하고 최신 방식입니다.

#### Android 예시 (Spotify Android SDK 또는 수동 구현)

```kotlin
// build.gradle.kts에 추가
dependencies {
    implementation("com.spotify.android:auth:2.1.1") // Spotify Auth Library
}

// 1. PKCE Code Verifier 및 Challenge 생성
import java.security.MessageDigest
import java.security.SecureRandom
import android.util.Base64

fun generateCodeVerifier(): String {
    val secureRandom = SecureRandom()
    val code = ByteArray(32)
    secureRandom.nextBytes(code)
    return Base64.encodeToString(code, Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING)
}

fun generateCodeChallenge(verifier: String): String {
    val bytes = verifier.toByteArray(Charsets.US_ASCII)
    val messageDigest = MessageDigest.getInstance("SHA-256")
    val digest = messageDigest.digest(bytes)
    return Base64.encodeToString(digest, Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING)
}

// 2. Spotify 로그인 시작
fun startSpotifyLogin(activity: Activity) {
    val clientId = "YOUR_SPOTIFY_CLIENT_ID"
    val redirectUri = "soundmark://callback"
    
    // Code verifier 생성 및 저장
    val codeVerifier = generateCodeVerifier()
    saveCodeVerifier(codeVerifier) // SharedPreferences에 임시 저장
    
    val codeChallenge = generateCodeChallenge(codeVerifier)
    
    // Spotify authorization URL 생성
    val scopes = "user-read-email user-read-private"
    val authUrl = "https://accounts.spotify.com/authorize?" +
            "client_id=$clientId&" +
            "response_type=code&" +
            "redirect_uri=${Uri.encode(redirectUri)}&" +
            "code_challenge_method=S256&" +
            "code_challenge=$codeChallenge&" +
            "scope=${Uri.encode(scopes)}"
    
    // Chrome Custom Tab으로 열기
    val intent = CustomTabsIntent.Builder().build()
    intent.launchUrl(activity, Uri.parse(authUrl))
}

// 3. Deep Link Callback 처리
// AndroidManifest.xml에 intent-filter 추가 필요
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    
    val uri = intent?.data
    if (uri != null && uri.scheme == "soundmark" && uri.host == "callback") {
        val code = uri.getQueryParameter("code")
        if (code != null) {
            exchangeCodeForToken(code)
        }
    }
}

// 4. Authorization Code를 Spotify Token으로 교환
suspend fun exchangeCodeForToken(code: String) {
    val codeVerifier = getCodeVerifier() // SharedPreferences에서 가져오기
    
    try {
        // Spotify token endpoint 직접 호출
        val response = makeSpotifyTokenRequest(code, codeVerifier)
        
        val spotifyAccessToken = response.getString("access_token")
        val spotifyRefreshToken = response.getString("refresh_token")
        val expiresIn = response.getInt("expires_in")
        
        // 5. 백엔드에 토큰 전송 및 JWT 받기
        val verifyRequest = SpotifyVerifyRequest(
            spotifyAccessToken = spotifyAccessToken,
            spotifyRefreshToken = spotifyRefreshToken,
            expiresIn = expiresIn
        )
        
        val tokenResponse = ApiClient.authService.verifySpotifyToken(verifyRequest)
        val jwtToken = tokenResponse.accessToken
        
        // 6. JWT 저장
        saveJwtToken(jwtToken)
        
        // Code verifier 삭제
        clearCodeVerifier()
        
        // 메인 화면으로 이동
        navigateToMain()
        
    } catch (e: Exception) {
        Log.e("Auth", "Login failed", e)
        showError("로그인 실패")
    }
}

// Spotify token endpoint 호출 헬퍼
suspend fun makeSpotifyTokenRequest(code: String, codeVerifier: String): JSONObject {
    val client = OkHttpClient()
    val requestBody = FormBody.Builder()
        .add("grant_type", "authorization_code")
        .add("code", code)
        .add("redirect_uri", "soundmark://callback")
        .add("client_id", "YOUR_SPOTIFY_CLIENT_ID")
        .add("code_verifier", codeVerifier)
        .build()
    
    val request = Request.Builder()
        .url("https://accounts.spotify.com/api/token")
        .post(requestBody)
        .build()
    
    return withContext(Dispatchers.IO) {
        val response = client.newCall(request).execute()
        JSONObject(response.body!!.string())
    }
}
```

### 방법 2: 백엔드 Callback 방식 (Deprecated)

기존 방식으로, 백엔드가 code를 token으로 교환합니다.

```kotlin
// 1. Spotify 로그인 URL 가져오기
val response = ApiClient.authService.getSpotifyLoginUrl()
val loginUrl = response.url

// 2. 웹뷰나 Chrome Custom Tab으로 열기
val intent = Intent(Intent.ACTION_VIEW, Uri.parse(loginUrl))
startActivity(intent)

// 3. Callback에서 authorization code 추출
// Deep link: soundmark://callback?code=AUTHORIZATION_CODE

// 4. 백엔드에 code 전송하여 JWT 받기
val tokenResponse = ApiClient.authService.spotifyCallback(code)
val jwtToken = tokenResponse.accessToken

// 5. JWT 저장
saveToken(jwtToken)
```

### 2. API 요청 시 JWT 사용
```kotlin
val authHeader = "Bearer $jwtToken"
val user = ApiClient.authService.getCurrentUser(authHeader)
```

### 3. Token Refresh
```kotlin
try {
    // API 요청
    val response = ApiClient.mapService.getNearbyRecommendations(...)
} catch (e: HttpException) {
    if (e.code() == 401) {
        // Token expired, refresh
        val newToken = ApiClient.authService.refreshToken("Bearer $oldToken")
        saveToken(newToken.accessToken)
        
        // Retry request
        val response = ApiClient.mapService.getNearbyRecommendations(...)
    }
}
```

---

## 📍 위치 기반 기능

### 200m 반경 내 추천만 상세 보기
```kotlin
fun checkDistanceAndShowDetails(
    userLat: Double,
    userLng: Double,
    recommendationLat: Double,
    recommendationLng: Double
) {
    val distance = calculateDistance(
        userLat, userLng,
        recommendationLat, recommendationLng
    )
    
    if (distance <= 200.0) {
        // 200m 이내 - 상세 정보 표시
        showRecommendationDetails(recommendation)
    } else {
        // 200m 밖 - 핀만 표시
        showPinOnly(recommendation)
    }
}

fun calculateDistance(
    lat1: Double, lon1: Double,
    lat2: Double, lon2: Double
): Double {
    val r = 6371000.0 // Earth radius in meters
    val dLat = Math.toRadians(lat2 - lat1)
    val dLon = Math.toRadians(lon2 - lon1)
    
    val a = sin(dLat / 2) * sin(dLat / 2) +
            cos(Math.toRadians(lat1)) * cos(Math.toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2)
    
    val c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return r * c
}
```

---

## 🗺️ Google Maps 연동

```kotlin
// build.gradle
implementation("com.google.android.gms:play-services-maps:18.2.0")
implementation("com.google.android.gms:play-services-location:21.0.1")

// MapFragment 예시
class MapFragment : Fragment(), OnMapReadyCallback {
    private lateinit var googleMap: GoogleMap
    private val viewModel: MapViewModel by viewModels()
    
    override fun onMapReady(map: GoogleMap) {
        googleMap = map
        
        // 현재 위치 가져오기
        getCurrentLocation { lat, lng ->
            // 카메라 이동
            googleMap.moveCamera(
                CameraUpdateFactory.newLatLngZoom(
                    LatLng(lat, lng), 15f
                )
            )
            
            // 주변 추천 로드
            viewModel.loadNearbyRecommendations(lat, lng)
        }
        
        // 추천들을 마커로 표시
        viewModel.recommendations.observe(viewLifecycleOwner) { recommendations ->
            recommendations.forEach { rec ->
                googleMap.addMarker(
                    MarkerOptions()
                        .position(LatLng(rec.lat, rec.lng))
                        .title(rec.track.title)
                        .snippet(rec.message)
                )
            }
        }
    }
}
```

---

## 🎵 Spotify SDK 연동

```kotlin
// build.gradle
implementation("com.spotify.android:auth:2.1.0")

// Spotify 재생
fun playTrackOnSpotify(spotifyTrackId: String) {
    val spotifyUri = "spotify:track:$spotifyTrackId"
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(spotifyUri))
    startActivity(intent)
}
```

---

## 📦 전체 의존성

```kotlin
// build.gradle.kts (Project)
plugins {
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.20" apply false
}

// build.gradle.kts (app)
dependencies {
    // Retrofit
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    
    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    
    // ViewModel & LiveData
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.6.2")
    
    // Google Maps
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.0.1")
    
    // Spotify
    implementation("com.spotify.android:auth:2.1.0")
    
    // Image Loading
    implementation("io.coil-kt:coil:2.5.0")
}
```

---

## 🔧 환경 설정

**local.properties 또는 BuildConfig에 추가:**
```properties
API_BASE_URL=http://10.0.2.2:8000
API_BASE_URL_PROD=https://api.soundmark.com
SPOTIFY_CLIENT_ID=your_client_id
SPOTIFY_REDIRECT_URI=soundmark://callback
```

---

## 📞 문의

- API 문서: http://localhost:8000/docs
- OpenAPI 스키마: `openapi/openapi.json`
- 백엔드 이슈: GitHub Issues
