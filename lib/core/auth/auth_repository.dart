import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'keycloak_auth_service.dart';
import 'token_parser.dart';
import 'models/user_role.dart';

part 'auth_repository.g.dart';

/// Authentication Repository
/// Manages authentication state, user permissions, and coordinates with Keycloak service
@riverpod
class AuthRepository extends _$AuthRepository {
  late final KeycloakAuthService _authService;

  @override
  Future<AuthState> build() async {
    _authService = KeycloakAuthService();
    
    // Check if user is already authenticated on app start
    final isAuth = await _authService.isAuthenticated();
    
    if (isAuth) {
      final accessToken = await _authService.getValidAccessToken();
      final idToken = await _authService.getIdToken();
      
      if (accessToken != null && idToken != null) {
        // Parse token and extract permissions
        final permissions = TokenParser.parseToken(idToken);
        final userInfo = TokenParser.extractUserInfo(idToken);
        
        return AuthState.authenticated(
          accessToken: accessToken,
          idToken: idToken,
          permissions: permissions,
          userInfo: userInfo,
        );
      }
    }
    
    return const AuthState.unauthenticated();
  }

  /// Login with Keycloak OIDC
  Future<void> login() async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final tokens = await _authService.login();
      
      if (tokens == null) {
        throw AuthException('Login cancelled or failed');
      }
      
      // Parse token and extract permissions
      final permissions = TokenParser.parseToken(tokens.idToken!);
      final userInfo = TokenParser.extractUserInfo(tokens.idToken!);
      
      return AuthState.authenticated(
        accessToken: tokens.accessToken,
        idToken: tokens.idToken!,
        permissions: permissions,
        userInfo: userInfo,
      );
    });
  }

  /// Logout
  Future<void> logout() async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      await _authService.logout();
      return const AuthState.unauthenticated();
    });
  }

  /// Refresh token
  Future<void> refreshToken() async {
    state = await AsyncValue.guard(() async {
      final tokens = await _authService.refreshToken();
      
      if (tokens == null) {
        throw AuthException('Token refresh failed');
      }
      
      // Parse token and extract permissions
      final permissions = TokenParser.parseToken(tokens.idToken!);
      final userInfo = TokenParser.extractUserInfo(tokens.idToken!);
      
      return AuthState.authenticated(
        accessToken: tokens.accessToken,
        idToken: tokens.idToken!,
        permissions: permissions,
        userInfo: userInfo,
      );
    });
  }

  /// Get current user permissions
  UserPermissions? getPermissions() {
    return state.value?.when(
      authenticated: (_, __, permissions, ___) => permissions,
      unauthenticated: () => null,
    );
  }

  /// Get current user info
  Map<String, dynamic>? getUserInfo() {
    return state.value?.when(
      authenticated: (_, __, ___, userInfo) => userInfo,
      unauthenticated: () => null,
    );
  }

  /// Get valid access token
  Future<String?> getAccessToken() async {
    return await _authService.getValidAccessToken();
  }

  /// Check authentication status
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }
}

/// Authentication State with RBAC support
sealed class AuthState {
  const AuthState();
  
  const factory AuthState.authenticated({
    required String accessToken,
    required String idToken,
    required UserPermissions permissions,
    required Map<String, dynamic> userInfo,
  }) = AuthenticatedState;
  
  const factory AuthState.unauthenticated() = UnauthenticatedState;

  T when<T>({
    required T Function(String accessToken, String idToken, UserPermissions permissions, Map<String, dynamic> userInfo) authenticated,
    required T Function() unauthenticated,
  }) {
    if (this is AuthenticatedState) {
      final state = this as AuthenticatedState;
      return authenticated(state.accessToken, state.idToken, state.permissions, state.userInfo);
    } else {
      return unauthenticated();
    }
  }
}

class AuthenticatedState extends AuthState {
  final String accessToken;
  final String idToken;
  final UserPermissions permissions;
  final Map<String, dynamic> userInfo;
  
  const AuthenticatedState({
    required this.accessToken,
    required this.idToken,
    required this.permissions,
    required this.userInfo,
  });
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

/// Provider for current user permissions
@riverpod
UserPermissions? userPermissions(UserPermissionsRef ref) {
  final authState = ref.watch(authRepositoryProvider);
  
  return authState.when(
    data: (state) => state.when(
      authenticated: (_, __, permissions, ___) => permissions,
      unauthenticated: () => null,
    ),
    loading: () => null,
    error: (_, __) => null,
  );
}
