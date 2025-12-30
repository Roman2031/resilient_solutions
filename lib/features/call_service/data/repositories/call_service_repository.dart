import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/base_repository.dart';
import '../../../../core/network/api_service.dart';
import '../models/call_service_models.dart';

part 'call_service_repository.g.dart';

/// Call Service Repository
/// Implements all Laravel Call Service API endpoints
/// Base URL: https://callcircle.resilentsolutions.com/api
@riverpod
CallServiceRepository callServiceRepository(CallServiceRepositoryRef ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CallServiceRepository(apiService);
}

class CallServiceRepository extends BaseRepository {
  final ApiService _apiService;

  CallServiceRepository(this._apiService);

  // ==================== Authentication ====================

  /// POST /login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
        backend: ApiBackend.callService,
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// GET /me
  Future<UserProfile> getMe() async {
    return execute(() async {
      final response = await _apiService.get(
        '/me',
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => UserProfile.fromJson(data),
      );
    });
  }

  /// PUT /me/profile
  Future<UserProfile> updateMyProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/me/profile',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => UserProfile.fromJson(data),
      );
    });
  }

  /// GET /me/upcoming-calls
  Future<List<UpcomingCall>> getMyUpcomingCalls() async {
    return execute(() async {
      final response = await _apiService.get(
        '/me/upcoming-calls',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => UpcomingCall.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// GET /me/actions
  Future<List<ActionItem>> getMyActions() async {
    return execute(() async {
      final response = await _apiService.get(
        '/me/actions',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => ActionItem.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  // ==================== Circles ====================

  /// GET /circles
  Future<List<Circle>> getCircles() async {
    return execute(() async {
      final response = await _apiService.get(
        '/circles',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => Circle.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /circles
  Future<Circle> createCircle({
    required String name,
    required String description,
    int? courseId,
    int? maxMembers,
    DateTime? startDate,
    DateTime? endDate,
    String? meetingSchedule,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/circles',
        data: {
          'name': name,
          'description': description,
          if (courseId != null) 'course_id': courseId,
          if (maxMembers != null) 'max_members': maxMembers,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (meetingSchedule != null) 'meeting_schedule': meetingSchedule,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Circle.fromJson(data),
      );
    });
  }

  /// GET /circles/{circle}
  Future<Circle> getCircle(int circleId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/circles/$circleId',
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Circle.fromJson(data),
      );
    });
  }

  /// PUT /circles/{circle}
  Future<Circle> updateCircle({
    required int circleId,
    String? name,
    String? description,
    int? maxMembers,
    String? meetingSchedule,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/circles/$circleId',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (maxMembers != null) 'max_members': maxMembers,
          if (meetingSchedule != null) 'meeting_schedule': meetingSchedule,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Circle.fromJson(data),
      );
    });
  }

  /// DELETE /circles/{circle}
  Future<void> deleteCircle(int circleId) async {
    return execute(() async {
      await _apiService.delete(
        '/circles/$circleId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Circle Members ====================

  /// GET /circles/{circle}/members
  Future<List<CircleMember>> getCircleMembers(int circleId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/circles/$circleId/members',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => CircleMember.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /circles/{circle}/members
  Future<CircleMember> addCircleMember({
    required int circleId,
    required int userId,
    required String role,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/circles/$circleId/members',
        data: {
          'user_id': userId,
          'role': role,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => CircleMember.fromJson(data),
      );
    });
  }

  /// PUT /circle-members/{member}
  Future<CircleMember> updateCircleMember({
    required int memberId,
    String? role,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/circle-members/$memberId',
        data: {
          if (role != null) 'role': role,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => CircleMember.fromJson(data),
      );
    });
  }

  /// DELETE /circle-members/{member}
  Future<void> deleteCircleMember(int memberId) async {
    return execute(() async {
      await _apiService.delete(
        '/circle-members/$memberId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Calls (Sessions) ====================

  /// GET /circles/{circle}/calls
  Future<List<Call>> getCircleCalls(int circleId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/circles/$circleId/calls',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => Call.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /circles/{circle}/calls
  Future<Call> createCall({
    required int circleId,
    required String title,
    String? description,
    required DateTime scheduledAt,
    int? durationMinutes,
    String? agenda,
    String? meetingLink,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/circles/$circleId/calls',
        data: {
          'title': title,
          if (description != null) 'description': description,
          'scheduled_at': scheduledAt.toIso8601String(),
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (agenda != null) 'agenda': agenda,
          if (meetingLink != null) 'meeting_link': meetingLink,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Call.fromJson(data),
      );
    });
  }

  /// GET /calls/{call}
  Future<Call> getCall(int callId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/calls/$callId',
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Call.fromJson(data),
      );
    });
  }

  /// PUT /calls/{call}
  Future<Call> updateCall({
    required int callId,
    String? title,
    String? description,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? agenda,
    String? meetingLink,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/calls/$callId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
          if (durationMinutes != null) 'duration_minutes': durationMinutes,
          if (agenda != null) 'agenda': agenda,
          if (meetingLink != null) 'meeting_link': meetingLink,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Call.fromJson(data),
      );
    });
  }

  /// DELETE /calls/{call}
  Future<void> deleteCall(int callId) async {
    return execute(() async {
      await _apiService.delete(
        '/calls/$callId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Notes ====================

  /// GET /calls/{call}/notes
  Future<List<Note>> getCallNotes(int callId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/calls/$callId/notes',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => Note.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /calls/{call}/notes
  Future<Note> createNote({
    required int callId,
    required String content,
    bool? isPrivate,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/calls/$callId/notes',
        data: {
          'content': content,
          if (isPrivate != null) 'is_private': isPrivate,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Note.fromJson(data),
      );
    });
  }

  /// PUT /notes/{note}
  Future<Note> updateNote({
    required int noteId,
    String? content,
    bool? isPrivate,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/notes/$noteId',
        data: {
          if (content != null) 'content': content,
          if (isPrivate != null) 'is_private': isPrivate,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Note.fromJson(data),
      );
    });
  }

  /// DELETE /notes/{note}
  Future<void> deleteNote(int noteId) async {
    return execute(() async {
      await _apiService.delete(
        '/notes/$noteId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Actions ====================

  /// GET /calls/{call}/actions
  Future<List<ActionItem>> getCallActions(int callId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/calls/$callId/actions',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => ActionItem.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /circles/{circle}/actions
  Future<ActionItem> createAction({
    required int circleId,
    int? callId,
    required int assignedTo,
    required String title,
    String? description,
    DateTime? dueDate,
    String? priority,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/circles/$circleId/actions',
        data: {
          if (callId != null) 'call_id': callId,
          'assigned_to': assignedTo,
          'title': title,
          if (description != null) 'description': description,
          if (dueDate != null) 'due_date': dueDate.toIso8601String(),
          if (priority != null) 'priority': priority,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => ActionItem.fromJson(data),
      );
    });
  }

  /// PUT /actions/{action}
  Future<ActionItem> updateAction({
    required int actionId,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
    String? priority,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/actions/$actionId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (dueDate != null) 'due_date': dueDate.toIso8601String(),
          if (status != null) 'status': status,
          if (priority != null) 'priority': priority,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => ActionItem.fromJson(data),
      );
    });
  }

  /// DELETE /actions/{action}
  Future<void> deleteAction(int actionId) async {
    return execute(() async {
      await _apiService.delete(
        '/actions/$actionId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Reminders ====================

  /// GET /reminders
  Future<List<Reminder>> getReminders() async {
    return execute(() async {
      final response = await _apiService.get(
        '/reminders',
        backend: ApiBackend.callService,
      );
      return handleListResponse(
        response,
        (json) => Reminder.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// POST /reminders
  Future<Reminder> createReminder({
    required String remindableType,
    required int remindableId,
    required String title,
    String? message,
    required DateTime remindAt,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/reminders',
        data: {
          'remindable_type': remindableType,
          'remindable_id': remindableId,
          'title': title,
          if (message != null) 'message': message,
          'remind_at': remindAt.toIso8601String(),
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Reminder.fromJson(json),
      );
    });
  }

  /// PUT /reminders/{reminder}
  Future<Reminder> updateReminder({
    required int reminderId,
    String? title,
    String? message,
    DateTime? remindAt,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/reminders/$reminderId',
        data: {
          if (title != null) 'title': title,
          if (message != null) 'message': message,
          if (remindAt != null) 'remind_at': remindAt.toIso8601String(),
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Reminder.fromJson(data),
      );
    });
  }

  /// DELETE /reminders/{reminder}
  Future<void> deleteReminder(int reminderId) async {
    return execute(() async {
      await _apiService.delete(
        '/reminders/$reminderId',
        backend: ApiBackend.callService,
      );
    });
  }

  // ==================== Devices ====================

  /// POST /devices
  Future<Device> registerDevice({
    required String deviceToken,
    required String deviceType,
    String? deviceName,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/devices',
        data: {
          'device_token': deviceToken,
          'device_type': deviceType,
          if (deviceName != null) 'device_name': deviceName,
        },
        backend: ApiBackend.callService,
      );
      return handleResponse(
        response,
        (data) => Device.fromJson(data),
      );
    });
  }

  /// DELETE /devices/{device}
  Future<void> unregisterDevice(int deviceId) async {
    return execute(() async {
      await _apiService.delete(
        '/devices/$deviceId',
        backend: ApiBackend.callService,
      );
    });
  }
}
