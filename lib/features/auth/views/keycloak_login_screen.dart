import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import 'widgets/fotter_screen.dart';

/// New Login Screen with Keycloak OIDC Authentication
/// 
/// This screen replaces username/password login with SSO via Keycloak.
/// When user taps login, they are redirected to Keycloak login page in browser.
/// After successful authentication, they are redirected back to the app via deep link.
class KeycloakLoginScreen extends ConsumerWidget {
  const KeycloakLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authRepositoryProvider);

    // Listen for auth state changes and navigate on success
    ref.listen<AsyncValue<AuthState>>(
      authRepositoryProvider,
      (previous, next) {
        next.whenData((authState) {
          if (authState is AuthenticatedState) {
            // Navigate to dashboard on successful login
            // This will be handled by GoRouter redirect
          }
        });
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xff023C7B),
      body: SafeArea(
        child: Stack(
          children: [
            /// Background image
            Positioned.fill(
              child: Image.asset(
                "assets/pngs/loginpagebg.png",
                fit: BoxFit.cover,
              ),
            ),

            /// Main content centered
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(150.h),
                
                // App Logo
                Image.asset(
                  "assets/pngs/logo.png",
                  height: 90.h,
                  width: 249.w,
                ),
                Gap(29.h),

                // Login Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff0082DF),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SECURE LOGIN",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(12.h),
                          Text(
                            "Sign in with your Kingdom Call account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                          Gap(30.h),

                          // Keycloak SSO Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: authState.when(
                              data: (state) => ElevatedButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(authRepositoryProvider.notifier)
                                      .login();
                                },
                                icon: const Icon(
                                  Icons.login,
                                  color: Color(0xff0082DF),
                                ),
                                label: Text(
                                  'Login with SSO',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff0082DF),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                              loading: () => ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xff0082DF),
                                    ),
                                  ),
                                ),
                              ),
                              error: (error, _) => ElevatedButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(authRepositoryProvider.notifier)
                                      .login();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Color(0xff0082DF),
                                ),
                                label: Text(
                                  'Retry Login',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff0082DF),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Show error message if login fails
                          if (authState.hasError) ...[
                            Gap(16.h),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Login failed. Please try again.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                
                Gap(22.h),
                
                // Info text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Secure authentication powered by Keycloak SSO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                
                const Spacer(),
                const FotterScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
