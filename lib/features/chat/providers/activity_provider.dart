import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../wordpress/data/models/buddyboss_models.dart';
import '../../wordpress/data/repositories/wordpress_repository.dart';

part 'activity_provider.g.dart';

/// Provider for fetching activity feed
@riverpod
Future<List<BBActivity>> activityFeed(
  ActivityFeedRef ref, {
  int page = 1,
  int perPage = 20,
  String? type,
  int? userId,
}) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(wordPressRepositoryProvider);
  
  final activities = await repository.getBBActivities(
    page: page,
    perPage: perPage,
    type: type,
    userId: userId,
  );
  
  return activities;
}

/// Notifier for activity actions (CRUD operations)
@riverpod
class ActivityActions extends _$ActivityActions {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Create a new activity post
  Future<BBActivity> createPost({
    required String content,
    int? groupId,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      final activity = await repository.createBBActivity(
        content: content,
        type: 'activity_update',
        groupId: groupId,
      );
      
      ref.invalidate(activityFeedProvider);
      
      return activity;
    }).then((result) {
      state = result;
      return result.when(
        data: (activity) => activity,
        loading: () => throw Exception('Post creation in progress'),
        error: (error, stack) => throw error,
      );
    });
  }

  /// Delete an activity
  Future<void> deleteActivity(int activityId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      
      await repository.deleteBBActivity(activityId);
      
      ref.invalidate(activityFeedProvider);
    }).then((result) {
      state = result;
      if (result.hasError) {
        throw result.error!;
      }
    });
  }
}
