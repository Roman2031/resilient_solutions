import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kindomcall/core/constants/constants.dart' show AppConstants;
import 'package:kindomcall/core/network/onnectivity_provider.dart';
import 'package:kindomcall/core/theme/theme.dart';
import 'package:kindomcall/core/theme/theme_extensions.dart';

import 'core/navigation/app_route.dart';
import 'core/theme/theme_controller_provider.dart';
import 'core/widgets/offline.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.setStatusBarTheme();
    final themeMode = ref.watch(themeModeProvider);
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
          routerConfig: AppRouter.router,
          builder: (context, child) {
            final connectivityAsyncValue = ref.watch(connectivityProvider);
            return connectivityAsyncValue.when(
              data: (connectivityResult) {
                if (connectivityResult == ConnectivityResult.none) {
                  return const Scaffold(body: OfflineScreen());
                }
                return child!;
              },
              loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
              error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
            );
          },
        );
      },
    );
  }
}
