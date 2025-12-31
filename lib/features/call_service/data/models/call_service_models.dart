import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_service_models.freezed.dart';
part 'call_service_models.g.dart';

/// User Profile Model
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? avatar,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Circle Model (Call Circle)
@freezed
abstract class Circle with _$Circle {
  const factory Circle({
    required int id,
    required String name,
    required String description,
    @JsonKey(name: 'facilitator_id') required int facilitatorId,
    @JsonKey(name: 'course_id') int? courseId,
    @JsonKey(name: 'max_members') int? maxMembers,
    @JsonKey(name: 'members_count') @Default(0) int membersCount,
    required String status, // active, completed, cancelled
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'meeting_schedule') String? meetingSchedule,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Circle;

  factory Circle.fromJson(Map<String, dynamic> json) =>
      _$CircleFromJson(json);
}

/// Circle Member Model
@freezed
abstract class CircleMember with _$CircleMember {
  const factory CircleMember({
    required int id,
    @JsonKey(name: 'circle_id') required int circleId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_email') String? userEmail,
    required String role, // facilitator, instructor, learner
    required String status, // active, inactive
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CircleMember;

  factory CircleMember.fromJson(Map<String, dynamic> json) =>
      _$CircleMemberFromJson(json);
}

/// Call Model (Session)
@freezed
abstract class Call with _$Call {
  const factory Call({
    required int id,
    @JsonKey(name: 'circle_id') required int circleId,
    required String title,
    String? description,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    required String status, // scheduled, in_progress, completed, cancelled
    @JsonKey(name: 'meeting_link') String? meetingLink,
    String? agenda,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Call;

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);
}

/// Note Model
@freezed
abstract class Note with _$Note {
  const factory Note({
    required int id,
    @JsonKey(name: 'call_id') required int callId,
    @JsonKey(name: 'user_id') required int userId,
    required String content,
    @JsonKey(name: 'is_private') @Default(false) bool isPrivate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

/// Action Item Model
@freezed
abstract class ActionItem with _$ActionItem {
  const factory ActionItem({
    required int id,
    @JsonKey(name: 'circle_id') int? circleId,
    @JsonKey(name: 'call_id') int? callId,
    @JsonKey(name: 'assigned_to') required int assignedTo,
    required String title,
    String? description,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    required String status, // pending, in_progress, completed, cancelled
    String? priority, // low, medium, high
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ActionItem;

  factory ActionItem.fromJson(Map<String, dynamic> json) =>
      _$ActionItemFromJson(json);
}

/// Reminder Model
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'remindable_type') required String remindableType,
    @JsonKey(name: 'remindable_id') required int remindableId,
    required String title,
    String? message,
    @JsonKey(name: 'remind_at') required DateTime remindAt,
    @JsonKey(name: 'is_sent') @Default(false) bool isSent,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}

/// Device Model (for push notifications)
@freezed
abstract class Device with _$Device {
  const factory Device({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'device_token') required String deviceToken,
    @JsonKey(name: 'device_type') required String deviceType, // ios, android
    @JsonKey(name: 'device_name') String? deviceName,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) =>
      _$DeviceFromJson(json);
}

/// Upcoming Call Model
@freezed
abstract class UpcomingCall with _$UpcomingCall {
  const factory UpcomingCall({
    required int id,
    @JsonKey(name: 'circle_id') required int circleId,
    @JsonKey(name: 'circle_name') required String circleName,
    required String title,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'meeting_link') String? meetingLink,
  }) = _UpcomingCall;

  factory UpcomingCall.fromJson(Map<String, dynamic> json) =>
      _$UpcomingCallFromJson(json);
}
