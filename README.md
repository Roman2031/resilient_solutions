# Kingdom Call Circles - Flutter App

A comprehensive Flutter mobile application for the Kingdom Call Circles learning community platform, enabling faith-based call circles with integrated course management, real-time messaging, and administrative capabilities.

## 🌟 Features

### Core Features
- 🔐 **Secure Authentication** - Keycloak OIDC with OAuth 2.0
- ⭕ **Circle Management** - Create, join, and manage call circles
- 📞 **Call Coordination** - Schedule and manage call sessions
- 📝 **Notes & Actions** - Track notes and action items with accountability
- 💬 **Real-time Messaging** - BuddyBoss integration for community chat
- 📚 **Learning Management System** - Full course access with WordPress/LearnDash
- 🎥 **Video Player** - Integrated video lessons with progress tracking
- 📊 **Quiz Engine** - Interactive quizzes with instant feedback
- 🏆 **Certificates** - Automatic certificate generation on course completion
- 👑 **Admin Portal** - Comprehensive analytics and user management
- 📱 **Offline Support** - Local caching for offline access
- 🔔 **Push Notifications** - Firebase Cloud Messaging integration

### Technical Highlights
- **Clean Architecture** - Repository pattern with dependency injection
- **State Management** - Riverpod for reactive state management
- **RBAC** - Role-Based Access Control with granular permissions
- **Multi-Backend** - Laravel API, WordPress API, BuddyBoss API integration
- **86 API Endpoints** - Comprehensive backend integration
- **Production Ready** - Error handling, logging, monitoring, and analytics

## 📋 Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode for mobile development
- Active internet connection for API access

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/resilintsolutions/Final_project.git
cd Final_project/"Flutter App"
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configure Environment

Create environment-specific configuration or use default values:

```dart
// Development (default)
KEYCLOAK_BASE_URL=https://auth.kingdom.com
WORDPRESS_API_URL=https://learning.kingdominc.com/wp-json
CALL_SERVICE_API_URL=https://callcircle.resilentsolutions.com/api
ADMIN_PORTAL_API_URL=https://callcircle.resilentsolutions.com/api/v1/admin
```

### 5. Run the App

```bash
# Development
flutter run

# With specific environment variables
flutter run --dart-define=KEYCLOAK_BASE_URL=https://your-auth-server.com
```

## 🏗️ Project Structure

```
lib/
├── core/              # Core functionality
│   ├── auth/         # Authentication & RBAC
│   ├── config/       # Environment configuration
│   ├── error/        # Error handling
│   ├── logging/      # Logging system
│   ├── navigation/   # Routing
│   ├── network/      # API clients
│   ├── storage/      # Local database
│   └── widgets/      # Reusable widgets
├── features/         # Feature modules
│   ├── circles/      # Circle management
│   ├── calls/        # Call scheduling
│   ├── notes/        # Notes & actions
│   ├── messages/     # BuddyBoss chat
│   ├── courses/      # LMS integration
│   └── admin/        # Admin portal
└── main.dart         # App entry point
```

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Tests with Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Specific Tests

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests (requires device/emulator)
flutter test integration_test/
```

## 📦 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### iOS

```bash
# Build IPA
flutter build ios --release --obfuscate --split-debug-info=build/ios/symbols

# Then open Xcode to archive and submit
open ios/Runner.xcworkspace
```

### Web

```bash
flutter build web --release
```

## 🔧 Configuration

### Firebase Setup

1. Add `google-services.json` for Android in `android/app/`
2. Add `GoogleService-Info.plist` for iOS in `ios/Runner/`
3. Initialize Firebase in `main.dart`

### API Configuration

Update API endpoints in `lib/core/network/api_service.dart` or use environment variables.

## 📊 Architecture

### Clean Architecture Layers

1. **Presentation Layer** - UI widgets and state management
2. **Domain Layer** - Business logic and use cases
3. **Data Layer** - Repositories and data sources

### State Management

- **Riverpod** - For reactive state management
- **Provider Pattern** - For dependency injection
- **Repository Pattern** - For data access abstraction

### RBAC System

Roles:
- **SuperAdmin** - Full system access
- **Admin** - Administrative functions
- **Facilitator** - Circle management
- **Member** - Basic access

## 🔐 Security

- Secure token storage with `flutter_secure_storage`
- SSL pinning with `http_certificate_pinning`
- Code obfuscation enabled for production builds
- No sensitive data in logs (production mode)

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12.0+)
- ✅ Web (Chrome, Firefox, Safari, Edge)

## 🛠️ Development

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Run linter
flutter pub run custom_lint
```

### Git Workflow

1. Create feature branch from `develop`
2. Make changes with clear commits
3. Run tests and linting
4. Create pull request
5. CI/CD runs automatically
6. Merge after approval

## 📖 Documentation

- [Architecture Guide](ARCHITECTURE.md)
- [API Documentation](API_IMPLEMENTATION.md)
- [Deployment Guide](DEPLOYMENT.md)
- [Build Guide](BUILD_GUIDE.md)
- [Migration Guide](MIGRATION_GUIDE.md)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is proprietary software owned by Resilient Solutions.

## 👥 Team

- **Development Team** - Resilient Solutions
- **Project Lead** - Kingdom Call Circles

## 🐛 Bug Reports

For bug reports and feature requests, please create an issue in the repository.

## 📞 Support

For support, please contact the development team or refer to the documentation.
