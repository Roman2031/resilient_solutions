import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';

part 'actions_provider.g.dart';

/// Provider for all action items assigned to the current user
@riverpod
Future<List<ActionItem>> myActions(Ref ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  final actions = await repository.getMyActions();
  
  // Sort by due date (nearest first), then by priority
  actions.sort((a, b) {
    // Items with due dates come first
    if (a.dueDate != null && b.dueDate == null) return -1;
    if (a.dueDate == null && b.dueDate != null) return 1;
    
    // Compare due dates
    if (a.dueDate != null && b.dueDate != null) {
      final dateCompare = a.dueDate!.compareTo(b.dueDate!);
      if (dateCompare != 0) return dateCompare;
    }
    
    // Compare by priority
    final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
    final aPriority = priorityOrder[a.priority?.toLowerCase()] ?? 3;
    final bPriority = priorityOrder[b.priority?.toLowerCase()] ?? 3;
    return aPriority.compareTo(bPriority);
  });
  
  return actions;
}

/// Provider for filtered action items by status
@riverpod
Future<List<ActionItem>> filteredActions(
  Ref ref,
  String status,
) async {
  final allActions = await ref.watch(myActionsProvider.future);
  
  if (status == 'all') {
    return allActions;
  }
  
  return allActions.where((action) => action.status == status).toList();
}

/// Provider for searching action items
@riverpod
Future<List<ActionItem>> searchActions(
  Ref ref,
  String query,
) async {
  final allActions = await ref.watch(myActionsProvider.future);
  
  if (query.isEmpty) {
    return allActions;
  }
  
  final lowerQuery = query.toLowerCase();
  return allActions.where((action) {
    return action.title.toLowerCase().contains(lowerQuery) ||
        (action.description?.toLowerCase().contains(lowerQuery) ?? false);
  }).toList();
}

/// Notifier for action item operations (CRUD)
@riverpod
class ActionActionsNotifier extends _$ActionActionsNotifier {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Create a new action item
  Future<ActionItem> createAction({
    required int circleId,
    int? callId,
    required int assignedTo,
    required String title,
    String? description,
    DateTime? dueDate,
    String? priority,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      final newAction = await repository.createAction(
        circleId: circleId,
        callId: callId,
        assignedTo: assignedTo,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
      );

      // Invalidate actions providers to refetch
      ref.invalidate(myActionsProvider);

      return newAction;
    }).then((result) {
      state = result;
      return result.when(
        data: (action) => action as ActionItem,
        loading: () => throw Exception('Action creation in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Update an existing action item
  Future<ActionItem> updateAction({
    required int actionId,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
    String? priority,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      final updatedAction = await repository.updateAction(
        actionId: actionId,
        title: title,
        description: description,
        dueDate: dueDate,
        status: status,
        priority: priority,
      );

      // Invalidate actions providers to refetch
      ref.invalidate(myActionsProvider);

      return updatedAction;
    }).then((result) {
      state = result;
      return result.when(
        data: (action) => action as ActionItem,
        loading: () => throw Exception('Action update in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Delete an action item
  Future<void> deleteAction(int actionId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      await repository.deleteAction(actionId);

      // Invalidate actions providers to refetch
      ref.invalidate(myActionsProvider);
    });
  }

  /// Mark action as completed
  Future<ActionItem> markComplete(int actionId) async {
    return updateAction(actionId: actionId, status: 'completed');
  }

  /// Mark action as in progress
  Future<ActionItem> markInProgress(int actionId) async {
    return updateAction(actionId: actionId, status: 'in_progress');
  }
}
