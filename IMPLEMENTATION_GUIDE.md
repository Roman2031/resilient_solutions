# Production-Ready Implementation Guide

## Overview
This document describes the changes made to transform the Flutter app from a UI mockup into a production-ready application with complete backend integration, Keycloak authentication, and comprehensive state management.

## Architecture

### State Management
The app uses **Riverpod 3.0** with code generation for type-safe state management:

```dart
@riverpod
Future<UserProfile> currentUserProfile(CurrentUserProfileRef ref) async {
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }
  
  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getMe();
}
```

### Authentication Flow

1. **Keycloak OIDC Integration**
   - Uses OAuth 2.0 Authorization Code Flow with PKCE
   - Deep link handling for OAuth redirects
   - Automatic token refresh
   - Secure token storage with `flutter_secure_storage`

2. **Auth Guards**
   - Router-level authentication checks
   - Automatic redirect to login for unauthenticated users
   - Auto-navigation to dashboard after successful login

3. **RBAC (Role-Based Access Control)**
   - Token parsing extracts roles and permissions
   - `UserPermissions` class encapsulates all permission checks
   - UI elements conditionally rendered based on permissions
   - Server-side validation as ultimate authority

## Key Components

### 1. Providers

#### Dashboard Providers (`lib/features/dashboard/providers/dashboard_providers.dart`)
- `upcomingCallsProvider` - Fetches user's upcoming calls
- `currentUserProfileProvider` - Fetches current user profile
- `myActionItemsProvider` - Fetches pending action items
- `myCirclesProvider` - Fetches user's circles

#### Profile Providers (`lib/features/profile/providers/profile_providers.dart`)
- `userProfileProvider` - Cached user profile data
- `ProfileUpdateNotifier` - Handles profile updates with optimistic updates

#### My Calls Providers (`lib/features/mycalls/providers/mycalls_providers.dart`)
- `myCallsProvider` - Fetches all user's calls
- `filteredCallsProvider` - Filters calls by status
- `CallStatusFilterNotifier` - Manages filter state
- `callByIdProvider` - Fetches individual call details
- `callNotesProvider` - Fetches notes for a specific call

#### Notes Providers (`lib/features/allnotes/providers/notes_providers.dart`)
- `allNotesProvider` - Aggregates notes across all calls
- `NoteActionsNotifier` - Handles note CRUD operations
- `notesByCallProvider` - Fetches notes for a specific call

### 2. Router (`lib/core/navigation/app_route.dart`)

Enhanced router with:
- Authentication-aware redirects
- Protected route handling
- Refresh on auth state changes
- Deep link support

```dart
static GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: Routes.keycloakLogin,
    redirect: (context, state) {
      final isAuthenticated = /* check auth state */;
      // Redirect logic
    },
    refreshListenable: _GoRouterRefreshStream(
      ref.read(authRepositoryProvider.notifier).stream,
    ),
    routes: [/* routes */],
  );
}
```

### 3. Repositories

All repositories extend `BaseRepository` which provides:
- Error handling
- Response parsing
- List response handling
- Consistent error types

Example:
```dart
class CallServiceRepository extends BaseRepository {
  Future<UserProfile> getMe() async {
    return execute(() async {
      final response = await _apiService.get('/me');
      return handleResponse(response, (data) => UserProfile.fromJson(data));
    });
  }
}
```

## API Integration

### Backend Endpoints

