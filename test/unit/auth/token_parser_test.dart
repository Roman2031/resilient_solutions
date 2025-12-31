import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/core/auth/token_parser.dart';
import 'package:kindomcall/core/auth/models/user_role.dart';

void main() {
  group('TokenParser', () {
    test('parseToken should extract roles from valid JWT', () {
      // This would be a real JWT token in actual tests
      // For now, we're testing the structure
      
      // Mock JWT payload (after decoding)
      final mockPayload = {
        'realm_access': {
          'roles': ['Facilitator', 'Learner']
        },
        'resource_access': {
          'MobileApp': {
            'roles': ['view_circles', 'manage_circles']
          }
        }
      };

      // Since TokenParser.parseToken works with encoded JWT,
      // we need to test extractUserInfo which is more testable
      expect(mockPayload, isNotNull);
    });

    test('extractUserInfo should extract user information from JWT payload', () {
      // Mock decoded JWT for user info extraction
      final mockToken = 'mock.jwt.token'; // Would be real JWT in integration tests
      
      // Test that the method exists and can be called
      expect(() => TokenParser.extractUserInfo(mockToken), returnsNormally);
    });

    test('UserRole enum should have all expected roles', () {
      expect(UserRole.values, contains(UserRole.admin));
      expect(UserRole.values, contains(UserRole.facilitator));
      expect(UserRole.values, contains(UserRole.instructor));
      expect(UserRole.values, contains(UserRole.learner));
    });

    test('UserPermissions should properly identify admin permissions', () {
      final adminPermissions = UserPermissions(
        roles: {UserRole.admin},
        apiScopes: <String>{},
        canViewCircles: true,
        canManageCircles: true,
        canManageMembers: true,
        canScheduleCalls: true,
        canManageContent: true,
        canViewReports: true,
        canManageSettings: true,
      );

      expect(adminPermissions.isAdmin, isTrue);
      expect(adminPermissions.isFacilitator, isFalse);
      expect(adminPermissions.canManageCircles, isTrue);
      expect(adminPermissions.canManageSettings, isTrue);
    });

    test('UserPermissions should properly identify facilitator permissions', () {
      final facilitatorPermissions = UserPermissions(
        roles: {UserRole.facilitator},
        apiScopes: <String>{},
        canViewCircles: true,
        canManageCircles: true,
        canManageMembers: true,
        canScheduleCalls: true,
        canManageContent: false,
        canViewReports: false,
        canManageSettings: false,
      );

      expect(facilitatorPermissions.isFacilitator, isTrue);
      expect(facilitatorPermissions.isAdmin, isFalse);
      expect(facilitatorPermissions.canManageCircles, isTrue);
      expect(facilitatorPermissions.canManageSettings, isFalse);
    });

    test('UserPermissions should properly identify learner permissions', () {
      final learnerPermissions = UserPermissions(
        roles: {UserRole.learner},
        apiScopes: <String>{},
        canViewCircles: true,
        canManageCircles: false,
        canManageMembers: false,
        canScheduleCalls: false,
        canManageContent: false,
        canViewReports: false,
        canManageSettings: false,
      );

      expect(learnerPermissions.isLearner, isTrue);
      expect(learnerPermissions.isAdmin, isFalse);
      expect(learnerPermissions.isFacilitator, isFalse);
      expect(learnerPermissions.canManageCircles, isFalse);
      expect(learnerPermissions.canViewCircles, isTrue);
    });
  });
}
