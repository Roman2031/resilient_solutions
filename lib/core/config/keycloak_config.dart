/// Keycloak OIDC Configuration
/// Based on the PlantUML architecture: App -> Keycloak (OIDC Auth Code + PKCE)
/// 
/// Client Details:
/// - Client ID: MobileApp
/// - Deep Link: myapp://com.kingdominc.learning/callback
/// - Auth URL: https://auth.kingdom.com/realms/KingdomStage/
class KeycloakConfig {
  KeycloakConfig._();

  // Keycloak Server Configuration
  static const String keycloakBaseUrl = String.fromEnvironment(
    'KEYCLOAK_BASE_URL',
    defaultValue: 'https://auth.kingdom.com',
  );
  
  static const String realm = String.fromEnvironment(
    'KEYCLOAK_REALM',
    defaultValue: 'KingdomStage',
  );
  
  static const String clientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'MobileApp',
  );

  // OIDC Endpoints
  static String get authorizationEndpoint =>
      '$keycloakBaseUrl/realms/$realm/protocol/openid-connect/auth';
  
  static String get tokenEndpoint =>
      '$keycloakBaseUrl/realms/$realm/protocol/openid-connect/token';
  
  static String get endSessionEndpoint =>
      '$keycloakBaseUrl/realms/$realm/protocol/openid-connect/logout';
  
  static String get userInfoEndpoint =>
      '$keycloakBaseUrl/realms/$realm/protocol/openid-connect/userinfo';
  
  static String get jwksUri =>
      '$keycloakBaseUrl/realms/$realm/protocol/openid-connect/certs';

  // Deep Link Configuration for OAuth Redirect
  static const String redirectUrl = 'myapp://com.kingdominc.learning/callback';
  static const String postLogoutRedirectUrl = 'myapp://com.kingdominc.learning/logout';

  // OAuth Scopes
  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
    'offline_access', // For refresh tokens
  ];

  // PKCE Configuration (required for mobile apps)
  static const bool usePkce = true;
  
  // Token refresh threshold (in seconds before expiry)
  static const int tokenRefreshThreshold = 300; // 5 minutes
}
