import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/keycloak_config.dart';

/// Keycloak OIDC Authentication Service
/// Implements OAuth 2.0 Authorization Code Flow with PKCE
/// 
/// Based on system architecture:
/// - App -> Keycloak (OIDC Auth Code + PKCE)
/// - Secure token storage
/// - Auto token refresh
class KeycloakAuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Secure storage keys
  static const String _accessTokenKey = 'keycloak_access_token';
  static const String _refreshTokenKey = 'keycloak_refresh_token';
  static const String _idTokenKey = 'keycloak_id_token';
  static const String _tokenExpiryKey = 'keycloak_token_expiry';

  /// Initiates the OAuth 2.0 Authorization Code Flow with PKCE
  /// Opens browser for user authentication and returns to app via deep link
  Future<AuthTokens?> login() async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          KeycloakConfig.clientId,
          KeycloakConfig.redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: KeycloakConfig.authorizationEndpoint,
            tokenEndpoint: KeycloakConfig.tokenEndpoint,
            endSessionEndpoint: KeycloakConfig.endSessionEndpoint,
          ),
          scopes: KeycloakConfig.scopes,
          promptValues: ['login'], // Force login prompt
          additionalParameters: {
            'code_challenge_method': 'S256', // PKCE
          },
        ),
      );

      if (result != null) {
        final tokens = AuthTokens(
          accessToken: result.accessToken!,
          refreshToken: result.refreshToken,
          idToken: result.idToken,
          accessTokenExpirationDateTime: result.accessTokenExpirationDateTime,
        );

        await _saveTokens(tokens);
        return tokens;
      }

      return null;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  /// Logout user and revoke tokens
  Future<void> logout() async {
    try {
      final idToken = await getIdToken();
      
      if (idToken != null) {
        await _appAuth.endSession(
          EndSessionRequest(
            idTokenHint: idToken,
            postLogoutRedirectUrl: KeycloakConfig.postLogoutRedirectUrl,
            serviceConfiguration: AuthorizationServiceConfiguration(
              authorizationEndpoint: KeycloakConfig.authorizationEndpoint,
              tokenEndpoint: KeycloakConfig.tokenEndpoint,
              endSessionEndpoint: KeycloakConfig.endSessionEndpoint,
            ),
          ),
        );
      }

      await clearTokens();
    } catch (e) {
      // Clear tokens even if logout fails
      await clearTokens();
      throw AuthException('Logout failed: $e');
    }
  }

  /// Refresh access token using refresh token
  Future<AuthTokens?> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      
      if (refreshToken == null) {
        throw AuthException('No refresh token available');
      }

      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          KeycloakConfig.clientId,
          KeycloakConfig.redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: KeycloakConfig.authorizationEndpoint,
            tokenEndpoint: KeycloakConfig.tokenEndpoint,
            endSessionEndpoint: KeycloakConfig.endSessionEndpoint,
          ),
          refreshToken: refreshToken,
          scopes: KeycloakConfig.scopes,
        ),
      );

      if (result != null) {
        final tokens = AuthTokens(
          accessToken: result.accessToken!,
          refreshToken: result.refreshToken,
          idToken: result.idToken,
          accessTokenExpirationDateTime: result.accessTokenExpirationDateTime,
        );

        await _saveTokens(tokens);
        return tokens;
      }

      return null;
    } catch (e) {
      throw AuthException('Token refresh failed: $e');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    // Check if token is expired
    if (isTokenExpired(accessToken)) {
      // Try to refresh token
      try {
        final tokens = await refreshToken();
        return tokens != null;
      } catch (e) {
        return false;
      }
    }

    return true;
  }

  /// Get valid access token (auto-refresh if needed)
  Future<String?> getValidAccessToken() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    // Check if token needs refresh
    if (_shouldRefreshToken(accessToken)) {
      try {
        final tokens = await refreshToken();
        return tokens?.accessToken;
      } catch (e) {
        return null;
      }
    }

    return accessToken;
  }

  /// Check if token should be refreshed (before expiry threshold)
  bool _shouldRefreshToken(String token) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      final timeUntilExpiry = expiryDate.difference(now).inSeconds;
      
      return timeUntilExpiry < KeycloakConfig.tokenRefreshThreshold;
    } catch (e) {
      return true; // Refresh if we can't determine expiry
    }
  }

  /// Check if token is expired
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  /// Get user info from ID token
  Map<String, dynamic>? getUserInfo() {
    final idToken = _secureStorage.read(key: _idTokenKey);
    if (idToken == null) return null;

    try {
      return JwtDecoder.decode(idToken as String);
    } catch (e) {
      return null;
    }
  }

  // Token storage methods
  Future<void> _saveTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    
    if (tokens.refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    }
    
    if (tokens.idToken != null) {
      await _secureStorage.write(key: _idTokenKey, value: tokens.idToken);
    }
    
    if (tokens.accessTokenExpirationDateTime != null) {
      await _secureStorage.write(
        key: _tokenExpiryKey,
        value: tokens.accessTokenExpirationDateTime!.toIso8601String(),
      );
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<String?> getIdToken() async {
    return await _secureStorage.read(key: _idTokenKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _idTokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
  }
}

/// Authentication tokens model
class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? accessTokenExpirationDateTime;

  AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpirationDateTime,
  });
}

/// Custom auth exception
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
