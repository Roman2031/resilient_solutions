import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/base_repository.dart';
import '../../../../core/network/api_service.dart';
import '../models/call_circle.dart';

part 'call_circle_repository.g.dart';

/// Call Circle Repository
/// Handles all API calls related to Call Circles
/// Integrates with Laravel backend endpoints
@riverpod
CallCircleRepository callCircleRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CallCircleRepository(apiService);
}

class CallCircleRepository extends BaseRepository {
  final ApiService _apiService;

  CallCircleRepository(this._apiService);

  /// Get all call circles for the authenticated user
  Future<List<CallCircle>> getMyCallCircles({
    String? status,
    int? page,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/call-circles/my-circles',
        queryParameters: {
          if (status != null) 'status': status,
          if (page != null) 'page': page,
        },
      );

      return handleListResponse(
        response,
        (json) => CallCircle.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// Get call circle by ID
  Future<CallCircle> getCallCircleById(int id) async {
    return execute(() async {
      final response = await _apiService.get('/call-circles/$id');
      return handleResponse(
        response,
        (data) => CallCircle.fromJson(data['data']),
      );
    });
  }

  /// Create a new call circle
  Future<CallCircle> createCallCircle({
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
        '/call-circles',
        data: {
          'name': name,
          'description': description,
          if (courseId != null) 'course_id': courseId,
          if (maxMembers != null) 'max_members': maxMembers,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (meetingSchedule != null) 'meeting_schedule': meetingSchedule,
        },
      );

      return handleResponse(
        response,
        (data) => CallCircle.fromJson(data['data']),
      );
    });
  }

  /// Update call circle
  Future<CallCircle> updateCallCircle({
    required int id,
    String? name,
    String? description,
    int? maxMembers,
    String? meetingSchedule,
    String? meetingLink,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.put(
        '/call-circles/$id',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (maxMembers != null) 'max_members': maxMembers,
          if (meetingSchedule != null) 'meeting_schedule': meetingSchedule,
          if (meetingLink != null) 'meeting_link': meetingLink,
          if (status != null) 'status': status,
        },
      );

      return handleResponse(
        response,
        (data) => CallCircle.fromJson(data['data']),
      );
    });
  }

  /// Get call circle members
  Future<List<CallCircleMember>> getCallCircleMembers(int circleId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/call-circles/$circleId/members',
      );

      return handleListResponse(
        response,
        (json) => CallCircleMember.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// Add member to call circle
  Future<void> addMember({
    required int circleId,
    required int userId,
    required String role,
  }) async {
    return execute(() async {
      await _apiService.post(
        '/call-circles/$circleId/members',
        data: {
          'user_id': userId,
          'role': role,
        },
      );
    });
  }

  /// Remove member from call circle
  Future<void> removeMember({
    required int circleId,
    required int memberId,
  }) async {
    return execute(() async {
      await _apiService.delete(
        '/call-circles/$circleId/members/$memberId',
      );
    });
  }

  /// Get call circle sessions
  Future<List<CallCircleSession>> getSessions({
    required int circleId,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/call-circles/$circleId/sessions',
        queryParameters: {
          if (status != null) 'status': status,
        },
      );

      return handleListResponse(
        response,
        (json) => CallCircleSession.fromJson(json),
        dataKey: 'data',
      );
    });
  }

  /// Create session
  Future<CallCircleSession> createSession({
    required int circleId,
    required String title,
    String? description,
    required DateTime sessionDate,
    required int durationMinutes,
    String? agenda,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/call-circles/$circleId/sessions',
        data: {
          'title': title,
          if (description != null) 'description': description,
          'session_date': sessionDate.toIso8601String(),
          'duration_minutes': durationMinutes,
          if (agenda != null) 'agenda': agenda,
        },
      );

      return handleResponse(
        response,
        (data) => CallCircleSession.fromJson(data['data']),
      );
    });
  }

  /// Record attendance
  Future<void> recordAttendance({
    required int sessionId,
    required String status,
    String? notes,
  }) async {
    return execute(() async {
      await _apiService.post(
        '/sessions/$sessionId/attendance',
        data: {
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );
    });
  }

  /// Get session attendance
  Future<List<Attendance>> getSessionAttendance(int sessionId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/sessions/$sessionId/attendance',
      );

      return handleListResponse(
        response,
        (json) => Attendance.fromJson(json),
        dataKey: 'data',
      );
    });
  }
}
