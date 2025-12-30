import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../models/circle_details.dart';

part 'circles_provider.g.dart';

/// Provider for fetching user's circles
@riverpod
Future<List<Circle>> myCircles(MyCirclesRef ref) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    return await repository.getCircles();
  } catch (e) {
    throw Exception('Failed to load circles: ${e.toString()}');
  }
}

/// Provider for a specific circle
@riverpod
Future<Circle> circle(CircleRef ref, int circleId) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    return await repository.getCircle(circleId);
  } catch (e) {
    throw Exception('Failed to load circle: ${e.toString()}');
  }
}

/// Provider for circle members
@riverpod
Future<List<CircleMember>> circleMembers(
  CircleMembersRef ref,
  int circleId,
) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    return await repository.getCircleMembers(circleId);
  } catch (e) {
    throw Exception('Failed to load circle members: ${e.toString()}');
  }
}

/// Provider for circle calls
@riverpod
Future<List<Call>> circleCalls(CircleCallsRef ref, int circleId) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    final calls = await repository.getCircleCalls(circleId);
    // Sort by scheduled date
    calls.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return calls;
  } catch (e) {
    throw Exception('Failed to load circle calls: ${e.toString()}');
  }
}
