import 'package:dio/dio.dart';

/// Base Repository
/// Provides common repository functionality and error handling
abstract class BaseRepository {
  /// Handle API response and extract data
  T handleResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(response.data);
    } else {
      throw RepositoryException(
        'Request failed with status: ${response.statusCode}',
      );
    }
  }

  /// Handle list response
  List<T> handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson, {
    String? dataKey,
  }) {
    if (response.statusCode == 200) {
      final data = dataKey != null 
          ? response.data[dataKey] 
          : response.data;
      
      if (data is List) {
        return data
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      throw RepositoryException('Expected list response but got ${data.runtimeType}');
    } else {
      throw RepositoryException(
        'Request failed with status: ${response.statusCode}',
      );
    }
  }

  /// Handle paginated response
  PaginatedData<T> handlePaginatedResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson, {
    String dataKey = 'data',
    String? metaKey = 'meta',
  }) {
    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final items = (responseData[dataKey] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
      
      final meta = metaKey != null 
          ? responseData[metaKey] as Map<String, dynamic>?
          : null;
      
      return PaginatedData(
        items: items,
        currentPage: meta?['current_page'] as int? ?? 1,
        lastPage: meta?['last_page'] as int? ?? 1,
        perPage: meta?['per_page'] as int? ?? items.length,
        total: meta?['total'] as int? ?? items.length,
      );
    } else {
      throw RepositoryException(
        'Request failed with status: ${response.statusCode}',
      );
    }
  }

  /// Wrap repository calls with try-catch
  Future<T> execute<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw RepositoryException(
        'Network error: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw RepositoryException(
        'Unexpected error: $e',
        originalError: e,
      );
    }
  }
}

/// Repository exception
class RepositoryException implements Exception {
  final String message;
  final dynamic originalError;

  RepositoryException(this.message, {this.originalError});

  @override
  String toString() => message;
}

/// Paginated data model
class PaginatedData<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedData({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMorePages => currentPage < lastPage;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
}

/// API Result wrapper for better error handling
sealed class ApiResult<T> {
  const ApiResult();
  
  factory ApiResult.success(T data) = SuccessResult<T>;
  factory ApiResult.error(String message, {dynamic error}) = ErrorResult<T>;
  factory ApiResult.loading() = LoadingResult<T>;
}

class SuccessResult<T> extends ApiResult<T> {
  final T data;
  const SuccessResult(this.data);
}

class ErrorResult<T> extends ApiResult<T> {
  final String message;
  final dynamic error;
  const ErrorResult(this.message, {this.error});
}

class LoadingResult<T> extends ApiResult<T> {
  const LoadingResult();
}
