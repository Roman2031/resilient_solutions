import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../../mycalls/providers/my_calls_provider.dart';
import '../../callcircle/providers/circles_provider.dart';

part 'call_scheduler_provider.g.dart';

/// Provider for calendar calls grouped by date
@riverpod
Future<Map<DateTime, List<Call>>> calendarCalls(
  CalendarCallsRef ref,
  DateTime month,
) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    // Get all circles
    final circles = await repository.getCircles();
    
    Map<DateTime, List<Call>> callsByDate = {};
    
    // Fetch calls for each circle
    for (final circle in circles) {
      try {
        final calls = await repository.getCircleCalls(circle.id);
        
        // Group by date
        for (final call in calls) {
          final date = DateTime(
            call.scheduledAt.year,
            call.scheduledAt.month,
            call.scheduledAt.day,
          );
          
          // Only include calls from the specified month
          if (date.month == month.month && date.year == month.year) {
            callsByDate[date] = [...?callsByDate[date], call];
          }
        }
      } catch (e) {
        // Continue if one circle fails
        continue;
      }
    }
    
    return callsByDate;
  } catch (e) {
    throw Exception('Failed to load calendar calls: ${e.toString()}');
  }
}

/// Provider for call scheduling actions
@riverpod
class CallScheduler extends _$CallScheduler {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Schedule a new call
  Future<Call> scheduleCall({
    required int circleId,
    required String title,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? description,
    String? agenda,
    String? meetingLink,
  }) async {
    state = const AsyncValue.loading();
    
    Call? scheduledCall;
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      scheduledCall = await repository.createCall(
        circleId: circleId,
        title: title,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        description: description,
        agenda: agenda,
        meetingLink: meetingLink,
      );
      
      // Invalidate to refresh
      ref.invalidate(myCallsProvider);
      ref.invalidate(upcomingCallsProvider);
      ref.invalidate(circleCallsProvider);
      ref.invalidate(calendarCallsProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to schedule call: ${state.error}');
    }
    
    return scheduledCall!;
  }

  /// Update a scheduled call
  Future<void> updateScheduledCall({
    required int callId,
    String? title,
    String? description,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? agenda,
    String? meetingLink,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.updateCall(
        callId: callId,
        title: title,
        description: description,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        agenda: agenda,
        meetingLink: meetingLink,
      );
      
      // Invalidate to refresh
      ref.invalidate(myCallsProvider);
      ref.invalidate(upcomingCallsProvider);
      ref.invalidate(callProvider);
      ref.invalidate(circleCallsProvider);
      ref.invalidate(calendarCallsProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to update call: ${state.error}');
    }
  }

  /// Cancel a scheduled call
  Future<void> cancelScheduledCall(int callId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.deleteCall(callId);
      
      // Invalidate to refresh
      ref.invalidate(myCallsProvider);
      ref.invalidate(upcomingCallsProvider);
      ref.invalidate(circleCallsProvider);
      ref.invalidate(calendarCallsProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to cancel call: ${state.error}');
    }
  }
}
