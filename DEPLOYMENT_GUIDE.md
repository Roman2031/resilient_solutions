# Deployment Guide

Comprehensive guide for deploying the Kingdom Call Circles Flutter application to production environments.

## Table of Contents

1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Environment Setup](#environment-setup)
3. [Building for Production](#building-for-production)
4. [Android Deployment](#android-deployment)
5. [iOS Deployment](#ios-deployment)
6. [Web Deployment](#web-deployment)
7. [CI/CD Setup](#cicd-setup)
8. [Post-Deployment](#post-deployment)
9. [Rollback Procedures](#rollback-procedures)

## Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing (`flutter test`)
- [ ] Code analysis clean (`flutter analyze`)
- [ ] Code formatted (`dart format .`)
- [ ] No debug print statements
- [ ] All TODOs resolved or documented
- [ ] Code coverage ≥ 80%

### Configuration
- [ ] Environment variables configured for production
- [ ] API endpoints pointing to production servers
- [ ] Firebase project configured for production
- [ ] SSL certificates valid
- [ ] App signing certificates ready

### Security
- [ ] Sensitive data removed from code
- [ ] API keys moved to secure storage
- [ ] SSL pinning configured
- [ ] Code obfuscation enabled
- [ ] ProGuard rules configured (Android)

### Testing
- [ ] Unit tests passing
- [ ] Widget tests passing
- [ ] Integration tests passing
- [ ] Manual QA completed
- [ ] Performance testing done
- [ ] Security audit passed

### Documentation
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] API documentation current
- [ ] User guide prepared
- [ ] Release notes written

## Environment Setup

### Production Environment Variables

```bash
# Keycloak Authentication
export KEYCLOAK_BASE_URL="https://auth.kingdom.com"
export KEYCLOAK_REALM="KingdomStage"
export KEYCLOAK_CLIENT_ID="MobileApp"

# Backend APIs
export WORDPRESS_API_URL="https://learning.kingdominc.com/wp-json"
export CALL_SERVICE_API_URL="https://callcircle.resilentsolutions.com/api"
export ADMIN_PORTAL_API_URL="https://callcircle.resilentsolutions.com/api/v1/admin"
```

### Firebase Configuration

1. Download production Firebase configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS

2. Place files in appropriate directories:
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```

3. Verify Firebase services enabled:
   - Analytics
   - Crashlytics
   - Cloud Messaging
   - Performance Monitoring
   - Remote Config

## Building for Production

### Dependencies

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Generate assets
flutter pub run build_runner build
```

### Build Commands

#### Android

```bash
# Build APK (for testing)
flutter build apk --release \
  --dart-define=KEYCLOAK_BASE_URL=$KEYCLOAK_BASE_URL \
  --dart-define=KEYCLOAK_REALM=$KEYCLOAK_REALM \
  --dart-define=KEYCLOAK_CLIENT_ID=$KEYCLOAK_CLIENT_ID \
  --dart-define=WORDPRESS_API_URL=$WORDPRESS_API_URL \
  --dart-define=CALL_SERVICE_API_URL=$CALL_SERVICE_API_URL \
  --dart-define=ADMIN_PORTAL_API_URL=$ADMIN_PORTAL_API_URL

# Build App Bundle (for Play Store)
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=KEYCLOAK_BASE_URL=$KEYCLOAK_BASE_URL \
  --dart-define=KEYCLOAK_REALM=$KEYCLOAK_REALM \
  --dart-define=KEYCLOAK_CLIENT_ID=$KEYCLOAK_CLIENT_ID \
  --dart-define=WORDPRESS_API_URL=$WORDPRESS_API_URL \
  --dart-define=CALL_SERVICE_API_URL=$CALL_SERVICE_API_URL \
  --dart-define=ADMIN_PORTAL_API_URL=$ADMIN_PORTAL_API_URL
```

#### iOS

```bash
# Build iOS release
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/ios/symbols \
  --dart-define=KEYCLOAK_BASE_URL=$KEYCLOAK_BASE_URL \
  --dart-define=KEYCLOAK_REALM=$KEYCLOAK_REALM \
  --dart-define=KEYCLOAK_CLIENT_ID=$KEYCLOAK_CLIENT_ID \
  --dart-define=WORDPRESS_API_URL=$WORDPRESS_API_URL \
  --dart-define=CALL_SERVICE_API_URL=$CALL_SERVICE_API_URL \
  --dart-define=ADMIN_PORTAL_API_URL=$ADMIN_PORTAL_API_URL
```

#### Web

```bash
# Build web release
flutter build web --release \
  --dart-define=KEYCLOAK_BASE_URL=$KEYCLOAK_BASE_URL \
  --dart-define=KEYCLOAK_REALM=$KEYCLOAK_REALM \
  --dart-define=KEYCLOAK_CLIENT_ID=$KEYCLOAK_CLIENT_ID \
  --dart-define=WORDPRESS_API_URL=$WORDPRESS_API_URL \
  --dart-define=CALL_SERVICE_API_URL=$CALL_SERVICE_API_URL \
  --dart-define=ADMIN_PORTAL_API_URL=$ADMIN_PORTAL_API_URL
```

## Android Deployment

### 1. Prepare App Signing

#### Generate Upload Key

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -storepass [STORE_PASSWORD] \
  -keypass [KEY_PASSWORD]
```

#### Configure Gradle

Create `android/key.properties`:

```properties
storePassword=[STORE_PASSWORD]
keyPassword=[KEY_PASSWORD]
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

### 2. Build Configuration

Update `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.kingdominc.callcircles"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 3. Google Play Store Submission

1. **Create App Listing**
   - App name, description, screenshots
   - Feature graphic (1024x500)
   - App icon (512x512)

2. **Upload App Bundle**
   - Internal testing track first
   - Alpha/Beta track for testing
   - Production track when ready

3. **Complete Store Listing**
   - Privacy policy URL
   - Content rating questionnaire
   - Target audience
   - Category selection

## iOS Deployment

### 1. Xcode Configuration

```bash
# Open project in Xcode
open ios/Runner.xcworkspace
```

### 2. Configure Signing

1. Select Runner target
2. Go to Signing & Capabilities
3. Select Team
4. Configure Bundle Identifier
5. Enable capabilities:
   - Push Notifications
   - Background Modes
   - Associated Domains

### 3. Archive and Upload

1. Product → Archive
2. Distribute App
3. App Store Connect
4. Upload
5. Submit for review

### 4. App Store Connect

1. **App Information**
   - Name, subtitle, description
   - Keywords, support URL
   - Privacy policy URL

2. **Prepare for Submission**
   - Screenshots (required sizes)
   - App preview videos
   - What's new description

3. **Pricing and Availability**
   - Price tier
   - Countries/regions
   - Release date

## Web Deployment

### Using Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init hosting

# Deploy
firebase deploy --only hosting
```

### Using Docker

```dockerfile
FROM nginx:alpine

COPY build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

```bash
# Build Docker image
docker build -t kingdom-call-web .

# Run container
docker run -p 80:80 kingdom-call-web
```

## CI/CD Setup

### GitHub Actions (Already Configured)

The project includes a comprehensive CI/CD pipeline:

- Automated testing on push/PR
- Code quality checks
- Multi-platform builds (Android, iOS, Web)
- Artifact uploads
- Deployment to staging/production

### Manual Trigger

```bash
# Trigger workflow manually
gh workflow run "Flutter CI/CD Pipeline"
```

## Post-Deployment

### Monitoring

1. **Firebase Crashlytics**
   - Monitor crash rates
   - Review crash reports
   - Track affected users

2. **Firebase Analytics**
   - Monitor user engagement
   - Track feature usage
   - Analyze user flows

3. **Performance Monitoring**
   - Track app start time
   - Monitor network requests
   - Identify slow screens

### Verification Steps

- [ ] App launches successfully
- [ ] Authentication works
- [ ] API calls succeed
- [ ] Push notifications deliver
- [ ] Analytics tracking works
- [ ] No critical crashes
- [ ] Performance metrics normal

### Rollout Strategy

1. **Internal Testing** (10 users)
   - Development team testing
   - Basic functionality verification

2. **Alpha Testing** (100 users)
   - Extended team + early adopters
   - Feature testing
   - Performance monitoring

3. **Beta Testing** (1000 users)
   - Wider audience
   - Load testing
   - Feedback collection

4. **Staged Rollout** (Production)
   - 10% of users (Day 1-2)
   - 25% of users (Day 3-4)
   - 50% of users (Day 5-6)
   - 100% of users (Day 7)

## Rollback Procedures

### Android

1. Go to Google Play Console
2. Navigate to Release Management → App releases
3. Select Production track
4. Click "Roll back to previous version"
5. Confirm rollback

### iOS

1. Go to App Store Connect
2. Navigate to App Store → Versions
3. Select previous version
4. Click "Submit for Review"
5. Provide reason for rollback

### Web

```bash
# Rollback to previous deployment
firebase hosting:rollback

# Or deploy specific version
git checkout [previous-tag]
flutter build web --release
firebase deploy --only hosting
```

## Troubleshooting

### Build Issues

```bash
# Clean and rebuild
flutter clean
rm -rf ios/Pods
rm ios/Podfile.lock
flutter pub get
cd ios && pod install --repo-update
cd ..
flutter build [platform] --release
```

### Certificate Issues

- Verify certificate expiration dates
- Check provisioning profiles
- Regenerate certificates if needed
- Update keystore passwords

### API Connection Issues

- Verify API endpoints are accessible
- Check SSL certificates
- Verify environment variables
- Test with cURL/Postman first

## Support Contacts

- **Development Team**: dev@resilentsolutions.com
- **DevOps**: devops@resilentsolutions.com
- **Project Manager**: pm@resilentsolutions.com

## Additional Resources

- [Flutter Deployment Documentation](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://developer.apple.com/app-store-connect/)
- [Firebase Console](https://console.firebase.google.com/)
