import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/course.dart';
import '../data/repositories/course_repository.dart';

part 'course_provider.g.dart';

/// Available Courses Provider
/// Fetches all available courses from LearnDash
@riverpod
class AvailableCourses extends _$AvailableCourses {
  @override
  Future<List<Course>> build({
    String? search,
    List<int>? categories,
  }) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getCourses(
      search: search,
      categories: categories,
    );
  }

  /// Refresh courses
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getCourses();
    });
  }
}

/// Enrolled Courses Provider
/// Fetches courses the user is enrolled in
@riverpod
class EnrolledCourses extends _$EnrolledCourses {
  @override
  Future<List<Course>> build() async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getEnrolledCourses();
  }

  /// Enroll in a course
  Future<void> enrollInCourse(int courseId) async {
    final repository = ref.read(courseRepositoryProvider);
    await repository.enrollInCourse(courseId);
    await refresh();
  }

  /// Refresh enrolled courses
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getEnrolledCourses();
    });
  }
}

/// Single Course Provider
@riverpod
class CourseDetail extends _$CourseDetail {
  @override
  Future<Course> build(int courseId) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getCourseById(courseId);
  }

  /// Refresh course
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getCourseById(courseId);
    });
  }
}

/// Course Lessons Provider
@riverpod
class CourseLessons extends _$CourseLessons {
  @override
  Future<List<Lesson>> build(int courseId) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getCourseLessons(courseId);
  }

  /// Complete lesson
  Future<void> completeLesson(int lessonId) async {
    final repository = ref.read(courseRepositoryProvider);
    await repository.completeLesson(lessonId);
    await refresh();
  }

  /// Refresh lessons
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getCourseLessons(courseId);
    });
  }
}

/// Lesson Detail Provider
@riverpod
class LessonDetail extends _$LessonDetail {
  @override
  Future<Lesson> build(int lessonId) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getLessonById(lessonId);
  }

  /// Refresh lesson
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getLessonById(lessonId);
    });
  }
}

/// Lesson Topics Provider
@riverpod
class LessonTopics extends _$LessonTopics {
  @override
  Future<List<Topic>> build(int lessonId) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getLessonTopics(lessonId);
  }

  /// Complete topic
  Future<void> completeTopic(int topicId) async {
    final repository = ref.read(courseRepositoryProvider);
    await repository.completeTopic(topicId);
    await refresh();
  }

  /// Refresh topics
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getLessonTopics(lessonId);
    });
  }
}

/// Course Progress Provider
@riverpod
class CourseProgressProvider extends _$CourseProgressProvider {
  @override
  Future<CourseProgress> build(int courseId) async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getCourseProgress(courseId);
  }

  /// Refresh progress
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getCourseProgress(courseId);
    });
  }
}

/// User Progress Provider
/// Tracks progress across all enrolled courses
@riverpod
class UserProgress extends _$UserProgress {
  @override
  Future<List<CourseProgress>> build() async {
    final repository = ref.watch(courseRepositoryProvider);
    return await repository.getUserProgress();
  }

  /// Refresh all progress
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      return await repository.getUserProgress();
    });
  }
}
