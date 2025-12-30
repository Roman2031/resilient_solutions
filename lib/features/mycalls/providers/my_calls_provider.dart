import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../models/call_filter.dart';

part 'my_calls_provider.g.dart';

/// Provider for fetching all user's calls
@riverpod
Future<List<Call>> myCalls(MyCallsRef ref) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    // Get user's circles
    final circles = await repository.getCircles();
    
    // Fetch calls for each circle
    List<Call> allCalls = [];
    for (final circle in circles) {
      try {
        final calls = await repository.getCircleCalls(circle.id);
        allCalls.addAll(calls);
      } catch (e) {
        // Continue if one circle fails
        continue;
      }
    }
    
    // Sort by scheduled date (most recent first)
    allCalls.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    
    return allCalls;
  } catch (e) {
    throw Exception('Failed to load calls: ${e.toString()}');
  }
}

/// Provider for fetching upcoming calls
@riverpod
Future<List<UpcomingCall>> upcomingCalls(UpcomingCallsRef ref) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    return await repository.getMyUpcomingCalls();
  } catch (e) {
    throw Exception('Failed to load upcoming calls: ${e.toString()}');
  }
}

/// Provider for filtered calls
@riverpod
Future<List<Call>> filteredCalls(
  FilteredCallsRef ref,
  CallFilter filter,
  String searchQuery,
) async {
  final calls = await ref.watch(myCallsProvider.future);
  
  // Apply filter
  var filtered = calls.where((call) {
    return filter.matches(call.status, call.scheduledAt);
  }).toList();
  
  // Apply search
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filtered = filtered.where((call) {
      return call.title.toLowerCase().contains(query) ||
          (call.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
  
  return filtered;
}

/// Provider for a specific call by ID
@riverpod
Future<Call> call(CallRef ref, int callId) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  
  try {
    return await repository.getCall(callId);
  } catch (e) {
    throw Exception('Failed to load call: ${e.toString()}');
  }
}
