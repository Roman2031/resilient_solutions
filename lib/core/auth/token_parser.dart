import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'models/user_role.dart';

/// Parser for Keycloak JWT tokens
/// Extracts claims and builds UserPermissions
class TokenParser {
  /// Parse ID token and extract user permissions
  static UserPermissions parseToken(String idToken) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(idToken);
      final keycloakToken = KeycloakToken.fromJson(decodedToken);
      
      return _buildPermissions(keycloakToken);
    } catch (e) {
      throw TokenParseException('Failed to parse token: $e');
    }
  }

  /// Build UserPermissions from KeycloakToken
  static UserPermissions _buildPermissions(KeycloakToken token) {
    // Extract canonical roles from realm_access
    final List<UserRole> roles = _extractRoles(token.realmAccess.roles);
    
    // Extract mobile app specific roles
    final List<String> mobileRoles = _extractResourceRoles(
      token.resourceAccess,
      'app-callcircle',
    );
    
    // Extract portal specific roles
    final List<String> portalRoles = _extractResourceRoles(
      token.resourceAccess,
      'portal-callcircle',
    );
    
    // Compute API scopes from roles (union of all role scopes)
    final List<String> apiScopes = _computeApiScopes(roles);
    
    return UserPermissions(
      roles: roles,
      mobileRoles: mobileRoles,
      portalRoles: portalRoles,
      apiScopes: apiScopes,
      groups: token.groups ?? [],
      magentoId: token.magentoId,
    );
  }

  /// Extract UserRole enum from string roles
  static List<UserRole> _extractRoles(List<String> roleStrings) {
    final List<UserRole> roles = [];
    
    for (final roleString in roleStrings) {
      switch (roleString.toLowerCase()) {
        case 'learner':
          roles.add(UserRole.learner);
          break;
        case 'facilitator':
          roles.add(UserRole.facilitator);
          break;
        case 'instructor':
          roles.add(UserRole.instructor);
          break;
        case 'admin':
          roles.add(UserRole.admin);
          break;
      }
    }
    
    // If no roles found, default to learner
    if (roles.isEmpty) {
      roles.add(UserRole.learner);
    }
    
    return roles;
  }

  /// Extract resource-specific roles
  static List<String> _extractResourceRoles(
    Map<String, ResourceAccess>? resourceAccess,
    String clientId,
  ) {
    if (resourceAccess == null || !resourceAccess.containsKey(clientId)) {
      return [];
    }
    
    return resourceAccess[clientId]!.roles;
  }

  /// Compute API scopes from roles (union of permissions)
  /// Effective permissions are the union of mapped capabilities
  static List<String> _computeApiScopes(List<UserRole> roles) {
    final Set<String> scopes = {};
    
    for (final role in roles) {
      scopes.addAll(role.apiScopes);
    }
    
    return scopes.toList();
  }

  /// Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  /// Get token expiration time
  static DateTime? getTokenExpiration(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Get time until token expires (in seconds)
  static int? getTimeToExpiry(String token) {
    final expiration = getTokenExpiration(token);
    if (expiration == null) return null;
    
    final now = DateTime.now();
    return expiration.difference(now).inSeconds;
  }

  /// Check if token needs refresh (within threshold)
  static bool shouldRefreshToken(String token, {int thresholdSeconds = 300}) {
    final timeToExpiry = getTimeToExpiry(token);
    if (timeToExpiry == null) return true;
    
    return timeToExpiry < thresholdSeconds;
  }

  /// Extract user info from token
  static Map<String, dynamic> extractUserInfo(String idToken) {
    try {
      final decoded = JwtDecoder.decode(idToken);
      return {
        'sub': decoded['sub'],
        'email': decoded['email'],
        'name': decoded['name'],
        'locale': decoded['kc.locale'] ?? 'en',
        'magentoId': decoded['magentoId'],
      };
    } catch (e) {
      return {};
    }
  }
}

/// Exception thrown when token parsing fails
class TokenParseException implements Exception {
  final String message;
  
  TokenParseException(this.message);
  
  @override
  String toString() => 'TokenParseException: $message';
}
