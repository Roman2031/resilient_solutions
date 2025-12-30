import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import 'my_calls_provider.dart';

part 'call_actions_provider.g.dart';

/// Provider for call-related actions
@riverpod
class CallActions extends _$CallActions {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Update call status
  Future<void> updateCallStatus({
    required int callId,
    required String status,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.updateCall(
        callId: callId,
        status: status,
      );
      
      // Invalidate to refresh call lists
      ref.invalidate(myCallsProvider);
      ref.invalidate(upcomingCallsProvider);
      ref.invalidate(callProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to update call status: ${state.error}');
    }
  }

  /// Mark attendance for a call
  Future<void> markAttendance({
    required int callId,
    required bool attended,
  }) async {
    await updateCallStatus(
      callId: callId,
      status: attended ? 'completed' : 'cancelled',
    );
  }

  /// Cancel a call
  Future<void> cancelCall(int callId) async {
    await updateCallStatus(
      callId: callId,
      status: 'cancelled',
    );
  }

  /// Reschedule a call
  Future<void> rescheduleCall({
    required int callId,
    required DateTime newScheduledAt,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.updateCall(
        callId: callId,
        scheduledAt: newScheduledAt,
      );
      
      // Invalidate to refresh call lists
      ref.invalidate(myCallsProvider);
      ref.invalidate(upcomingCallsProvider);
      ref.invalidate(callProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to reschedule call: ${state.error}');
    }
  }
}