1. **Call Service Laravel** (http://138.68.55.52:8883/api)
   - User profile: `GET /me`, `PUT /me/profile`
   - Circles: `GET /circles`, `POST /circles`, `PUT /circles/{id}`
   - Calls: `GET /circles/{circle}/calls`, `POST /circles/{circle}/calls`
   - Notes: `GET /calls/{call}/notes`, `POST /calls/{call}/notes`
   - Members: `GET /circles/{circle}/members`, `POST /circles/{circle}/members`

2. **WordPress/LearnDash/BuddyBoss** (https://learning.kingdominc.com/wp-json)
   - Courses: `GET /ldlms/v2/sfwd-courses`
   - Messages: `GET /buddyboss/v1/messages`

3. **Admin Portal Laravel** (http://138.68.55.52:8884/api/v1)
   - User management: `GET /admin/users`, `PATCH /admin/users/{user}/roles`

### Error Handling

All API calls are wrapped in error handling:

```dart
return execute(() async {
  final response = await _apiService.get('/endpoint');
  return handleResponse(response, (data) => Model.fromJson(data));
});
```

Errors are caught and converted to user-friendly messages in the UI.

## Data Flow

### Example: Fetching User Profile

1. Screen consumes provider:
   ```dart
   final profileAsync = ref.watch(userProfileProvider);
   ```

2. Provider fetches from repository:
   ```dart
   @riverpod
   Future<UserProfile> userProfile(UserProfileRef ref) async {
     final repository = ref.watch(callServiceRepositoryProvider);
     return await repository.getMe();
   }
   ```

3. Repository calls API:
   ```dart
   Future<UserProfile> getMe() async {
     return execute(() async {
       final response = await _apiService.get('/me');
       return handleResponse(response, (data) => UserProfile.fromJson(data));
     });
   }
   ```

4. UI renders based on state:
   ```dart
   profileAsync.when(
     data: (profile) => ProfileView(profile),
     loading: () => LoadingIndicator(),
     error: (error, stack) => ErrorView(error),
   );
   ```

## Testing Strategy

### Unit Tests
- **Location**: `test/unit/`
- **Coverage**: Repositories, token parser, permission guards
- **Example**: `test/unit/auth/token_parser_test.dart`

### Widget Tests
- **Location**: `test/widget/`
- **Coverage**: UI components, user interactions
- **Example**: `test/widget/keycloak_login_screen_test.dart`

### Integration Tests
- **Location**: `test/integration/`
- **Coverage**: End-to-end user flows
- **Planned**: Auth flow, circle creation, call scheduling

### Running Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific file
flutter test test/unit/auth/token_parser_test.dart
```

## Code Generation

The app uses several code generators:

```bash
# Generate all files
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
flutter pub run build_runner watch
```

Generated files (excluded from git):
- `*.g.dart` - Riverpod providers
- `*.freezed.dart` - Freezed models
- `*.config.dart` - Build configuration

## Security Considerations

1. **Token Storage**
   - Access/refresh tokens stored in secure storage
   - Never logged or exposed in UI
   - Auto-refresh before expiry

2. **SSL Pinning**
   - Certificate pinning for production endpoints
   - Configured in `lib/core/network/ssl_pinning.dart`

3. **RBAC Enforcement**
   - Client-side checks for UX (hiding features)
   - Server-side validation as ultimate authority
   - Permission checks before sensitive operations

## Performance Optimizations

1. **Caching**
   - Riverpod automatically caches provider results
   - Manual invalidation on mutations
   - TTL-based cache for API responses (planned)

2. **Pagination**
   - List endpoints support pagination
   - Infinite scroll with `perPage` parameter
   - Cursor-based pagination for large datasets

3. **Lazy Loading**
   - Images loaded with `cached_network_image`
   - Routes loaded on-demand
   - Data fetched only when screen is visible

## Development Workflow

### Adding a New Feature

1. **Create Models** (if needed)
   ```dart
   @freezed
   class MyModel with _$MyModel {
     const factory MyModel({required String name}) = _MyModel;
     factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);
   }
   ```

2. **Add Repository Methods**
   ```dart
   Future<MyModel> getMyData() async {
     return execute(() async {
       final response = await _apiService.get('/my-endpoint');
       return handleResponse(response, (data) => MyModel.fromJson(data));
     });
   }
   ```

3. **Create Providers**
   ```dart
   @riverpod
   Future<MyModel> myData(MyDataRef ref) async {
     final repository = ref.watch(callServiceRepositoryProvider);
     return await repository.getMyData();
   }
   ```

4. **Update UI**
   ```dart
   final myDataAsync = ref.watch(myDataProvider);
   return myDataAsync.when(
     data: (data) => MyDataView(data),
     loading: () => LoadingIndicator(),
     error: (error, _) => ErrorView(error),
   );
   ```

5. **Add Tests**
   ```dart
   test('myData provider fetches data', () async {
     // Test implementation
   });
   ```

6. **Run Code Generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Deployment

### Build Commands

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# All platforms (using script)
./build_apps.sh
```

### Environment Configuration

Set environment variables for different environments:

```bash
flutter build apk --release \
  --dart-define=KEYCLOAK_BASE_URL=https://auth.kingdom.com \
  --dart-define=KEYCLOAK_REALM=KingdomProd \
  --dart-define=CALL_SERVICE_API_URL=https://api.kingdom.com
```

## Troubleshooting

### Common Issues

1. **Code generation fails**
   - Delete `.dart_tool` and `build` directories
   - Run `flutter clean && flutter pub get`
   - Try again with `flutter pub run build_runner build --delete-conflicting-outputs`

2. **Provider not found**
   - Ensure code generation has run
   - Check imports include `.g.dart` file
   - Verify provider is wrapped in `ProviderScope`

3. **Authentication redirects not working**
   - Check deep link configuration in Android/iOS
   - Verify redirect URL matches Keycloak config
   - Check router redirect logic

4. **API calls failing**
   - Verify network connectivity
   - Check API URL configuration
   - Validate token is being sent
   - Review API endpoint and HTTP method

## Next Steps

### Phase 2: Screen Updates
- Update all screens to use providers
- Add pull-to-refresh
- Implement error/loading states
- Add empty states

### Phase 3: Advanced Features
- Real-time updates (WebSocket or polling)
- Offline mode support
- Push notifications
- Advanced search/filtering

### Phase 4: Polish
- Animations and transitions
- Skeleton loaders
- Enhanced error messages
- Performance monitoring

## Resources

- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Keycloak OIDC](https://www.keycloak.org/docs/latest/securing_apps/#_oidc)
