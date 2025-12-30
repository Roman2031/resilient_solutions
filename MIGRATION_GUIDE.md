# Migration Guide: Refactoring Existing Features

## Overview
This guide helps migrate existing features to the new architecture with Keycloak authentication, repository pattern, and Riverpod state management.

## Step-by-Step Migration Process

### 1. Identify Feature Components

For each feature, identify:
- **Data Models** - What data structures does the feature use?
- **API Endpoints** - What APIs does it call?
- **State** - What state needs to be managed?
- **UI Components** - What screens/widgets exist?

### 2. Create Data Models with Freezed

**Old way:**
```dart
class User {
  final int id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
```

**New way:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Benefits:**
- Immutable by default
- Automatic `copyWith`, `==`, `hashCode`
- JSON serialization handled
- Null safety
- Type safety

### 3. Create Repository

**Old way:**
```dart
class UserService {
  final Dio dio;
  
  Future<User> getProfile() async {
    final response = await dio.get('/profile');
    return User.fromJson(response.data);
  }
}
```

**New way:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/data/base_repository.dart';
import '../../core/network/api_service.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(apiService);
}

class UserRepository extends BaseRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<User> getProfile() async {
    return execute(() async {
      final response = await _apiService.get('/users/profile');
      return handleResponse(
        response,
        (data) => User.fromJson(data['data']),
      );
    });
  }

  Future<void> updateProfile({
    String? name,
    String? email,
  }) async {
    return execute(() async {
      await _apiService.put(
        '/users/profile',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        },
      );
    });
  }
}
```

**Benefits:**
- Centralized error handling
- Automatic JWT injection
- Consistent API patterns
- Easy testing

### 4. Create Riverpod Providers

**Old way:**
```dart
class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await userService.getProfile();
    } catch (e) {
      // handle error
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
```

**New way:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<User> build() async {
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getProfile();
  }

  Future<void> updateProfile({String? name, String? email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      await repository.updateProfile(name: name, email: email);
      return await repository.getProfile();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      return await repository.getProfile();
    });
  }
}
```

**Benefits:**
- Loading/error states handled automatically
- Type-safe
- Auto-dispose when not used
- Easy to test

### 5. Update UI to Use Providers

**Old way:**
```dart
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    loadProfile();
  }
  
  Future<void> loadProfile() async {
    setState(() => isLoading = true);
    user = await userService.getProfile();
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) return CircularProgressIndicator();
    if (user == null) return Text('Error');
    return Text(user!.name);
  }
}
```

**New way:**
```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProfileProvider);

    return userAsyncValue.when(
      data: (user) => Column(
        children: [
          Text(user.name),
          Text(user.email),
          // More UI...
        ],
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () => ref.refresh(userProfileProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Benefits:**
- Declarative UI
- Automatic rebuild on state change
- Clean error handling
- Pull-to-refresh support

### 6. Run Code Generation

After creating models, repositories, and providers:

```bash
# Generate code once
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

This generates:
- `.freezed.dart` files for models
- `.g.dart` files for JSON serialization
- `.g.dart` files for Riverpod providers

## Example: Migrating Login Screen to Keycloak

### Old Login Screen
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(/* username */),
          TextField(/* password */),
          ElevatedButton(
            onPressed: () {
              // Manual login logic
              Navigator.push(context, MaterialPageRoute(...));
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### New Login Screen with Keycloak
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xff023C7B),
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                "assets/pngs/loginpagebg.png",
                fit: BoxFit.cover,
              ),
            ),
            
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/pngs/logo.png",
                  height: 90,
                  width: 249,
                ),
                const SizedBox(height: 50),
                
                // Keycloak Login Button
                ElevatedButton.icon(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(authRepositoryProvider.notifier)
                              .login();
                        },
                  icon: const Icon(Icons.login),
                  label: authState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login with Kingdom Call'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                ),
                
                // Show error if login fails
                if (authState.hasError)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      authState.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### What Changed:
1. **Removed username/password fields** - Keycloak handles authentication
2. **Single SSO button** - Opens Keycloak login page
3. **Automatic navigation** - App router handles redirect after auth
4. **State management** - Riverpod handles loading/error states
5. **Deep linking** - User returns to app after Keycloak login

## Updating App Router for Authentication

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth/auth_repository.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.when(
        data: (authState) => authState is AuthenticatedState,
        loading: () => false,
        error: (_, __) => false,
      );

      final isLoginRoute = state.matchedLocation == '/login';

      // Redirect to login if not authenticated
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      // Redirect to dashboard if authenticated and on login page
      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      // More routes...
    ],
  );
});
```

## Checklist for Each Feature

- [ ] Create data models with Freezed
- [ ] Create repository with base class
- [ ] Create Riverpod providers
- [ ] Run code generation
- [ ] Update UI to consume providers
- [ ] Test loading states
- [ ] Test error states
- [ ] Test success states
- [ ] Remove old code

## Common Patterns

### Loading State with Shimmer
```dart
userAsyncValue.when(
  data: (user) => UserCard(user: user),
  loading: () => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: UserCardSkeleton(),
  ),
  error: (error, _) => ErrorWidget(error),
)
```

### Pull to Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.refresh(userProfileProvider);
  },
  child: ListView(...),
)
```

### Pagination
```dart
@riverpod
class PaginatedUsers extends _$PaginatedUsers {
  int _page = 1;
  List<User> _users = [];

  @override
  Future<List<User>> build() async {
    final repository = ref.watch(userRepositoryProvider);
    _users = await repository.getUsers(page: _page);
    return _users;
  }

  Future<void> loadMore() async {
    _page++;
    final repository = ref.read(userRepositoryProvider);
    final newUsers = await repository.getUsers(page: _page);
    _users.addAll(newUsers);
    state = AsyncValue.data(_users);
  }
}
```

## Need Help?

Refer to:
- `ARCHITECTURE.md` for overall architecture
- Example implementations in `lib/features/callcircle/` and `lib/features/courses/`
- Riverpod docs: https://riverpod.dev
- Freezed docs: https://pub.dev/packages/freezed
