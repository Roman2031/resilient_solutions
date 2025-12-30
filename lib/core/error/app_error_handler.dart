import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../logging/app_logger.dart';

/// Global error handler for the application
/// 
/// Captures and logs all unhandled errors from Flutter framework and Dart
/// Integrates with Firebase Crashlytics for production error tracking
class AppErrorHandler {
  /// Initialize global error handling
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.fatal(
        'Flutter Error: ${details.exception}',
        details.exception,
        details.stack,
      );

      // In production, send to Firebase Crashlytics
      if (!kDebugMode) {
        // FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      } else {
        // In debug mode, show the error
        FlutterError.presentError(details);
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.fatal('Platform Error: $error', error, stack);
      
      // In production, send to Firebase Crashlytics
      if (!kDebugMode) {
        // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      
      return true;
    };

    AppLogger.info('Global error handler initialized');
  }

  /// Handle error with user-friendly message
  static void handleError(
    Object error, 
    StackTrace stackTrace, {
    String? context,
  }) {
    final message = context != null 
        ? '$context: ${error.toString()}'
        : error.toString();
    
    AppLogger.error(message, error, stackTrace);
    
    // Send to crashlytics in production
    if (!kDebugMode) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: context);
    }
  }

  /// Show error to user
  static void showErrorToUser(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(Object error) {
    if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please check your connection.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
