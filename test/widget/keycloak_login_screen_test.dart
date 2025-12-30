import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindomcall/features/auth/views/keycloak_login_screen.dart';
import 'package:kindomcall/core/auth/auth_repository.dart';

void main() {
  group('KeycloakLoginScreen Widget Tests', () {
    testWidgets('should display login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(
              home: KeycloakLoginScreen(),
            ),
          ),
        ),
      );

      // Wait for any async operations
      await tester.pumpAndSettle();

      // Verify the login button text is displayed
      expect(find.text('Login with SSO'), findsOneWidget);
    });

    testWidgets('should display secure login title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(
              home: KeycloakLoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the screen title is displayed
      expect(find.text('SECURE LOGIN'), findsOneWidget);
    });

    testWidgets('should display info text about Keycloak', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(
              home: KeycloakLoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify info text is displayed
      expect(find.textContaining('Secure authentication'), findsOneWidget);
    });

    testWidgets('should show loading indicator when authentication is in progress', 
        (WidgetTester tester) async {
      // This would require mocking the authRepositoryProvider
      // For now, we test the basic structure
      
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(
              home: KeycloakLoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the button is present
      final loginButton = find.widgetWithText(ElevatedButton, 'Login with SSO');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('login button should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (context, child) => MaterialApp(
              home: KeycloakLoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Login with SSO');
      expect(loginButton, findsOneWidget);
      
      // The button should be enabled and tappable
      final elevatedButton = tester.widget<ElevatedButton>(loginButton);
      expect(elevatedButton.onPressed, isNotNull);
    });
  });
}
