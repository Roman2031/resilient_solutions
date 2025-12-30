import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service for the application
/// 
/// Provides structured logging with different levels (debug, info, warning, error)
/// Integrates with Firebase Analytics for production monitoring
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.info,
  );

  /// Log debug message (only in debug mode)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log informational message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    // In production, send to Firebase Crashlytics
    if (!kDebugMode && error != null) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    }
  }

  /// Log fatal/critical error
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    // Always send fatal errors to crash reporting
    if (error != null) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message, fatal: true);
    }
  }

  /// Log API request
  static void apiRequest(String method, String url, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      _logger.d('API Request: $method $url', error: params);
    }
  }

  /// Log API response
  static void apiResponse(String method, String url, int statusCode, {dynamic data}) {
    if (kDebugMode) {
      _logger.d('API Response: $method $url - $statusCode', error: data);
    }
  }

  /// Log navigation event
  static void navigation(String from, String to) {
    if (kDebugMode) {
      _logger.d('Navigation: $from -> $to');
    }
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? params}) {
    _logger.i('User Action: $action', error: params);
  }
}
