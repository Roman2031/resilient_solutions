/// Environment configuration for different deployment stages
/// 
/// Supports development, staging, and production environments
/// with appropriate API URLs and feature flags
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  /// Set the current environment
  static void setEnvironment(Environment env) {
    _environment = env;
  }

  /// Get the current environment
  static Environment get environment => _environment;

  /// API Base URL for Laravel Call Service
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'CALL_SERVICE_API_URL',
          defaultValue: 'https://callcircle.resilentsolutions.com/api',
        );
      case Environment.staging:
        return 'https://staging-api.kingdominc.com';
      case Environment.production:
        return 'https://callcircle.resilentsolutions.com/api';
    }
  }

  /// Keycloak Authentication URL
  static String get keycloakUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'KEYCLOAK_BASE_URL',
          defaultValue: 'https://auth.kingdom.com',
        );
      case Environment.staging:
        return 'https://staging-auth.kingdominc.com';
      case Environment.production:
        return 'https://auth.kingdom.com';
    }
  }

  /// WordPress + LearnDash API URL
  static String get wordpressApiUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'WORDPRESS_API_URL',
          defaultValue: 'https://learning.kingdominc.com/wp-json',
        );
      case Environment.staging:
        return 'https://staging-learning.kingdominc.com/wp-json';
      case Environment.production:
        return 'https://learning.kingdominc.com/wp-json';
    }
  }

  /// Admin Portal API URL
  static String get adminPortalApiUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'ADMIN_PORTAL_API_URL',
          defaultValue: 'https://callcircle.resilentsolutions.com/api/v1/admin',
        );
      case Environment.staging:
        return 'https://staging-admin.kingdominc.com/api/v1';
      case Environment.production:
        return 'https://callcircle.resilentsolutions.com/api/v1/admin';
    }
  }

  /// Enable detailed logging (disable in production)
  static bool get enableLogging => _environment != Environment.production;

  /// Enable debug features
  static bool get enableDebugFeatures => _environment == Environment.development;

  /// Get environment name as string
  static String get environmentName {
    switch (_environment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
}
