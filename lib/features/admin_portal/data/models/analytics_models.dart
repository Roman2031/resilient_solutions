import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_models.freezed.dart';
part 'analytics_models.g.dart';

/// User Analytics Model
@freezed
abstract class UserAnalytics with _$UserAnalytics {
  const factory UserAnalytics({
    @JsonKey(name: 'user_growth') required List<DataPoint> userGrowth,
    @JsonKey(name: 'users_by_role') required Map<String, int> usersByRole,
    @JsonKey(name: 'users_by_status') required Map<String, int> usersByStatus,
    @JsonKey(name: 'retention_rate') required double retentionRate,
    @JsonKey(name: 'active_users') required int activeUsers,
    @JsonKey(name: 'total_users') required int totalUsers,
  }) = _UserAnalytics;
  factory UserAnalytics.fromJson(Map<String, dynamic> json) =>
      _$UserAnalyticsFromJson(json);
}

/// Data Point for Charts
@freezed
abstract class DataPoint with _$DataPoint {
  const factory DataPoint({
    required DateTime date,
    required double value,
  }) = _DataPoint;

  factory DataPoint.fromJson(Map<String, dynamic> json) =>
      _$DataPointFromJson(json);
}

/// Circle Analytics Model
@freezed
abstract class CircleAnalytics with _$CircleAnalytics {
  const factory CircleAnalytics({
    @JsonKey(name: 'total_circles') required int totalCircles,
    @JsonKey(name: 'active_circles') required int activeCircles,
    @JsonKey(name: 'average_members') required double averageMembers,
    @JsonKey(name: 'circles_by_category') required Map<String, int> circlesByCategory,
    @JsonKey(name: 'circle_creation_trend') required List<DataPoint> circleCreationTrend,
  }) = _CircleAnalytics;

  factory CircleAnalytics.fromJson(Map<String, dynamic> json) =>
      _$CircleAnalyticsFromJson(json);
}

/// Learning Analytics Model
@freezed
abstract class LearningAnalytics with _$LearningAnalytics {
  const factory LearningAnalytics({
    @JsonKey(name: 'total_enrollments') required int totalEnrollments,
    @JsonKey(name: 'average_completion_rate') required double averageCompletionRate,
    @JsonKey(name: 'popular_courses') required List<PopularCourse> popularCourses,
    @JsonKey(name: 'certificates_issued') required int certificatesIssued,
    @JsonKey(name: 'quiz_score_distribution') required Map<String, int> quizScoreDistribution,
  }) = _LearningAnalytics;

  factory LearningAnalytics.fromJson(Map<String, dynamic> json) =>
      _$LearningAnalyticsFromJson(json);
}

/// Popular Course Model
@freezed
abstract class PopularCourse with _$PopularCourse {
  const factory PopularCourse({
    required int id,
    required String name,
    @JsonKey(name: 'enrollment_count') required int enrollmentCount,
    @JsonKey(name: 'completion_rate') required double completionRate,
  }) = _PopularCourse;

  factory PopularCourse.fromJson(Map<String, dynamic> json) =>
      _$PopularCourseFromJson(json);
}

/// Call Analytics Model
@freezed
abstract class CallAnalytics with _$CallAnalytics {
  const factory CallAnalytics({
    @JsonKey(name: 'total_calls') required int totalCalls,
    @JsonKey(name: 'completed_calls') required int completedCalls,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'average_attendance') required double averageAttendance,
    @JsonKey(name: 'calls_trend') required List<DataPoint> callsTrend,
  }) = _CallAnalytics;

  factory CallAnalytics.fromJson(Map<String, dynamic> json) =>
      _$CallAnalyticsFromJson(json);
}

/// Engagement Analytics Model
@freezed
abstract class EngagementAnalytics with _$EngagementAnalytics {
  const factory EngagementAnalytics({
    @JsonKey(name: 'messages_count') required int messagesCount,
    @JsonKey(name: 'notes_count') required int notesCount,
    @JsonKey(name: 'actions_completed') required int actionsCompleted,
    @JsonKey(name: 'engagement_trend') required List<DataPoint> engagementTrend,
  }) = _EngagementAnalytics;

  factory EngagementAnalytics.fromJson(Map<String, dynamic> json) =>
      _$EngagementAnalyticsFromJson(json);
}

/// Flagged Content Model
@freezed
abstract class FlaggedContent with _$FlaggedContent {
  const factory FlaggedContent({
    required int id,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'content_id') required int contentId,
    required String content,
    required String reason,
    @JsonKey(name: 'reporter_id') required int reporterId,
    @JsonKey(name: 'reporter_name') required String reporterName,
    required String status, // pending, approved, removed
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FlaggedContent;

  factory FlaggedContent.fromJson(Map<String, dynamic> json) =>
      _$FlaggedContentFromJson(json);
}

/// System Settings Model
@freezed
abstract class SystemSettings with _$SystemSettings {
  const factory SystemSettings({
    @JsonKey(name: 'platform_name') required String platformName,
    @JsonKey(name: 'default_language') required String defaultLanguage,
    required String timezone,
    @JsonKey(name: 'registration_enabled') required bool registrationEnabled,
    @JsonKey(name: 'email_verification_required') required bool emailVerificationRequired,
    @JsonKey(name: 'max_circle_members') required int maxCircleMembers,
    @JsonKey(name: 'session_timeout') required int sessionTimeout,
    @JsonKey(name: 'max_file_size') required int maxFileSize,
  }) = _SystemSettings;

  factory SystemSettings.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsFromJson(json);
}
