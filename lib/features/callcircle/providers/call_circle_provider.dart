import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/call_circle.dart';
import '../data/repositories/call_circle_repository.dart';

part 'call_circle_provider.g.dart';

/// My Call Circles Provider
/// Fetches and manages call circles for the authenticated user
@riverpod
class MyCallCircles extends _$MyCallCircles {
  @override
  Future<List<CallCircle>> build({String? status}) async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getMyCallCircles(status: status);
  }

  /// Refresh call circles
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.getMyCallCircles();
    });
  }
}

/// Single Call Circle Provider
/// Fetches and manages a single call circle by ID
@riverpod
class CallCircleDetail extends _$CallCircleDetail {
  @override
  Future<CallCircle> build(int circleId) async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getCallCircleById(circleId);
  }

  /// Refresh call circle
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.getCallCircleById(circleId);
    });
  }

  /// Update call circle
  Future<void> update({
    String? name,
    String? description,
    int? maxMembers,
    String? meetingSchedule,
    String? meetingLink,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.updateCallCircle(
        id: circleId,
        name: name,
        description: description,
        maxMembers: maxMembers,
        meetingSchedule: meetingSchedule,
        meetingLink: meetingLink,
        status: status,
      );
    });
  }
}

/// Call Circle Members Provider
@riverpod
class CallCircleMembers extends _$CallCircleMembers {
  @override
  Future<List<CallCircleMember>> build(int circleId) async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getCallCircleMembers(circleId);
  }

  /// Add member
  Future<void> addMember({
    required int userId,
    required String role,
  }) async {
    final repository = ref.read(callCircleRepositoryProvider);
    await repository.addMember(
      circleId: circleId,
      userId: userId,
      role: role,
    );
    await refresh();
  }

  /// Remove member
  Future<void> removeMember(int memberId) async {
    final repository = ref.read(callCircleRepositoryProvider);
    await repository.removeMember(
      circleId: circleId,
      memberId: memberId,
    );
    await refresh();
  }

  /// Refresh members
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.getCallCircleMembers(circleId);
    });
  }
}

/// Call Circle Sessions Provider
@riverpod
class CallCircleSessions extends _$CallCircleSessions {
  @override
  Future<List<CallCircleSession>> build(int circleId, {String? status}) async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getSessions(
      circleId: circleId,
      status: status,
    );
  }

  /// Create session
  Future<void> createSession({
    required String title,
    String? description,
    required DateTime sessionDate,
    required int durationMinutes,
    String? agenda,
  }) async {
    final repository = ref.read(callCircleRepositoryProvider);
    await repository.createSession(
      circleId: circleId,
      title: title,
      description: description,
      sessionDate: sessionDate,
      durationMinutes: durationMinutes,
      agenda: agenda,
    );
    await refresh();
  }

  /// Refresh sessions
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.getSessions(circleId: circleId);
    });
  }
}

/// Session Attendance Provider
@riverpod
class SessionAttendance extends _$SessionAttendance {
  @override
  Future<List<Attendance>> build(int sessionId) async {
    final repository = ref.watch(callCircleRepositoryProvider);
    return await repository.getSessionAttendance(sessionId);
  }

  /// Record attendance
  Future<void> recordAttendance({
    required String status,
    String? notes,
  }) async {
    final repository = ref.read(callCircleRepositoryProvider);
    await repository.recordAttendance(
      sessionId: sessionId,
      status: status,
      notes: notes,
    );
    await refresh();
  }

  /// Refresh attendance
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callCircleRepositoryProvider);
      return await repository.getSessionAttendance(sessionId);
    });
  }
}
