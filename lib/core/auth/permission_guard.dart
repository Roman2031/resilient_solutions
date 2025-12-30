import 'models/user_role.dart';

/// Permission guard for UI capability flags and feature access
/// 
/// Important: UI capability flags are computed client-side from claims
/// but never trusted—server is source of truth for security enforcement.
/// 
/// This class helps with:
/// - UI visibility (show/hide features based on roles)
/// - Client-side UX optimization
/// - Route guards
/// 
/// All sensitive operations must still be validated server-side.
class PermissionGuard {
  final UserPermissions permissions;

  const PermissionGuard(this.permissions);

  /// Check if user can access a feature
  bool canAccess(String feature) {
    switch (feature) {
      // Learner features (all users)
      case 'courses':
      case 'my_circles':
      case 'join_circle':
        return true;

      // Facilitator features
      case 'manage_circle':
      case 'circle_roster':
      case 'mark_attendance':
      case 'send_nudges':
      case 'broadcast_message':
        return permissions.isFacilitator || permissions.isAdmin;

      // Instructor features
      case 'create_course':
      case 'manage_courses':
      case 'course_analytics':
      case 'agenda_templates':
        return permissions.isInstructor || permissions.isAdmin;

      // Admin features
      case 'admin_panel':
      case 'user_management':
      case 'platform_config':
      case 'moderation':
      case 'data_export':
        return permissions.isAdmin;

      default:
        return false;
    }
  }

  /// Check if user can perform an action on a resource
  bool canPerform(String action, {String? resource}) {
    switch (action) {
      // Read operations (generally available)
      case 'read':
        return true;

      // Write operations require specific roles
      case 'create':
      case 'update':
      case 'delete':
        if (resource == 'circle') {
          return permissions.canManageCircles;
        } else if (resource == 'course') {
          return permissions.canManageCourses;
        } else if (resource == 'user') {
          return permissions.hasAdminPrivileges;
        }
        return false;

      // Attendance operations
      case 'mark_attendance':
        return permissions.canWriteAttendance;

      // Messaging operations
      case 'broadcast':
        return permissions.canBroadcastMessages;

      // Moderation operations
      case 'moderate':
        return permissions.canModerate;

      // Export operations
      case 'export':
        return permissions.canExport;

      default:
        return false;
    }
  }

  /// Get available features for current user
  List<String> getAvailableFeatures() {
    final List<String> features = [
      'courses',
      'my_circles',
      'join_circle',
      'profile',
    ];

    if (permissions.isFacilitator || permissions.isAdmin) {
      features.addAll([
        'manage_circle',
        'circle_roster',
        'mark_attendance',
        'send_nudges',
        'broadcast_message',
      ]);
    }

    if (permissions.isInstructor || permissions.isAdmin) {
      features.addAll([
        'create_course',
        'manage_courses',
        'course_analytics',
        'agenda_templates',
      ]);
    }

    if (permissions.isAdmin) {
      features.addAll([
        'admin_panel',
        'user_management',
        'platform_config',
        'moderation',
        'data_export',
      ]);
    }

    return features;
  }

  /// Check if user should see admin UI elements
  bool get shouldShowAdminUI => permissions.isAdmin;

  /// Check if user should see facilitator UI elements
  bool get shouldShowFacilitatorUI =>
      permissions.isFacilitator || permissions.isAdmin;

  /// Check if user should see instructor UI elements
  bool get shouldShowInstructorUI =>
      permissions.isInstructor || permissions.isAdmin;

  /// Get navigation items based on role
  List<NavigationItem> getNavigationItems() {
    final items = <NavigationItem>[
      const NavigationItem(
        icon: 'home',
        label: 'Home',
        route: '/home',
      ),
      const NavigationItem(
        icon: 'school',
        label: 'Courses',
        route: '/courses',
      ),
      const NavigationItem(
        icon: 'group',
        label: 'My Circles',
        route: '/circles',
      ),
    ];

    if (shouldShowFacilitatorUI) {
      items.add(const NavigationItem(
        icon: 'manage_accounts',
        label: 'Manage Circles',
        route: '/circles/manage',
      ));
    }

    if (shouldShowInstructorUI) {
      items.add(const NavigationItem(
        icon: 'create',
        label: 'Create Course',
        route: '/courses/create',
      ));
      items.add(const NavigationItem(
        icon: 'analytics',
        label: 'Analytics',
        route: '/analytics',
      ));
    }

    if (shouldShowAdminUI) {
      items.add(const NavigationItem(
        icon: 'admin_panel_settings',
        label: 'Admin',
        route: '/admin',
      ));
    }

    items.add(const NavigationItem(
      icon: 'person',
      label: 'Profile',
      route: '/profile',
    ));

    return items;
  }
}

/// Navigation item model
class NavigationItem {
  final String icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
