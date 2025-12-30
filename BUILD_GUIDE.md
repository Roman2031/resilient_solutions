# Complete Build Guide for Kingdom Call Circle Flutter App

## Prerequisites

### Required Software
- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio**: For Android builds
- **Xcode**: For iOS builds (macOS only)
- **VS Code or IntelliJ IDEA**: Recommended editors

### Installation Links
- Flutter: https://flutter.dev/docs/get-started/install
- Android Studio: https://developer.android.com/studio
- Xcode: https://developer.apple.com/xcode/

---

## Step 1: Install Flutter SDK

### Linux/macOS
```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter --version
flutter doctor
```

### Windows
```powershell
# Download from: https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter
# Add C:\flutter\bin to PATH
# Run flutter doctor
```

---

## Step 2: Setup Flutter Environment

```bash
# Navigate to project directory
cd "Flutter App"

# Get dependencies
flutter pub get

# Run code generation (REQUIRED)
flutter pub run build_runner build --delete-conflicting-outputs

# Verify setup
flutter doctor -v
```

---

## Step 3: Configure Environment Variables

Create `.env` file in the project root:

```env
# Keycloak Configuration
KEYCLOAK_BASE_URL=https://auth.kingdom.com/realms/KingdomStage
KEYCLOAK_CLIENT_ID=MobileApp
KEYCLOAK_REDIRECT_URI=myapp://com.kingdominc.learning/callback

# API URLs
WORDPRESS_BASE_URL=https://learning.kingdominc.com/wp-json
CALL_SERVICE_BASE_URL=https://callcircle.resilentsolutions.com/api
ADMIN_PORTAL_BASE_URL=https://callcircle.resilentsolutions.com/api/v1/admin

# Build Configuration
BUILD_MODE=release
```

---

## Step 4: Android Build Setup

### Configure Signing (for release builds)

1. **Generate Keystore**:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

2. **Create `android/key.properties`**:
```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<location-of-the-key-store-file>
```

3. **Update `android/app/build.gradle`** (if not already done):
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Build Android APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (split by ABI for smaller size)
flutter build apk --release --split-per-abi

# Release APK (universal - larger size)
flutter build apk --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
```

### Build Android App Bundle (AAB) for Google Play

```bash
# Build AAB (recommended for Play Store)
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

### Test on Android Device/Emulator

```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release -d <device-id>
```

---

## Step 5: iOS Build Setup (macOS only)

### Prerequisites
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

### Configure Code Signing

1. **Open Xcode**:
```bash
open ios/Runner.xcworkspace
```

2. **Configure in Xcode**:
   - Select "Runner" project in navigator
   - Select "Runner" target
   - Go to "Signing & Capabilities"
   - Select your development team
   - Ensure "Automatically manage signing" is checked
   - Update Bundle Identifier if needed: `com.kingdominc.learning`

### Build iOS IPA

```bash
# Build iOS app (requires Mac + Xcode)
flutter build ios --release --no-codesign

# For actual device deployment (requires Apple Developer account)
flutter build ipa --release

# Output location:
# build/ios/iphoneos/Runner.app (no codesign)
# build/ios/ipa/kingdom_call_circle.ipa (signed)
```

### Test on iOS Simulator/Device

```bash
# List iOS simulators
flutter devices

# Run on simulator
flutter run -d iPhone

# Run on physical device (requires provisioning)
flutter run -d <device-id> --release
```

---

## Step 6: Build for Web

```bash
# Build web app
flutter build web --release

# Output location:
# build/web/

# Test locally
cd build/web
python3 -m http.server 8000
# Open http://localhost:8000
```

---

## Step 7: Build Artifacts Summary

After successful builds, you'll have:

### Android
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk` (~50MB)
- **Release APK (arm64-v8a)**: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~15-20MB)
- **Release APK (armeabi-v7a)**: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (~15-20MB)
- **Release APK (x86_64)**: `build/app/outputs/flutter-apk/app-x86_64-release.apk` (~15-20MB)
- **Release AAB**: `build/app/outputs/bundle/release/app-release.aab` (~20MB)

### iOS
- **Debug App**: `build/ios/iphoneos/Runner.app`
- **Release IPA**: `build/ios/ipa/kingdom_call_circle.ipa` (~20-30MB)

### Web
- **Web Build**: `build/web/` directory

---

## Step 8: Continuous Integration (Automated Builds)

The project includes GitHub Actions CI/CD pipeline that automatically builds for all platforms.

### Trigger Build
```bash
# Push to main or develop branch
git push origin main

# Builds are triggered automatically
# View progress: GitHub > Actions tab
```

### Download Artifacts
After CI/CD completes:
1. Go to GitHub repository
2. Click "Actions" tab
3. Select the workflow run
4. Download artifacts:
   - `android-release-apk`
   - `ios-release-ipa`
   - `web-build`

---

## Step 9: Code Generation (Required Before Build)

```bash
# Generate Freezed models and Riverpod providers
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 10: Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

---

## Troubleshooting

### Common Issues

#### 1. "Command not found: flutter"
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
# Or install Flutter: https://flutter.dev/docs/get-started/install
```

#### 2. "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

#### 3. "CocoaPods install failed" (iOS)
```bash
cd ios
pod repo update
pod install
cd ..
```

#### 4. "Build runner conflicts"
```bash
flutter pub run build_runner clean
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 5. "Out of memory during build"
```bash
# Increase Gradle memory (android/gradle.properties)
org.gradle.jvmargs=-Xmx4096m

# Close other applications during build
```

---

## Build Commands Quick Reference

```bash
# Setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Android
flutter build apk --release --split-per-abi          # APK
flutter build appbundle --release                     # AAB for Play Store

# iOS (macOS only)
flutter build ios --release --no-codesign            # Without signing
flutter build ipa --release                           # With signing (requires cert)

# Web
flutter build web --release

# Development
flutter run                                           # Debug mode
flutter run --release                                 # Release mode

# Clean
flutter clean                                         # Clean build artifacts
flutter pub cache repair                              # Repair package cache
```

---

## Build Size Optimization

```bash
# Enable code shrinking and obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

flutter build ipa --release --obfuscate --split-debug-info=build/debug-info

# Analyze app size
flutter build apk --release --analyze-size
```

---

## Distribution

### Android
- **Google Play Store**: Upload `app-release.aab`
- **Direct Distribution**: Share `app-arm64-v8a-release.apk`
- **Testing**: Use Firebase App Distribution or TestFlight alternative

### iOS
- **App Store**: Submit `kingdom_call_circle.ipa` via App Store Connect
- **TestFlight**: Upload IPA for beta testing
- **Enterprise**: Use enterprise distribution certificate

### Web
- **Deploy**: Upload `build/web/` to web hosting
- **Docker**: Use included Dockerfile for containerized deployment
- **Kubernetes**: Use included K8s manifests

---

## Next Steps After Build

1. **Test the builds** on real devices
2. **Configure Keycloak** realm and clients
3. **Test authentication** flow
4. **Verify API** integrations
5. **Submit to stores** (if approved)

---

## Support

For issues or questions:
- Review `SETUP.md` for environment setup
- Check `TROUBLESHOOTING.md` for common problems
- See `DEPLOYMENT.md` for production deployment
- Review `INTEGRATION_MAP.md` for API integration details

---

**Last Updated**: December 2025
**Flutter Version**: 3.8.1+
**Dart Version**: 2.19.0+
