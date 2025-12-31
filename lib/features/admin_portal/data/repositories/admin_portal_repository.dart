import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/base_repository.dart';
import '../../../../core/network/api_service.dart';
import '../models/admin_models.dart';
import '../models/analytics_models.dart';

part 'admin_portal_repository.g.dart';

/// Admin Portal Repository
/// Implements all Admin Portal Laravel API endpoints
/// Base URL: https://callcircle.resilentsolutions.com/api/v1/admin
@riverpod
AdminPortalRepository adminPortalRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AdminPortalRepository(apiService);
}

class AdminPortalRepository extends BaseRepository {
  final ApiService _apiService;

  AdminPortalRepository(this._apiService);

  // ==================== Users ====================

  /// GET /admin/users
  Future<List<AdminUser>> getUsers({
    int? page,
    int? perPage,
    String? search,
    String? role,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/users',
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
          if (search != null) 'search': search,
          if (role != null) 'role': role,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => AdminUser.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// PATCH /admin/users/{user}/roles
  Future<AdminUser> updateUserRoles({
    required int userId,
    required List<String> roles,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/admin/users/$userId/roles',
        data: {
          'roles': roles,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  // ==================== Circles ====================

  /// GET /admin/circles
  Future<List<AdminCircle>> getCircles({
    int? page,
    int? perPage,
    String? search,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/circles',
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
          if (search != null) 'search': search,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => AdminCircle.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /admin/circles
  Future<AdminCircle> createCircle({
    required String name,
    required String description,
    required int facilitatorId,
    int? courseId,
    int? maxMembers,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/admin/circles',
        data: {
          'name': name,
          'description': description,
          'facilitator_id': facilitatorId,
          if (courseId != null) 'course_id': courseId,
          if (maxMembers != null) 'max_members': maxMembers,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminCircle.fromJson(data),
      );
    });
  }

  /// PATCH /admin/circles/{circle}
  Future<AdminCircle> updateCircle({
    required int circleId,
    String? name,
    String? description,
    int? facilitatorId,
    int? maxMembers,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/admin/circles/$circleId',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (facilitatorId != null) 'facilitator_id': facilitatorId,
          if (maxMembers != null) 'max_members': maxMembers,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminCircle.fromJson(data),
      );
    });
  }

  // ==================== Dashboard ====================

  /// GET /admin/dashboard/stats
  Future<AdminDashboardStats> getDashboardStats() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/dashboard/stats',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminDashboardStats.fromJson(data),
      );
    });
  }

