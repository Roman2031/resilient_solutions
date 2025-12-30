import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/views/keycloak_login_screen.dart';
import '../../features/dashboard/views/dashboard.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/admin_portal/views/admin_dashboard_screen.dart';
import '../../features/admin_portal/views/user_management_screen.dart';
import '../../features/admin_portal/views/admin_circle_management_screen.dart';
import '../../features/admin_portal/views/role_management_screen.dart';
import '../../features/admin_portal/views/analytics_screen.dart';
import '../../features/admin_portal/views/content_moderation_screen.dart';
import '../../features/admin_portal/views/system_settings_screen.dart';
import '../../features/admin_portal/views/audit_log_screen.dart';
import '../../features/admin_portal/views/support_screen.dart';
import '../auth/auth_repository.dart';

/// Routes Configuration
class Routes {
  Routes._();
  
  // Auth routes
  static const login = '/login';
  static const keycloakLogin = '/keycloak-login';
  
  // Main routes
  static const dashboard = '/dashboard';
  static const home = '/home';
  
  // Feature routes
  static const myProfile = '/profile';
  static const myCalls = '/my-calls';
  static const callCircleDetail = '/call-circle/:id';
  static const callScheduler = '/call-scheduler';
  static const chat = '/chat';
  static const courses = '/courses';
  static const courseDetail = '/courses/:id';
  static const donate = '/donate';
  static const notes = '/notes';
  
  // Admin routes
  static const admin = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminCircles = '/admin/circles';
  static const adminRoles = '/admin/roles';
  static const adminAnalytics = '/admin/analytics';
  static const adminModeration = '/admin/moderation';
  static const adminSettings = '/admin/settings';
  static const adminAuditLogs = '/admin/audit-logs';
  static const adminSupport = '/admin/support';
}

/// Router Provider with Authentication
/// Automatically redirects based on authentication state
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: Routes.keycloakLogin,
    debugLogDiagnostics: kDebugMode,
    
    // Redirect logic based on authentication
    redirect: (context, state) {
      final isAuthenticated = authState.when(
        data: (authState) => authState is AuthenticatedState,
        loading: () => false,
        error: (_, __) => false,
      );

      final isAuthRoute = state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.keycloakLogin;

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return Routes.keycloakLogin;
      }

      // If authenticated and on auth route, go to dashboard
      if (isAuthenticated && isAuthRoute) {
        return Routes.dashboard;
      }

      return null; // No redirect needed
    },

    routes: [
      // Auth Routes
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.keycloakLogin,
        builder: (context, state) => const KeycloakLoginScreen(),
      ),

      // Protected Routes (require authentication)
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashBoardScreen(),
      ),
      
      // Admin Routes (require admin privileges)
      GoRoute(
        path: Routes.admin,
        redirect: (context, state) => Routes.adminDashboard,
      ),
      GoRoute(
        path: Routes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: Routes.adminUsers,
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminCircles,
        builder: (context, state) => const AdminCircleManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminRoles,
        builder: (context, state) => const RoleManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminAnalytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: Routes.adminModeration,
        builder: (context, state) => const ContentModerationScreen(),
      ),
      GoRoute(
        path: Routes.adminSettings,
        builder: (context, state) => const SystemSettingsScreen(),
      ),
      GoRoute(
        path: Routes.adminAuditLogs,
        builder: (context, state) => const AuditLogScreen(),
      ),
      GoRoute(
        path: Routes.adminSupport,
        builder: (context, state) => const SupportScreen(),
      ),
      
      // Add more routes here as you migrate features
      // GoRoute(
      //   path: Routes.myProfile,
      //   builder: (context, state) => const MyProfileScreen(),
      // ),
      // GoRoute(
      //   path: Routes.myCalls,
      //   builder: (context, state) => const MyCallsScreen(),
      // ),
      // GoRoute(
      //   path: Routes.callCircleDetail,
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return CallCircleDetailScreen(circleId: int.parse(id));
      //   },
      // ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(Routes.dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Router Configuration for the App
/// Use this in MyApp instead of AppRouter.router
class AppRouterConfig {
  AppRouterConfig._();

  static RouteObserver<ModalRoute<void>> get routeObserver =>
      RouteObserver<ModalRoute<void>>();
}
