import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kindomcall/features/courses/data/models/course.dart';
import '../../wordpress/data/repositories/wordpress_repository.dart';
import '../../../core/auth/auth_repository.dart';

part 'lessons_provider.g.dart';

/// Provider for lesson details
@riverpod
Future<Lesson> lessonDetails(
  Ref ref,
  int lessonId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  return await repository.getLesson(lessonId);
}

/// Provider for topics by lesson
@riverpod
Future<List<Topic>> lessonTopics(
  Ref ref,
  int lessonId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  return await repository.getTopicsByLesson(lessonId);
}

/// Notifier for lesson actions
@riverpod
class LessonActions extends _$LessonActions {
  @override
  FutureOr<void> build() {
    return null;
  }

  /// Complete a lesson
  Future<void> completeLesson(int lessonId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      await repository.completeLesson(lessonId);

      // Invalidate to refresh
      ref.invalidate(lessonDetailsProvider(lessonId));
    });
  }

  /// Update lesson progress
  Future<void> updateProgress({
    required int lessonId,
    int? progressPercentage,
    int? videoPosition,
  }) async {
    final repository = ref.read(wordPressRepositoryProvider);
    await repository.updateLessonProgress(
      lessonId,
      progressPercentage: progressPercentage,
      videoPosition: videoPosition,
    );
  }
}

/// Notifier for topic actions
@riverpod
class TopicActions extends _$TopicActions {
  @override
  FutureOr<void> build() {
    return null;
  }

  /// Complete a topic
  Future<void> completeTopic(int topicId, int lessonId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      await repository.completeTopic(topicId);

      // Invalidate to refresh
      ref.invalidate(lessonTopicsProvider(lessonId));
    });
  }
}
