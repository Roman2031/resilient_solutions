# Kingdom Call Circle - Refactored Architecture

## Overview
This document outlines the comprehensive refactoring of the Kingdom Call Circle Flutter app to integrate with Keycloak authentication and implement advanced state management patterns.

## Architecture Components

### 1. Authentication System (Keycloak OIDC)

#### Implementation
- **OAuth 2.0 Authorization Code Flow with PKCE** for mobile security
- **Deep Linking** configured for OAuth redirects (`com.kingdomcall.app://oauth2redirect`)
- **Automatic Token Refresh** before expiration
- **Secure Token Storage** using Flutter Secure Storage

#### Files
- `lib/core/auth/keycloak_auth_service.dart` - Main authentication service
- `lib/core/auth/auth_repository.dart` - Riverpod state management for auth
- `lib/core/auth/deep_link_service.dart` - Deep link handling
- `lib/core/config/keycloak_config.dart` - Keycloak configuration

#### Configuration
Set environment variables for Keycloak:
```bash
--dart-define=KEYCLOAK_BASE_URL=https://auth.kingdomcall.com
--dart-define=KEYCLOAK_REALM=kingdomcall
--dart-define=KEYCLOAK_CLIENT_ID=kingdomcall-mobile
```

### 2. API Integration Layer

#### Features
- **Dual API Support**: Laravel backend and WordPress LMS
- **JWT Auto-Injection**: Automatic Bearer token in all requests
- **Smart Retry Logic**: Auto-retry for transient failures
- **Response Caching**: Reduce API calls and improve performance
- **Certificate Pinning**: Enhanced security for API calls

#### Files
- `lib/core/network/api_service.dart` - Main API service
- `lib/core/network/api_interceptor.dart` - Request/response interceptors
- `lib/core/data/base_repository.dart` - Repository pattern base class

#### Usage
```dart
// Inject API service via Riverpod
final apiService = ref.watch(apiServiceProvider);

// Laravel API call
final response = await apiService.get('/call-circles/my-circles');

// WordPress API call
final courses = await apiService.get('/learndash/v2/courses', useWordpress: true);
```

### 3. State Management (Riverpod)

#### Pattern
- **Code Generation** with `riverpod_generator` for type safety
- **AsyncNotifierProvider** for async state management
- **Proper Error Handling** with `AsyncValue`
- **Auto-Dispose** for memory efficiency

#### Example Provider
```dart
@riverpod
class MyCallCircles extends _$MyCallCircles {
  @override
  Future<List<CallCircle>> build() async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getMyCallCircles();
  }
}
```

### 4. Data Layer (Repository Pattern)

#### Structure
```
features/
└── callcircle/
    ├── data/
    │   ├── models/           # Data models with Freezed
    │   └── repositories/     # API repositories
    └── providers/            # Riverpod providers
```

#### Models
- **Freezed** for immutable data classes
- **JSON Serialization** with `json_serializable`
- **Type Safety** throughout the data layer

### 5. Feature Modules

#### Call Circle Module
Comprehensive implementation of Call Circle features:

**Models:**
- `CallCircle` - Main circle entity
- `CallCircleSession` - Session management
- `CallCircleMember` - Member management
- `Attendance` - Attendance tracking

**Repository:**
- `CallCircleRepository` - All API calls for circles, sessions, members, attendance

**Providers:**
- `MyCallCircles` - User's circles
- `CallCircleDetail` - Single circle details
- `CallCircleMembers` - Circle members
- `CallCircleSessions` - Circle sessions
- `SessionAttendance` - Attendance tracking

## System Integration

### Laravel Backend
- **Base URL**: `https://api.kingdomcall.com/api`
- **Authentication**: JWT Bearer tokens from Keycloak
- **Endpoints**: RESTful API for circles, sessions, attendance, audit

### WordPress + BuddyBoss + LearnDash
- **Base URL**: `https://lms.kingdomcall.com/wp-json`
- **Integration**: LMS courses, social features, groups
- **Authentication**: Same JWT from Keycloak

### Keycloak
- **URL**: `https://auth.kingdomcall.com`
- **Realm**: `kingdomcall`
- **Flow**: Authorization Code + PKCE
- **Token Storage**: Secure encrypted storage

## Deep Linking Setup

### Android
Configured in `AndroidManifest.xml`:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="com.kingdomcall.app"
        android:host="oauth2redirect" />
</intent-filter>
```

### iOS
Configured in `Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.kingdomcall.app</string>
        </array>
    </dict>
</array>
```

## Code Generation

Run code generation for Riverpod, Freezed, and JSON serialization:

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Security Features

1. **PKCE (Proof Key for Code Exchange)** - Required for mobile OAuth
2. **Certificate Pinning** - Prevents man-in-the-middle attacks
3. **Secure Token Storage** - Encrypted storage for sensitive data
4. **Auto Token Refresh** - Seamless token renewal
5. **JWT Validation** - Token expiry checking

## Performance Optimizations

1. **Response Caching** - Cache GET requests to reduce API calls
2. **Auto-Dispose** - Riverpod providers auto-dispose when not in use
3. **Lazy Loading** - Load data only when needed
4. **Shimmer Loading** - Smooth loading states
5. **Tree Shaking** - Remove unused code in production builds

## Error Handling

1. **Centralized Error Handling** - `ErrorInterceptor` for all API errors
2. **User-Friendly Messages** - Translate technical errors to user messages
3. **Retry Logic** - Auto-retry transient failures
4. **Graceful Degradation** - App continues to work with cached data

## Testing Strategy

### Unit Tests
- Repository tests
- Model serialization tests
- Auth service tests

### Integration Tests
- API integration tests
- Auth flow tests
- Deep linking tests

### Widget Tests
- Provider state tests
- UI interaction tests

## Migration Guide

### For Existing Features
1. Create data models with Freezed
2. Create repository extending `BaseRepository`
3. Create Riverpod providers with code generation
4. Update UI to consume providers with `AsyncValue`
5. Run code generation

### Example Migration
```dart
// Old way
final response = await dio.get('/api/endpoint');
final data = response.data;

// New way
final data = await ref.read(myFeatureProvider.future);
```

## Dependencies Added

```yaml
# Authentication & Deep Linking
flutter_appauth: ^8.0.2
uni_links: ^0.5.1
jwt_decoder: ^2.0.1

# Serialization & Code Generation
freezed_annotation: ^2.4.4
json_annotation: ^4.9.0
riverpod_generator: ^3.0.0

# Dev Dependencies
freezed: ^2.5.7
json_serializable: ^6.8.0
```

## Next Steps

1. ✅ Core architecture and authentication setup
2. ⏳ Migrate remaining features to new architecture
3. ⏳ Implement WordPress integration
4. ⏳ Add comprehensive error handling
5. ⏳ Performance testing and optimization
6. ⏳ UI polish and animations
7. ⏳ Integration testing
8. ⏳ Production deployment

## Support

For questions or issues with the refactored architecture, please refer to:
- Architecture decisions in this document
- Code comments in implementation files
- Riverpod documentation: https://riverpod.dev
- Flutter AppAuth: https://pub.dev/packages/flutter_appauth
