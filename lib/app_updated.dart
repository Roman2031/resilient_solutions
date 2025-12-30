import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kindomcall/core/constants/constants.dart' show AppConstants;
import 'package:kindomcall/core/network/onnectivity_provider.dart';
import 'package:kindomcall/core/theme/theme.dart';
import 'package:kindomcall/core/theme/theme_extensions.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/theme_controller_provider.dart';
import 'core/widgets/offline.dart';
import 'core/auth/deep_link_service.dart';

/// Main App Widget with Keycloak Authentication Integration
/// 
/// Key Features:
/// - Keycloak OIDC authentication with deep linking
/// - Auto JWT token injection in API calls
/// - Connectivity monitoring
/// - Theme management
/// - Riverpod state management
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    _initializeDeepLinking();
  }

  /// Initialize deep link handling for OAuth redirect
  Future<void> _initializeDeepLinking() async {
    _deepLinkService.onLinkReceived = (Uri uri) {
      debugPrint('Deep link received: $uri');
      
      // Handle OAuth redirect
      if (uri.host == 'oauth2redirect') {
        // flutter_appauth handles this automatically
        debugPrint('OAuth redirect handled by flutter_appauth');
      }
      
      // Handle logout redirect
      if (uri.host == 'logout') {
        debugPrint('Logout redirect received');
      }
      
      // Handle other deep links (e.g., course/circle invitations)
      // You can add custom navigation logic here
    };

    await _deepLinkService.initialize();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.setStatusBarTheme();
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    
    debugPrint('Current ThemeMode: $themeMode');
    
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: router,
          builder: (context, child) {
            final connectivityAsyncValue = ref.watch(connectivityProvider);
            
            return connectivityAsyncValue.when(
              data: (connectivityResult) {
                if (connectivityResult == ConnectivityResult.none) {
                  return const Scaffold(body: OfflineScreen());
                }
                return child!;
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $error'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
