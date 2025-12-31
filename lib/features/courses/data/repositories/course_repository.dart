import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/base_repository.dart';
import '../../../../core/network/api_service.dart';
import '../models/course.dart';

part 'course_repository.g.dart';

/// Course Repository
/// Handles all API calls to WordPress LearnDash for courses, lessons, and progress
@riverpod
CourseRepository courseRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CourseRepository(apiService);
}

class CourseRepository extends BaseRepository {
  final ApiService _apiService;

  CourseRepository(this._apiService);

  /// Get all available courses
  Future<List<Course>> getCourses({
    int? page,
    int? perPage,
    String? search,
    List<int>? categories,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/courses',
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
          if (search != null) 'search': search,
          if (categories != null && categories.isNotEmpty)
            'categories': categories.join(','),
        },
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => Course.fromJson(json),
      );
    });
  }

  /// Get enrolled courses for current user
  Future<List<Course>> getEnrolledCourses() async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/users/me/courses',
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => Course.fromJson(json),
      );
    });
  }

  /// Get course by ID
  Future<Course> getCourseById(int id) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/courses/$id',
        backend: ApiBackend.wordpress,
      );

      return handleResponse(
        response,
        (data) => Course.fromJson(data),
      );
    });
  }

  /// Enroll in a course
  Future<void> enrollInCourse(int courseId) async {
    return execute(() async {
      await _apiService.post(
        '/learndash/v2/courses/$courseId/enroll',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// Get lessons for a course
  Future<List<Lesson>> getCourseLessons(int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/courses/$courseId/lessons',
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => Lesson.fromJson(json),
      );
    });
  }

  /// Get lesson by ID
  Future<Lesson> getLessonById(int lessonId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/lessons/$lessonId',
        backend: ApiBackend.wordpress,
      );

      return handleResponse(
        response,
        (data) => Lesson.fromJson(data),
      );
    });
  }

  /// Mark lesson as complete
  Future<void> completeLesson(int lessonId) async {
    return execute(() async {
      await _apiService.post(
        '/learndash/v2/lessons/$lessonId/complete',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// Get topics for a lesson
  Future<List<Topic>> getLessonTopics(int lessonId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/lessons/$lessonId/topics',
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => Topic.fromJson(json),
      );
    });
  }

  /// Mark topic as complete
  Future<void> completeTopic(int topicId) async {
    return execute(() async {
      await _apiService.post(
        '/learndash/v2/topics/$topicId/complete',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// Get quizzes for a course
  Future<List<Quiz>> getCourseQuizzes(int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/courses/$courseId/quizzes',
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => Quiz.fromJson(json),
      );
    });
  }

  /// Get course progress
  Future<CourseProgress> getCourseProgress(int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/users/me/course-progress/$courseId',
        backend: ApiBackend.wordpress,
      );

      return handleResponse(
        response,
        (data) => CourseProgress.fromJson(data),
      );
    });
  }

  /// Get all user progress
  Future<List<CourseProgress>> getUserProgress() async {
    return execute(() async {
      final response = await _apiService.get(
        '/learndash/v2/users/me/progress',
        backend: ApiBackend.wordpress,
      );

      return handleListResponse(
        response,
        (json) => CourseProgress.fromJson(json),
      );
    });
  }
}
