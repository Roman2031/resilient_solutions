import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

/// Admin User Model
@freezed
class AdminUser with _$AdminUser {
  const factory AdminUser({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? avatar,
    required List<String> roles,
    required String status, // active, inactive, suspended
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);
}

/// Admin Circle Model
@freezed
class AdminCircle with _$AdminCircle {
  const factory AdminCircle({
    required int id,
    required String name,
    required String description,
    @JsonKey(name: 'facilitator_id') required int facilitatorId,
    @JsonKey(name: 'facilitator_name') String? facilitatorName,
    @JsonKey(name: 'course_id') int? courseId,
    @JsonKey(name: 'max_members') int? maxMembers,
    @JsonKey(name: 'members_count') @Default(0) int membersCount,
    required String status,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AdminCircle;

  factory AdminCircle.fromJson(Map<String, dynamic> json) =>
      _$AdminCircleFromJson(json);
}

/// Admin Dashboard Stats Model
@freezed
class AdminDashboardStats with _$AdminDashboardStats {
  const factory AdminDashboardStats({
    @JsonKey(name: 'total_users') required int totalUsers,
    @JsonKey(name: 'active_users') required int activeUsers,
    @JsonKey(name: 'total_circles') required int totalCircles,
    @JsonKey(name: 'active_circles') required int activeCircles,
    @JsonKey(name: 'upcoming_calls') required int upcomingCalls,
    @JsonKey(name: 'total_courses') @Default(0) int totalCourses,
    @JsonKey(name: 'total_messages') @Default(0) int totalMessages,
    @JsonKey(name: 'user_growth') required UserGrowth userGrowth,
    @JsonKey(name: 'system_health') required SystemHealth systemHealth,
    @JsonKey(name: 'storage_stats') required StorageStats storageStats,
  }) = _AdminDashboardStats;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardStatsFromJson(json);
}

/// User Growth Stats
@freezed
class UserGrowth with _$UserGrowth {
  const factory UserGrowth({
    @JsonKey(name: 'new_users_today') required int newUsersToday,
    @JsonKey(name: 'new_users_this_week') required int newUsersThisWeek,
    @JsonKey(name: 'new_users_this_month') required int newUsersThisMonth,
    @JsonKey(name: 'growth_percentage') required double growthPercentage,
  }) = _UserGrowth;

  factory UserGrowth.fromJson(Map<String, dynamic> json) =>
      _$UserGrowthFromJson(json);
}

/// System Health Model
@freezed
class SystemHealth with _$SystemHealth {
  const factory SystemHealth({
    required String status, // healthy, warning, critical
    @JsonKey(name: 'cpu_usage') @Default(0.0) double cpuUsage,
    @JsonKey(name: 'memory_usage') @Default(0.0) double memoryUsage,
    @JsonKey(name: 'disk_usage') @Default(0.0) double diskUsage,
    @JsonKey(name: 'error_count') @Default(0) int errorCount,
    @JsonKey(name: 'last_checked') required DateTime lastChecked,
  }) = _SystemHealth;

  factory SystemHealth.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthFromJson(json);
}

/// Storage Stats Model
@freezed
class StorageStats with _$StorageStats {
  const factory StorageStats({
    @JsonKey(name: 'total_storage') required double totalStorage,
    @JsonKey(name: 'used_storage') required double usedStorage,
    @JsonKey(name: 'storage_unit') @Default('GB') String storageUnit,
  }) = _StorageStats;

  factory StorageStats.fromJson(Map<String, dynamic> json) =>
      _$StorageStatsFromJson(json);
}

/// Admin User Details Model
@freezed
class AdminUserDetails with _$AdminUserDetails {
  const factory AdminUserDetails({
    required int id,
    required String name,
    required String email,
    String? avatar,
    required List<String> roles,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'circles_count') @Default(0) int circlesCount,
    @JsonKey(name: 'courses_enrolled') @Default(0) int coursesEnrolled,
    @JsonKey(name: 'messages_count') @Default(0) int messagesCount,
    @JsonKey(name: 'login_history') @Default([]) List<LoginHistory> loginHistory,
    @JsonKey(name: 'recent_activity') @Default([]) List<ActivityLog> recentActivity,
  }) = _AdminUserDetails;

  factory AdminUserDetails.fromJson(Map<String, dynamic> json) =>
      _$AdminUserDetailsFromJson(json);
}

/// Login History Model
@freezed
class LoginHistory with _$LoginHistory {
  const factory LoginHistory({
    required int id,
    @JsonKey(name: 'logged_in_at') required DateTime loggedInAt,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'device_info') String? deviceInfo,
  }) = _LoginHistory;

  factory LoginHistory.fromJson(Map<String, dynamic> json) =>
      _$LoginHistoryFromJson(json);
}

/// Activity Log Model
@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required int id,
    required String action,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);
}

/// Paginated Users Model
@freezed
class PaginatedUsers with _$PaginatedUsers {
  const factory PaginatedUsers({
    required List<AdminUser> users,
    required int total,
    required int page,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _PaginatedUsers;

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersFromJson(json);
}

/// Admin Activity Model
@freezed
class AdminActivity with _$AdminActivity {
  const factory AdminActivity({
    required int id,
    @JsonKey(name: 'activity_type') required String activityType,
    required String description,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AdminActivity;

  factory AdminActivity.fromJson(Map<String, dynamic> json) =>
      _$AdminActivityFromJson(json);
}

/// Audit Log Model
@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required int id,
    required DateTime timestamp,
    @JsonKey(name: 'event_type') required String eventType,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') required String userName,
    required String action,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'device_info') String? deviceInfo,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
