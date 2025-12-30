import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/core/config/environment.dart';

/// Unit tests for EnvironmentConfig
/// 
/// Tests environment configuration and API URL management
void main() {
  group('EnvironmentConfig', () {
    setUp(() {
      // Reset to development before each test
      EnvironmentConfig.setEnvironment(Environment.development);
    });

    test('default environment should be development', () {
      expect(EnvironmentConfig.environment, Environment.development);
    });

    test('should set environment to staging', () {
      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.environment, Environment.staging);
    });

    test('should set environment to production', () {
      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.environment, Environment.production);
    });

    test('apiBaseUrl should return correct URL for development', () {
      EnvironmentConfig.setEnvironment(Environment.development);
      expect(
        EnvironmentConfig.apiBaseUrl,
        contains('callcircle.resilentsolutions.com'),
      );
    });

    test('apiBaseUrl should return correct URL for production', () {
      EnvironmentConfig.setEnvironment(Environment.production);
      expect(
        EnvironmentConfig.apiBaseUrl,
        contains('callcircle.resilentsolutions.com'),
      );
    });

    test('keycloakUrl should return correct URL for development', () {
      EnvironmentConfig.setEnvironment(Environment.development);
      expect(
        EnvironmentConfig.keycloakUrl,
        contains('auth.kingdom.com'),
      );
    });

    test('keycloakUrl should return correct URL for production', () {
      EnvironmentConfig.setEnvironment(Environment.production);
      expect(
        EnvironmentConfig.keycloakUrl,
        contains('auth.kingdom.com'),
      );
    });

    test('wordpressApiUrl should return correct URL', () {
      expect(
        EnvironmentConfig.wordpressApiUrl,
        contains('learning.kingdominc.com'),
      );
    });

    test('adminPortalApiUrl should return correct URL', () {
      expect(
        EnvironmentConfig.adminPortalApiUrl,
        contains('callcircle.resilentsolutions.com'),
      );
    });

    test('enableLogging should be true in development', () {
      EnvironmentConfig.setEnvironment(Environment.development);
      expect(EnvironmentConfig.enableLogging, true);
    });

    test('enableLogging should be false in production', () {
      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.enableLogging, false);
    });

    test('enableDebugFeatures should be true only in development', () {
      EnvironmentConfig.setEnvironment(Environment.development);
      expect(EnvironmentConfig.enableDebugFeatures, true);

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.enableDebugFeatures, false);

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.enableDebugFeatures, false);
    });

    test('environmentName should return correct name', () {
      EnvironmentConfig.setEnvironment(Environment.development);
      expect(EnvironmentConfig.environmentName, 'Development');

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.environmentName, 'Staging');

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.environmentName, 'Production');
    });
  });
}
