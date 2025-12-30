# Kingdom Call Circle Flutter App - Setup Guide

## Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / Xcode for mobile development
- Access to Keycloak server (https://auth.kingdom.com)
- Access to Laravel backend API
- Access to WordPress + LearnDash LMS

## Initial Setup

### 1. Install Dependencies

```bash
cd "Flutter App"
flutter pub get
```

### 2. Configure Environment Variables

Production configuration is already set in the code:

**Keycloak:**
- Base URL: `https://auth.kingdom.com`
- Realm: `KingdomStage`
- Client ID: `MobileApp`
- Deep Link: `myapp://com.kingdominc.learning/callback`

**APIs:**
- WordPress: `https://learning.kingdominc.com/wp-json`
- Call Service: `https://callcircle.resilentsolutions.com/api`
- Admin Portal: `https://callcircle.resilentsolutions.com/api/v1/admin`

For custom environments, you can override using environment variables:

```bash
# Optional: Override defaults
flutter run --dart-define=KEYCLOAK_BASE_URL=https://auth.custom.com \
            --dart-define=KEYCLOAK_REALM=CustomRealm \
            --dart-define=KEYCLOAK_CLIENT_ID=CustomClient
```

### 3. Run Code Generation

Generate code for Riverpod providers, Freezed models, JSON serialization, and RBAC:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

This will generate:
- `*.g.dart` files for Riverpod providers and JSON serialization
- `*.freezed.dart` files for data models (including RBAC models)
- RBAC permission models with role mappings

### 4. Configure Deep Linking

#### Android

The AndroidManifest.xml is already configured with deep linking for Keycloak OAuth callback.

To verify, check `android/app/src/main/AndroidManifest.xml` contains:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="myapp"
        android:host="com.kingdominc.learning"
        android:path="/callback" />
</intent-filter>
```

#### iOS

The Info.plist is already configured. No additional setup needed.

To verify, check `ios/Runner/Info.plist` contains:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myapp</string>
        </array>
    </dict>
</array>
```

### 5. Configure Keycloak Client

**Production Keycloak Configuration:**

In your Keycloak admin console (https://auth.kingdom.com/admin):

1. Create a new client with ID: `MobileApp`
2. Set **Client Protocol**: `openid-connect`
3. Set **Access Type**: `public`
4. Enable **Standard Flow** (Authorization Code Flow)
5. Add **Valid Redirect URIs**: 
   - `myapp://com.kingdominc.learning/callback`
6. Enable **PKCE** (Proof Key for Code Exchange) - Set to S256
7. Set appropriate **Web Origins** for CORS
8. Configure scopes: openid, profile, email, offline_access

**Additional Clients:**
- **AdminPortal**: Client ID with redirect `http://localhost:5173/*`
- **CallServices**: Client ID with secret `zSydbPq4ybLQoFlIS8kGRco2vAC0pfuD`
            <string>com.kingdomcall.app</string>
        </array>
    </dict>
</array>
```

### 5. Configure Keycloak Client

In your Keycloak admin console:

1. Create a new client with ID: `kingdomcall-mobile`
2. Set **Client Protocol**: `openid-connect`
3. Set **Access Type**: `public`
4. Enable **Standard Flow** (Authorization Code Flow)
5. Add **Valid Redirect URIs**: 
   - `com.kingdomcall.app://oauth2redirect`
   - `com.kingdomcall.app://logout`
6. Enable **PKCE** (Proof Key for Code Exchange)
7. Set appropriate **Web Origins** for CORS

## Running the App

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run with environment variables
flutter run --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdomcall.com \
            --dart-define=KEYCLOAK_REALM=kingdomcall \
            --dart-define=KEYCLOAK_CLIENT_ID=kingdomcall-mobile

# Run in profile mode (better performance)
flutter run --profile

# Run in release mode
flutter run --release
```

### Build for Production

#### Android APK
```bash
flutter build apk --release \
    --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdomcall.com \
    --dart-define=KEYCLOAK_REALM=kingdomcall \
    --dart-define=KEYCLOAK_CLIENT_ID=kingdomcall-mobile
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release \
    --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdomcall.com \
    --dart-define=KEYCLOAK_REALM=kingdomcall \
    --dart-define=KEYCLOAK_CLIENT_ID=kingdomcall-mobile
```

#### iOS
```bash
flutter build ios --release \
    --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdomcall.com \
    --dart-define=KEYCLOAK_REALM=kingdomcall \
    --dart-define=KEYCLOAK_CLIENT_ID=kingdomcall-mobile
```

## Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Authentication Flow

1. Launch the app
2. Tap "Login with SSO"
3. Browser opens with Keycloak login page
4. Enter credentials and authenticate
5. Redirected back to app automatically
6. Should see dashboard

### Test Deep Linking

Test OAuth redirect:
```bash
# Android
adb shell am start -W -a android.intent.action.VIEW \
    -d "com.kingdomcall.app://oauth2redirect?code=test"

# iOS (Simulator)
xcrun simctl openurl booted "com.kingdomcall.app://oauth2redirect?code=test"
```

## Troubleshooting

### Code Generation Issues

If generated files are missing or outdated:
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Deep Linking Not Working

**Android:**
- Verify intent filters in AndroidManifest.xml
- Check if app is set as default handler: `adb shell dumpsys package d`
- Clear app data and reinstall

**iOS:**
- Verify URL schemes in Info.plist
- Check Associated Domains if using Universal Links
- Reinstall app

### Authentication Fails

1. Verify Keycloak server is accessible
2. Check Keycloak client configuration
3. Verify redirect URIs are correctly configured
4. Check app logs for error messages
5. Ensure PKCE is enabled in Keycloak client

### API Calls Fail

1. Verify backend URLs in environment variables
2. Check network connectivity
3. Verify JWT token is being sent (check logs)
4. Check API server CORS configuration
5. Verify SSL certificate pinning configuration

### Build Errors

Common issues:
- **Missing generated files**: Run code generation
- **Dependency conflicts**: Run `flutter pub get`
- **Gradle issues (Android)**: Clean gradle cache
- **CocoaPods issues (iOS)**: Run `pod install` in ios/ directory

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture documentation.

## Migration

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for migrating existing features to the new architecture.

## Key Files

- `lib/main.dart` - App entry point
- `lib/app_updated.dart` - Main app widget with auth integration
- `lib/core/auth/` - Authentication services
- `lib/core/network/` - API services and interceptors
- `lib/core/data/` - Base repository and data utilities
- `lib/features/` - Feature modules

## Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Implement Feature** following the architecture:
   - Create data models with Freezed
   - Create repository
   - Create Riverpod providers
   - Update UI

3. **Run Code Generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Test Your Changes**
   ```bash
   flutter test
   flutter run
   ```

5. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

## Performance Tips

1. **Use const constructors** where possible
2. **Enable code shrinking** in release builds
3. **Optimize images** (use WebP format)
4. **Lazy load** data using providers
5. **Cache API responses** for frequently accessed data
6. **Profile your app** using Flutter DevTools

## Security Considerations

- ✅ PKCE enabled for OAuth flow
- ✅ SSL certificate pinning configured
- ✅ Tokens stored in encrypted storage
- ✅ Automatic token refresh
- ✅ JWT validation before API calls

## Support

For issues or questions:
- Check documentation in `ARCHITECTURE.md` and `MIGRATION_GUIDE.md`
- Review example implementations in `lib/features/callcircle/` and `lib/features/courses/`
- Check Flutter and Riverpod documentation

## License

[Your License Here]
