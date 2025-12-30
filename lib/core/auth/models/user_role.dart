import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role.freezed.dart';
part 'user_role.g.dart';

/// Canonical roles from Keycloak (authoritative in SSO)
/// Maps to different systems: App, Portal, WordPress
enum UserRole {
  @JsonValue('learner')
  learner,
  
  @JsonValue('facilitator')
  facilitator,
  
  @JsonValue('instructor')
  instructor,
  
  @JsonValue('admin')
  admin,
}

/// Extension for role information
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.learner:
        return 'Learner';
      case UserRole.facilitator:
        return 'Facilitator';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get description {
    switch (this) {
      case UserRole.learner:
        return 'Default participant; consumes courses; joins Call Circles';
      case UserRole.facilitator:
        return 'Leads a Circle; manages roster, attendance, nudges';
      case UserRole.instructor:
        return 'Creates/manages courses; reviews analytics';
      case UserRole.admin:
        return 'Platform governance, moderation, configuration';
    }
  }

  /// Maps to WordPress role
  String get wordPressRole {
    switch (this) {
      case UserRole.learner:
        return 'subscriber';
      case UserRole.facilitator:
        return 'group_leader';
      case UserRole.instructor:
        return 'instructor';
      case UserRole.admin:
        return 'administrator';
    }
  }

  /// API scopes for Laravel backend
  List<String> get apiScopes {
    switch (this) {
      case UserRole.learner:
        return ['read:self', 'join:circle'];
      case UserRole.facilitator:
        return [
          'read:self',
          'join:circle',
          'circle:manage',
          'attendance:write',
          'message:broadcast',
        ];
      case UserRole.instructor:
        return [
          'read:self',
          'course:manage',
          'agenda:template',
        ];
      case UserRole.admin:
        return [
          'admin:*',
          'moderate:*',
          'export:*',
        ];
    }
  }
}

/// Keycloak ID Token claims
/// Example token structure consumed by clients/services
@freezed
class KeycloakToken with _$KeycloakToken {
  const factory KeycloakToken({
    /// Subject identifier (user ID)
    required String sub,
    
    /// User email
    required String email,
    
    /// User full name
    required String name,
    
    /// Realm-level roles (canonical roles)
    @JsonKey(name: 'realm_access') required RealmAccess realmAccess,
    
    /// Resource/client-specific access
    @JsonKey(name: 'resource_access') Map<String, ResourceAccess>? resourceAccess,
    
    /// Community/campaign membership
    List<String>? groups,
    
    /// Locale preference
    @JsonKey(name: 'kc.locale') String? locale,
    
    /// Magento ID (identity source-of-truth)
    @JsonKey(name: 'magentoId') String? magentoId,
    
    /// Token issued at
    @JsonKey(name: 'iat') int? issuedAt,
    
    /// Token expiration
    @JsonKey(name: 'exp') int? expiresAt,
    
    /// Additional claims
    Map<String, dynamic>? additionalClaims,
  }) = _KeycloakToken;

  factory KeycloakToken.fromJson(Map<String, dynamic> json) =>
      _$KeycloakTokenFromJson(json);
}

/// Realm access object containing canonical roles
@freezed
class RealmAccess with _$RealmAccess {
  const factory RealmAccess({
    required List<String> roles,
  }) = _RealmAccess;

  factory RealmAccess.fromJson(Map<String, dynamic> json) =>
      _$RealmAccessFromJson(json);
}

/// Resource access for client-specific scopes
@freezed
class ResourceAccess with _$ResourceAccess {
  const factory ResourceAccess({
    required List<String> roles,
  }) = _ResourceAccess;

  factory ResourceAccess.fromJson(Map<String, dynamic> json) =>
      _$ResourceAccessFromJson(json);
}

/// User permissions derived from roles and token claims
@freezed
class UserPermissions with _$UserPermissions {
  const factory UserPermissions({
    /// User's canonical roles from Keycloak
    required List<UserRole> roles,
    
    /// Mobile app specific roles
    @Default([]) List<String> mobileRoles,
    
    /// Portal specific roles
    @Default([]) List<String> portalRoles,
    
    /// API scopes (computed from roles)
    required List<String> apiScopes,
    
    /// Community/campaign groups
    @Default([]) List<String> groups,
    
    /// Magento ID
    String? magentoId,
  }) = _UserPermissions;

  const UserPermissions._();

  factory UserPermissions.fromJson(Map<String, dynamic> json) =>
      _$UserPermissionsFromJson(json);

  /// Check if user has a specific role
  bool hasRole(UserRole role) => roles.contains(role);

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> checkRoles) =>
      checkRoles.any((role) => roles.contains(role));

  /// Check if user has all of the specified roles
  bool hasAllRoles(List<UserRole> checkRoles) =>
      checkRoles.every((role) => roles.contains(role));

  /// Check if user has a specific API scope
  bool hasScope(String scope) => apiScopes.contains(scope);

  /// Check if user is a learner
  bool get isLearner => hasRole(UserRole.learner);

  /// Check if user is a facilitator
  bool get isFacilitator => hasRole(UserRole.facilitator);

  /// Check if user is an instructor
  bool get isInstructor => hasRole(UserRole.instructor);

  /// Check if user is an admin
  bool get isAdmin => hasRole(UserRole.admin);

  /// Check if user can manage circles
  bool get canManageCircles => hasScope('circle:manage');

  /// Check if user can manage courses
  bool get canManageCourses => hasScope('course:manage');

  /// Check if user can write attendance
  bool get canWriteAttendance => hasScope('attendance:write');

  /// Check if user can broadcast messages
  bool get canBroadcastMessages => hasScope('message:broadcast');

  /// Check if user has admin privileges
  bool get hasAdminPrivileges => hasScope('admin:*');

  /// Check if user can moderate
  bool get canModerate => hasScope('moderate:*');

  /// Check if user can export data
  bool get canExport => hasScope('export:*');
}
