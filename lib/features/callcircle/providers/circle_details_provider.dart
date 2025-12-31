import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../models/circle_details.dart';
import 'circles_provider.dart';

part 'circle_details_provider.g.dart';

/// Provider for detailed circle information with all related data
@riverpod
Future<CircleDetails> circleDetails(
  Ref ref,
  int circleId,
) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    // Fetch all data in parallel
    final results = await Future.wait([
      repository.getCircle(circleId),
      repository.getCircleMembers(circleId),
      repository.getCircleCalls(circleId),
    ]);
    
    final circle = results[0] as Circle;
    final members = results[1] as List<CircleMember>;
    final calls = results[2] as List<Call>;
    
    // Separate upcoming and past calls
    final now = DateTime.now();
    final upcomingCalls = calls
        .where((call) =>
            call.scheduledAt.isAfter(now) && call.status != 'cancelled')
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    
    final pastCalls = calls
        .where((call) =>
            call.scheduledAt.isBefore(now) || call.status == 'completed')
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    
    return CircleDetails(
      circle: circle,
      members: members,
      upcomingCalls: upcomingCalls,
      pastCalls: pastCalls,
    );
  } catch (e) {
    throw Exception('Failed to load circle details: ${e.toString()}');
  }
}

/// Provider for call details with all related information
@riverpod
Future<CallDetails> callDetails(Ref ref, int callId) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    // Fetch call first to get circle ID
    final call = await repository.getCall(callId);
    
    // Fetch related data in parallel
    final results = await Future.wait([
      repository.getCallNotes(callId),
      repository.getCallActions(callId),
      repository.getCircleMembers(call.circleId),
    ]);
    
    final notes = results[0] as List<Note>;
    final actions = results[1] as List<ActionItem>;
    final participants = results[2] as List<CircleMember>;
    
    return CallDetails(
      call: call,
      notes: notes,
      actions: actions,
      participants: participants,
    );
  } catch (e) {
    throw Exception('Failed to load call details: ${e.toString()}');
  }
}