  /// GET /admin/dashboard/activity
  Future<List<AdminActivity>> getRecentActivity({int limit = 20}) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/dashboard/activity',
        queryParameters: {'limit': limit},
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => AdminActivity.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// GET /admin/health
  Future<SystemHealth> getSystemHealth() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/health',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => SystemHealth.fromJson(data),
      );
    });
  }

  // ==================== User Management ====================

  /// GET /admin/users/{id}
  Future<AdminUserDetails> getUserDetails(int userId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/users/$userId',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUserDetails.fromJson(data),
      );
    });
  }

  /// POST /admin/users
  Future<AdminUser> createUser({
    required String name,
    required String email,
    String? password,
    List<String>? roles,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/admin/users',
        data: {
          'name': name,
          'email': email,
          if (password != null) 'password': password,
          if (roles != null) 'roles': roles,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  /// PATCH /admin/users/{id}
  Future<AdminUser> updateUser({
    required int userId,
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/admin/users/$userId',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  /// DELETE /admin/users/{id}
  Future<void> deleteUser(int userId) async {
    return execute(() async {
      await _apiService.delete(
        '/admin/users/$userId',
        backend: ApiBackend.adminPortal,
      );
    });
  }

  /// POST /admin/users/{id}/suspend
  Future<AdminUser> suspendUser({
    required int userId,
    required String reason,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/admin/users/$userId/suspend',
        data: {'reason': reason},
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  /// POST /admin/users/{id}/activate
  Future<AdminUser> activateUser(int userId) async {
    return execute(() async {
      final response = await _apiService.post(
        '/admin/users/$userId/activate',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  /// PATCH /admin/users/{id}/roles
  Future<AdminUser> assignUserRoles({
    required int userId,
    required List<String> roles,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/admin/users/$userId/roles',
        data: {'roles': roles},
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminUser.fromJson(data),
      );
    });
  }

  // ==================== Analytics ====================

  /// GET /admin/analytics/users
  Future<UserAnalytics> getUserAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/analytics/users',
        queryParameters: {
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => UserAnalytics.fromJson(data),
      );
    });
  }

  /// GET /admin/analytics/circles
  Future<CircleAnalytics> getCircleAnalytics() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/analytics/circles',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => CircleAnalytics.fromJson(data),
      );
    });
  }

  /// GET /admin/analytics/learning
  Future<LearningAnalytics> getLearningAnalytics() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/analytics/learning',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => LearningAnalytics.fromJson(data),
      );
    });
  }

  /// GET /admin/analytics/calls
  Future<CallAnalytics> getCallAnalytics() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/analytics/calls',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => CallAnalytics.fromJson(data),
      );
    });
  }

  /// GET /admin/analytics/engagement
  Future<EngagementAnalytics> getEngagementAnalytics() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/analytics/engagement',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => EngagementAnalytics.fromJson(data),
      );
    });
  }

  // ==================== Moderation ====================

  /// GET /admin/moderation/flagged
  Future<List<FlaggedContent>> getFlaggedContent({
    String? status,
    String? contentType,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/moderation/flagged',
        queryParameters: {
          if (status != null) 'status': status,
          if (contentType != null) 'content_type': contentType,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => FlaggedContent.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /admin/moderation/{id}/approve
  Future<void> approveContent(int contentId) async {
    return execute(() async {
      await _apiService.post(
        '/admin/moderation/$contentId/approve',
        backend: ApiBackend.adminPortal,
      );
    });
  }

  /// POST /admin/moderation/{id}/remove
  Future<void> removeContent({
    required int contentId,
    required String reason,
  }) async {
    return execute(() async {
      await _apiService.post(
        '/admin/moderation/$contentId/remove',
        data: {'reason': reason},
        backend: ApiBackend.adminPortal,
      );
    });
  }

  /// GET /admin/moderation/history
  Future<List<AuditLog>> getModerationHistory() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/moderation/history',
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => AuditLog.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  // ==================== Settings ====================

  /// GET /admin/settings
  Future<SystemSettings> getSettings() async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/settings',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => SystemSettings.fromJson(data),
      );
    });
  }

  /// PATCH /admin/settings
  Future<SystemSettings> updateSettings({
    String? platformName,
    String? defaultLanguage,
    String? timezone,
    bool? registrationEnabled,
    bool? emailVerificationRequired,
    int? maxCircleMembers,
    int? sessionTimeout,
    int? maxFileSize,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/admin/settings',
        data: {
          if (platformName != null) 'platform_name': platformName,
          if (defaultLanguage != null) 'default_language': defaultLanguage,
          if (timezone != null) 'timezone': timezone,
          if (registrationEnabled != null) 'registration_enabled': registrationEnabled,
          if (emailVerificationRequired != null) 'email_verification_required': emailVerificationRequired,
          if (maxCircleMembers != null) 'max_circle_members': maxCircleMembers,
          if (sessionTimeout != null) 'session_timeout': sessionTimeout,
          if (maxFileSize != null) 'max_file_size': maxFileSize,
        },
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => SystemSettings.fromJson(data),
      );
    });
  }

  // ==================== Audit Logs ====================

  /// GET /admin/audit-logs
  Future<List<AuditLog>> getAuditLogs({
    String? eventType,
    int? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/admin/audit-logs',
        queryParameters: {
          if (eventType != null) 'event_type': eventType,
          if (userId != null) 'user_id': userId,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
        backend: ApiBackend.adminPortal,
      );
      return handleListResponse(
        response,
        (json) => AuditLog.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// DELETE /admin/circles/{id}
  Future<void> deleteCircle(int circleId) async {
    return execute(() async {
      await _apiService.delete(
        '/admin/circles/$circleId',
        backend: ApiBackend.adminPortal,
      );
    });
  }

  /// POST /admin/circles/{id}/archive
  Future<AdminCircle> archiveCircle(int circleId) async {
    return execute(() async {
      final response = await _apiService.post(
        '/admin/circles/$circleId/archive',
        backend: ApiBackend.adminPortal,
      );
      return handleResponse(
        response,
        (data) => AdminCircle.fromJson(data),
      );
    });
  }
}
