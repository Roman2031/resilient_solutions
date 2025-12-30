import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/auth_repository.dart';
import '../auth/permission_guard.dart';

part 'rbac_providers.g.dart';

/// Provider for PermissionGuard
/// Use this to check permissions and capabilities throughout the app
@riverpod
PermissionGuard? permissionGuard(PermissionGuardRef ref) {
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null) return null;
  
  return PermissionGuard(permissions);
}

/// Provider to check if user can access a specific feature
@riverpod
bool canAccessFeature(CanAccessFeatureRef ref, String feature) {
  final guard = ref.watch(permissionGuardProvider);
  
  if (guard == null) return false;
  
  return guard.canAccess(feature);
}

/// Provider to check if user can perform an action
@riverpod
bool canPerformAction(
  CanPerformActionRef ref,
  String action, {
  String? resource,
}) {
  final guard = ref.watch(permissionGuardProvider);
  
  if (guard == null) return false;
  
  return guard.canPerform(action, resource: resource);
}

/// Provider for navigation items based on user role
@riverpod
List<NavigationItem> navigationItems(NavigationItemsRef ref) {
  final guard = ref.watch(permissionGuardProvider);
  
  if (guard == null) {
    // Return basic navigation for unauthenticated users
    return const [
      NavigationItem(
        icon: 'home',
        label: 'Home',
        route: '/home',
      ),
      NavigationItem(
        icon: 'login',
        label: 'Login',
        route: '/login',
      ),
    ];
  }
  
  return guard.getNavigationItems();
}

/// Provider to check if admin UI should be shown
@riverpod
bool shouldShowAdminUI(ShouldShowAdminUIRef ref) {
  final guard = ref.watch(permissionGuardProvider);
  return guard?.shouldShowAdminUI ?? false;
}

/// Provider to check if facilitator UI should be shown
@riverpod
bool shouldShowFacilitatorUI(ShouldShowFacilitatorUIRef ref) {
  final guard = ref.watch(permissionGuardProvider);
  return guard?.shouldShowFacilitatorUI ?? false;
}

/// Provider to check if instructor UI should be shown
@riverpod
bool shouldShowInstructorUI(ShouldShowInstructorUIRef ref) {
  final guard = ref.watch(permissionGuardProvider);
  return guard?.shouldShowInstructorUI ?? false;
}

/// Provider to get user's display name
@riverpod
String? userDisplayName(UserDisplayNameRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  
  return authRepo.when(
    data: (state) => state.when(
      authenticated: (_, __, ___, userInfo) => userInfo['name'] as String?,
      unauthenticated: () => null,
    ),
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider to get user's email
@riverpod
String? userEmail(UserEmailRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  
  return authRepo.when(
    data: (state) => state.when(
      authenticated: (_, __, ___, userInfo) => userInfo['email'] as String?,
      unauthenticated: () => null,
    ),
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider to get user's role display names
@riverpod
List<String> userRoleDisplayNames(UserRoleDisplayNamesRef ref) {
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null) return [];
  
  return permissions.roles.map((role) => role.displayName).toList();
}
