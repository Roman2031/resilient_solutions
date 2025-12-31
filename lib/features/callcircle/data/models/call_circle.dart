import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_circle.freezed.dart';
part 'call_circle.g.dart';

/// Call Circle Model
/// Represents a call circle from Laravel backend
@freezed
abstract class CallCircle with _$CallCircle {
  const factory CallCircle({
    required int id,
    required String name,
    required String description,
    @JsonKey(name: 'facilitator_id') required int facilitatorId,
    @JsonKey(name: 'course_id') int? courseId,
    @JsonKey(name: 'max_members') int? maxMembers,
    @JsonKey(name: 'current_members_count') @Default(0) int currentMembersCount,
    required String status, // active, completed, cancelled
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'meeting_schedule') String? meetingSchedule,
    @JsonKey(name: 'meeting_link') String? meetingLink,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CallCircle;

  factory CallCircle.fromJson(Map<String, dynamic> json) =>
      _$CallCircleFromJson(json);
}

/// Call Circle Session Model
@freezed
abstract class CallCircleSession with _$CallCircleSession {
  const factory CallCircleSession({
    required int id,
    @JsonKey(name: 'call_circle_id') required int callCircleId,
    required String title,
    String? description,
    @JsonKey(name: 'session_date') required DateTime sessionDate,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    required String status, // scheduled, in_progress, completed, cancelled
    @JsonKey(name: 'meeting_link') String? meetingLink,
    String? agenda,
    String? notes,
    @JsonKey(name: 'attendance_count') @Default(0) int attendanceCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CallCircleSession;

  factory CallCircleSession.fromJson(Map<String, dynamic> json) =>
      _$CallCircleSessionFromJson(json);
}

/// Call Circle Member Model
@freezed
abstract class CallCircleMember with _$CallCircleMember {
  const factory CallCircleMember({
    required int id,
    @JsonKey(name: 'call_circle_id') required int callCircleId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'user_email') required String userEmail,
    @JsonKey(name: 'user_avatar') String? userAvatar,
    required String role, // facilitator, instructor, learner
    required String status, // active, inactive, removed
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
  }) = _CallCircleMember;

  factory CallCircleMember.fromJson(Map<String, dynamic> json) =>
      _$CallCircleMemberFromJson(json);
}

/// Attendance Model
@freezed
abstract class Attendance with _$Attendance {
  const factory Attendance({
    required int id,
    @JsonKey(name: 'session_id') required int sessionId,
    @JsonKey(name: 'user_id') required int userId,
    required String status, // present, absent, late
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'left_at') DateTime? leftAt,
    String? notes,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}
