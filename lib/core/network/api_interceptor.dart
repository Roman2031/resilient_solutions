import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../auth/keycloak_auth_service.dart';
import '../utils/global_function.dart';

/// Authentication Interceptor
/// Automatically adds JWT Bearer token to all API requests
/// Handles token refresh when needed
class AuthInterceptor extends Interceptor {
  final KeycloakAuthService _authService;

  AuthInterceptor(this._authService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get valid access token (will auto-refresh if needed)
      final accessToken = await _authService.getValidAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to get access token: $e',
        ),
      );
    }
  }
}

/// Error Handling Interceptor
/// Centralizes error handling and user notifications
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);
    
    // Show error to user
    GlobalFunction.showCustomSnackbar(
      message: errorMessage,
      isSuccess: false,
    );

    // Log error in debug mode
    debugPrint('API Error: ${err.requestOptions.path}');
    debugPrint('Status Code: ${err.response?.statusCode}');
    debugPrint('Error: $errorMessage');

    handler.next(err);
  }

  String _getErrorMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);
      
      case DioExceptionType.cancel:
        return 'Request cancelled';
      
      case DioExceptionType.badCertificate:
        return 'Security error. Please contact support.';
      
      case DioExceptionType.unknown:
      default:
        return exception.message ?? 'An unexpected error occurred';
    }
  }

  String _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;

    // Extract error message from response if available
    String? message;
    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] as String? ??
          responseData['error'] as String?;
    }

    switch (statusCode) {
      case 400:
        return message ?? 'Bad request. Please check your input.';
      case 401:
        return message ?? 'Unauthorized. Please login again.';
      case 403:
        return message ?? 'Access forbidden. You don\'t have permission.';
      case 404:
        return message ?? 'Resource not found.';
      case 409:
        return message ?? 'Conflict. Resource already exists.';
      case 422:
        return message ?? 'Validation error. Please check your input.';
      case 429:
        return message ?? 'Too many requests. Please try again later.';
      case 500:
        return message ?? 'Server error. Please try again later.';
      case 502:
        return message ?? 'Bad gateway. Server is unavailable.';
      case 503:
        return message ?? 'Service unavailable. Please try again later.';
      default:
        return message ?? 'An error occurred. Please try again.';
    }
  }
}

/// Retry Interceptor
/// Automatically retries failed requests (except auth errors)
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Don't retry for these cases
    if (err.type == DioExceptionType.cancel ||
        err.response?.statusCode == 401 ||
        err.response?.statusCode == 403 ||
        err.response?.statusCode == 422) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;
    final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;

    if (retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;
      
      // Wait before retrying
      await Future.delayed(retryDelay * (retryCount + 1));

      try {
        final response = await Dio().fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    handler.next(err);
  }
}

/// Cache Interceptor
/// Implements simple caching for GET requests
class CacheInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};
  final Duration cacheDuration;

  CacheInterceptor({
    this.cacheDuration = const Duration(minutes: 5),
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final cacheKey = _getCacheKey(options);
    final cachedEntry = _cache[cacheKey];

    if (cachedEntry != null && !cachedEntry.isExpired) {
      return handler.resolve(cachedEntry.response);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only cache successful GET requests
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      _cache[cacheKey] = CacheEntry(
        response: response,
        expiryTime: DateTime.now().add(cacheDuration),
      );
    }

    handler.next(response);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.method}:${options.uri}';
  }

  void clearCache() {
    _cache.clear();
  }
}

class CacheEntry {
  final Response response;
  final DateTime expiryTime;

  CacheEntry({required this.response, required this.expiryTime});

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
