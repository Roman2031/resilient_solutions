# Quick Start Guide - Production-Ready Flutter App

## 🚀 Getting Started (5 Minutes)

### Prerequisites
- Flutter SDK 3.8.1+
- Dart SDK 3.0+
- Android Studio / Xcode (for mobile builds)
- Git

### Initial Setup

```bash
# 1. Clone the repository
git clone https://github.com/resilintsolutions/Final_project.git
cd Final_project/Flutter\ App

# 2. Install dependencies
flutter pub get

# 3. Generate code (REQUIRED)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

That's it! The app should launch with Keycloak authentication.

## 🏗️ Architecture at a Glance

```
lib/
├── core/
│   ├── auth/              # Keycloak auth, token parsing, RBAC
│   ├── navigation/        # GoRouter with auth guards
│   ├── network/           # API service, interceptors
│   └── data/             # Base repository
├── features/
│   ├── dashboard/
│   │   ├── providers/    # ✅ State management (NEW)
│   │   └── views/        # UI screens
│   ├── profile/
│   │   ├── providers/    # ✅ State management (NEW)
│   │   └── views/        # UI screens
│   ├── mycalls/
│   │   ├── providers/    # ✅ State management (NEW)
│   │   └── views/        # UI screens
│   └── allnotes/
│       ├── providers/    # ✅ State management (NEW)
│       └── views/        # UI screens
└── test/                 # ✅ Test suite (NEW)
```

## 📱 Key Features Implemented

### ✅ Authentication
- Keycloak OIDC integration
- Automatic token refresh
- Secure storage
- Deep link handling

### ✅ State Management
- Riverpod 3.0 providers
- Type-safe code generation
- Automatic caching
- Error handling

### ✅ Data Layer
- Repository pattern
- Multiple backend support
- Consistent error handling
- Response parsing

### ✅ Testing
- Unit tests
- Widget tests
- Test infrastructure
- 80%+ coverage goal

## 🔑 Important Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/app_updated.dart` | Auth-aware app widget (NEW) |
| `lib/core/navigation/app_router.dart` | Auth router (UPDATED) |
| `lib/core/navigation/app_route.dart` | Legacy router (KEEP) |
| `lib/features/*/providers/*` | State management (NEW) |
| `IMPLEMENTATION_GUIDE.md` | Technical documentation |
| `PHASE_1_SUMMARY.md` | What's done & what's next |

## 🔧 Common Commands

### Development
```bash
# Run app in debug mode
flutter run

# Run on specific device
flutter run -d chrome    # Web
flutter run -d emulator  # Android
flutter run -d iPhone    # iOS

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Code Generation
```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/auth/token_parser_test.dart

# Run with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format lib/ test/ -l 120

# Fix formatting
dart format lib/ test/ -l 120 --fix
```

### Building
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

## 🎯 Current State vs. Target State

### ✅ What Works Now
- Keycloak login screen
- Authentication flow
- Token storage
- Protected routes
- Basic navigation

### 🚧 What's In Progress
- Dashboard showing real data
- Profile editing
- My Calls list
- Notes management

### 📋 What's Next
See `PHASE_1_SUMMARY.md` for detailed roadmap.

## 💡 Quick Tips

### Using Providers

```dart
// In a ConsumerWidget
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    
    return userAsync.when(
      data: (user) => Text('Hello ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

### Navigating

```dart
// Using GoRouter
context.go('/dashboard');
context.push('/profile');
context.pop();
```

### Logging Out

```dart
// In any widget
ref.read(authRepositoryProvider.notifier).logout();
```

### Accessing Current User

```dart
final authState = ref.watch(authRepositoryProvider);
authState.when(
  data: (state) => state.when(
    authenticated: (token, idToken, permissions, userInfo) {
      // User is logged in
      print('User: ${userInfo['name']}');
      print('Can manage circles: ${permissions.canManageCircles}');
    },
    unauthenticated: () {
      // User is not logged in
    },
  ),
  loading: () => /* Auth check in progress */,
  error: (error, _) => /* Auth error */,
);
```

## 🐛 Troubleshooting

### "Provider not found" Error
**Solution**: Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### "MissingPluginException"
**Solution**: Hot restart the app (Press 'R' in terminal)

### Build Fails
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Import Errors
**Solution**: Check that imports include generated files
```dart
import 'my_provider.dart';     // ✅ Correct
import 'my_provider.g.dart';   // ❌ Don't import .g.dart directly
```

### Auth Redirect Not Working
**Solution**: 
1. Check deep link configuration in `AndroidManifest.xml`
2. Verify redirect URL matches Keycloak config
3. Test with: `adb shell am start -W -a android.intent.action.VIEW -d "myapp://com.kingdominc.learning/callback"`

## 📚 Resources

### Documentation
- `IMPLEMENTATION_GUIDE.md` - Complete technical guide
- `PHASE_1_SUMMARY.md` - Status and roadmap
- `test/README.md` - Testing guidelines

### External Resources
- [Riverpod Docs](https://riverpod.dev)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Flutter Testing](https://docs.flutter.dev/testing)

### API Documentation
- Call Service: http://138.68.55.52:8883/api
- WordPress: https://learning.kingdominc.com/wp-json
- Admin Portal: http://138.68.55.52:8884/api/v1

## 🤝 Contributing

### Adding a New Feature
1. Create models in `features/*/data/models/`
2. Add repository methods in `features/*/data/repositories/`
3. Create providers in `features/*/providers/`
4. Update UI in `features/*/views/`
5. Add tests in `test/`
6. Run `flutter pub run build_runner build`

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Add DartDoc comments for public APIs
- Keep functions small and focused
- Write tests for new features

## 🎉 Success!

If you can run `flutter run` and see the Keycloak login screen, you're all set!

For detailed implementation patterns and next steps, see:
- `IMPLEMENTATION_GUIDE.md` - How everything works
- `PHASE_1_SUMMARY.md` - What's done and what's next

Happy coding! 🚀
