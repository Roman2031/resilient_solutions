import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/keycloak_login_screen.dart';
import '../../features/dashboard/views/dashboard.dart';
import '../auth/auth_repository.dart';

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
  static const myCourses = '/my-courses';
  static const lessonView = '/lesson/:id';
  static const quiz = '/quiz/:id';
  static const donate = '/donate';
  static const notes = '/notes';
  static const callCircleManager = '/call-circle-manager';
  static const memberManager = '/member-manager';
  static const createCallCircle = '/create-call-circle';
  static const adminPortal = '/admin';
}

class AppRouter {
  AppRouter._();

  static final routeObserver = RouteObserver<ModalRoute<void>>();

  /// Create router with authentication awareness
  /// This must be called with a WidgetRef to access Riverpod providers
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: Routes.keycloakLogin,
      debugLogDiagnostics: kDebugMode,
      observers: [routeObserver],

      // Redirect logic based on authentication
      redirect: (context, state) {
        final authState = ref.read(authRepositoryProvider);

        final isAuthenticated = authState.when(
          data: (authState) => authState is AuthenticatedState,
          loading: () => false,
          error: (_, __) => false,
        );

        final isAuthRoute =
            state.matchedLocation == Routes.login || state.matchedLocation == Routes.keycloakLogin;

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

      // Refresh listenable for auth state changes
      // Use a ValueNotifier updated via ref.listen to avoid relying on a .stream on the repository
      refreshListenable: (() {
        final notifier = ValueNotifier<int>(0);
        ref.listen<AsyncValue<AuthState>>(authRepositoryProvider, (_, __) => notifier.value++);
        return notifier;
      })(),

      routes: [
        // Auth Routes
        GoRoute(
          path: Routes.keycloakLogin,
          builder: (context, state) => const KeycloakLoginScreen(),
        ),

        // Protected Routes (require authentication)
        GoRoute(path: Routes.dashboard, builder: (context, state) => const DashBoardScreen()),

        // Add more routes here as features are migrated
        // GoRoute(
        //   path: Routes.myProfile,
        //   builder: (context, state) => const MyProfileScreen(),
        // ),
        // GoRoute(
        //   path: Routes.myCalls,
        //   builder: (context, state) => const MyCallsScreen(),
        // ),
      ],
    );
  }

  /// Legacy router for backward compatibility
  /// TODO: Remove this once app.dart is updated
  static final router = GoRouter(
    initialLocation: Routes.keycloakLogin,
    debugLogDiagnostics: kDebugMode,
    observers: [routeObserver],
    routes: [
      GoRoute(path: Routes.keycloakLogin, builder: (context, state) => const KeycloakLoginScreen()),
      GoRoute(path: Routes.dashboard, builder: (context, state) => const DashBoardScreen()),
    ],
  );
}

/// Helper class to refresh GoRouter when auth state changes
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<AsyncValue<AuthState>> stream) {
    notifyListeners();
    _subscription = stream.listen((asyncValue) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AsyncValue<AuthState>> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
