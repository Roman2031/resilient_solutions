import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/keycloak_auth_service.dart';
import 'api_interceptor.dart';

part 'api_service.g.dart';

/// API Service Configuration
class ApiConfig {
  // WordPress + LearnDash + BuddyBoss
  static const String wordpressBaseUrl = String.fromEnvironment(
    'WORDPRESS_API_URL',
    defaultValue: 'https://learning.kingdominc.com/wp-json',
  );

  // Call Service (Laravel)
  static const String callServiceBaseUrl = String.fromEnvironment(
    'CALL_SERVICE_API_URL',
    defaultValue: 'https://callcircle.resilentsolutions.com/api',
  );

  // Admin Portal (Laravel)
  static const String adminPortalBaseUrl = String.fromEnvironment(
    'ADMIN_PORTAL_API_URL',
    defaultValue: 'https://callcircle.resilentsolutions.com/api/v1/admin',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// Main API Service
/// Handles all API requests to Laravel backend and WordPress LMS
/// Automatically injects JWT tokens from Keycloak authentication
@riverpod
ApiService apiService(Ref ref) {
  final authService = KeycloakAuthService();
  return ApiService(authService);
}

class ApiService {
  final KeycloakAuthService _authService;
  late final Dio _wordpressClient;
  late final Dio _callServiceClient;
  late final Dio _adminPortalClient;

  ApiService(this._authService) {
    _wordpressClient = _createDioClient(ApiConfig.wordpressBaseUrl);
    _callServiceClient = _createDioClient(ApiConfig.callServiceBaseUrl);
    _adminPortalClient = _createDioClient(ApiConfig.adminPortalBaseUrl);
  }

  Dio _createDioClient(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor(_authService));

    // Add logging in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
    }

    // Add error handler interceptor
    dio.interceptors.add(ErrorInterceptor());

    return dio;
  }

  // Direct client access
  Dio get wordpress => _wordpressClient;
  Dio get callService => _callServiceClient;
  Dio get adminPortal => _adminPortalClient;

  /// Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ApiBackend backend = ApiBackend.callService,
  }) async {
    final client = _getClient(backend);
    return await client.get<T>(path, queryParameters: queryParameters, options: options);
  }

  /// Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ApiBackend backend = ApiBackend.callService,
  }) async {
    final client = _getClient(backend);
    return await client.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ApiBackend backend = ApiBackend.callService,
  }) async {
    final client = _getClient(backend);
    return await client.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ApiBackend backend = ApiBackend.callService,
  }) async {
    final client = _getClient(backend);
    return await client.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Generic PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ApiBackend backend = ApiBackend.callService,
  }) async {
    final client = _getClient(backend);
    return await client.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Dio _getClient(ApiBackend backend) {
    switch (backend) {
      case ApiBackend.wordpress:
        return _wordpressClient;
      case ApiBackend.callService:
        return _callServiceClient;
      case ApiBackend.adminPortal:
        return _adminPortalClient;
    }
  }
}

/// API Backend enum
enum ApiBackend { wordpress, callService, adminPortal }
