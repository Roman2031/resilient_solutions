import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';

part 'mycalls_providers.g.dart';

/// Enum for call status filter
enum CallStatusFilter {
  all,
  upcoming,
  completed,
  cancelled,
}

/// State notifier for call status filter
@riverpod
class CallStatusFilterNotifier extends _$CallStatusFilterNotifier {
  @override
  CallStatusFilter build() {
    return CallStatusFilter.all;
  }

  void setFilter(CallStatusFilter filter) {
    state = filter;
  }
}

/// Provider for user's calls
/// Fetches all calls for circles the user is a member of
@riverpod
Future<List<Call>> myCalls(MyCallsRef ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  
  // Get all circles first
  final circles = await repository.getCircles();
  
  // Get calls for each circle
  final List<Call> allCalls = [];
  for (final circle in circles) {
    try {
      final circleCalls = await repository.getCircleCalls(circle.id);
      allCalls.addAll(circleCalls);
    } catch (e) {
      // Continue if one circle fails
      print('Failed to fetch calls for circle ${circle.id}: $e');
    }
  }
  
  return allCalls;
}

/// Provider for filtered calls based on selected status
@riverpod
Future<List<Call>> filteredCalls(FilteredCallsRef ref) async {
  final calls = await ref.watch(myCallsProvider.future);
  final filter = ref.watch(callStatusFilterNotifierProvider);
  
  final now = DateTime.now();
  
  switch (filter) {
    case CallStatusFilter.all:
      return calls;
    case CallStatusFilter.upcoming:
      return calls.where((call) {
        return call.scheduledAt.isAfter(now) && 
               call.status != 'cancelled' &&
               call.status != 'completed';
      }).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    case CallStatusFilter.completed:
      return calls.where((call) => call.status == 'completed').toList()
        ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    case CallStatusFilter.cancelled:
      return calls.where((call) => call.status == 'cancelled').toList()
        ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  }
}

/// Provider for a specific call by ID
@riverpod
Future<Call> callById(CallByIdRef ref, int callId) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getCall(callId);
}

/// Provider for call notes
@riverpod
Future<List<Note>> callNotes(CallNotesRef ref, int callId) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getCallNotes(callId);
}
