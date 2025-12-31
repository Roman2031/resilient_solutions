import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/base_repository.dart';
import '../../../../core/network/api_service.dart';
import '../../../courses/data/models/course.dart';
import '../../../courses/data/models/quiz_models.dart';
import '../models/buddyboss_models.dart';

part 'wordpress_repository.g.dart';

/// WordPress Repository
/// Implements all WordPress + LearnDash + BuddyBoss API endpoints
/// Base URL: https://learning.kingdominc.com/wp-json
@riverpod
WordPressRepository wordPressRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WordPressRepository(apiService);
}

class WordPressRepository extends BaseRepository {
  final ApiService _apiService;

  WordPressRepository(this._apiService);

  // ==================== LearnDash Courses ====================

  /// GET /ldlms/v2/sfwd-courses
  Future<List<Course>> getCourses({
    int? page,
    int? perPage,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-courses',
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
        },
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Course.fromJson(json),
      );
    });
  }

  /// GET /ldlms/v2/sfwd-courses/{id}
  Future<Course> getCourse(int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-courses/$courseId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Course.fromJson(data),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-courses
  Future<Course> createCourse({
    required String title,
    required String content,
    String? excerpt,
    List<int>? categories,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/sfwd-courses',
        data: {
          'title': title,
          'content': content,
          if (excerpt != null) 'excerpt': excerpt,
          if (categories != null) 'categories': categories,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Course.fromJson(data),
      );
    });
  }

  /// POST/PATCH /ldlms/v2/sfwd-courses/{id}
  Future<Course> updateCourse({
    required int courseId,
    String? title,
    String? content,
    String? excerpt,
    List<int>? categories,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/ldlms/v2/sfwd-courses/$courseId',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
          if (excerpt != null) 'excerpt': excerpt,
          if (categories != null) 'categories': categories,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Course.fromJson(data),
      );
    });
  }

  /// DELETE /ldlms/v2/sfwd-courses/{id}
  Future<void> deleteCourse(int courseId) async {
    return execute(() async {
      await _apiService.delete(
        '/ldlms/v2/sfwd-courses/$courseId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Essays ====================

  /// GET /ldlms/v2/sfwd-essays
  Future<List<Map<String, dynamic>>> getEssays() async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-essays',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => json,
      );
    });
  }

  // ==================== LearnDash Groups ====================

  /// GET /ldlms/v2/groups
  Future<List<Map<String, dynamic>>> getLearnDashGroups() async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/groups',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => json,
      );
    });
  }

  /// POST /ldlms/v2/groups
  Future<Map<String, dynamic>> createLearnDashGroup({
    required String title,
    required String content,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/groups',
        data: {
          'title': title,
          'content': content,
        },
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// GET /ldlms/v2/groups/{id}
  Future<Map<String, dynamic>> getLearnDashGroup(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/groups/$groupId',
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// POST/PATCH /ldlms/v2/groups/{id}
  Future<Map<String, dynamic>> updateLearnDashGroup({
    required int groupId,
    String? title,
    String? content,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/ldlms/v2/groups/$groupId',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
        },
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// DELETE /ldlms/v2/groups/{id}
  Future<void> deleteLearnDashGroup(int groupId) async {
    return execute(() async {
      await _apiService.delete(
        '/ldlms/v2/groups/$groupId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Lessons ====================

  /// GET /ldlms/v2/sfwd-lessons
  Future<List<Lesson>> getLessons() async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-lessons',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Lesson.fromJson(json),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-lessons
  Future<Lesson> createLesson({
    required String title,
    required String content,
    required int courseId,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/sfwd-lessons',
        data: {
          'title': title,
          'content': content,
          'course_id': courseId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Lesson.fromJson(data),
      );
    });
  }

  /// GET /ldlms/v2/sfwd-lessons/{id}
  Future<Lesson> getLesson(int lessonId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-lessons/$lessonId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Lesson.fromJson(data),
      );
    });
  }

  /// POST/PATCH /ldlms/v2/sfwd-lessons/{id}
  Future<Lesson> updateLesson({
    required int lessonId,
    String? title,
    String? content,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/ldlms/v2/sfwd-lessons/$lessonId',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Lesson.fromJson(data),
      );
    });
  }

  /// DELETE /ldlms/v2/sfwd-lessons/{id}
  Future<void> deleteLesson(int lessonId) async {
    return execute(() async {
      await _apiService.delete(
        '/ldlms/v2/sfwd-lessons/$lessonId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Topics ====================

  /// GET /ldlms/v2/sfwd-topic
  Future<List<Topic>> getTopics() async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-topic',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Topic.fromJson(json),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-topic
  Future<Topic> createTopic({
    required String title,
    required String content,
    required int lessonId,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/sfwd-topic',
        data: {
          'title': title,
          'content': content,
          'lesson_id': lessonId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Topic.fromJson(data),
      );
    });
  }

  /// GET /ldlms/v2/sfwd-topic/{id}
  Future<Topic> getTopic(int topicId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-topic/$topicId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Topic.fromJson(data),
      );
    });
  }

  /// POST/PATCH /ldlms/v2/sfwd-topic/{id}
  Future<Topic> updateTopic({
    required int topicId,
    String? title,
    String? content,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/ldlms/v2/sfwd-topic/$topicId',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Topic.fromJson(data),
      );
    });
  }

  // ==================== LearnDash Quizzes ====================

  /// GET /ldlms/v2/sfwd-quiz
  Future<List<Quiz>> getQuizzes() async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-quiz',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Quiz.fromJson(json),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-quiz
  Future<Quiz> createQuiz({
    required String title,
    required String content,
    int? courseId,
    int? lessonId,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/sfwd-quiz',
        data: {
          'title': title,
          'content': content,
          if (courseId != null) 'course_id': courseId,
          if (lessonId != null) 'lesson_id': lessonId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Quiz.fromJson(data),
      );
    });
  }

  /// GET /ldlms/v2/sfwd-quiz/{id}
  Future<Quiz> getQuiz(int quizId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-quiz/$quizId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Quiz.fromJson(data),
      );
    });
  }

  /// POST/PATCH /ldlms/v2/sfwd-quiz/{id}
  Future<Quiz> updateQuiz({
    required int quizId,
    String? title,
    String? content,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/ldlms/v2/sfwd-quiz/$quizId',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => Quiz.fromJson(data),
      );
    });
  }

  /// DELETE /ldlms/v2/sfwd-quiz/{id}
  Future<void> deleteQuiz(int quizId) async {
    return execute(() async {
      await _apiService.delete(
        '/ldlms/v2/sfwd-quiz/$quizId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== BuddyBoss Groups ====================

  /// GET /buddyboss/v1/groups
  Future<List<BBGroup>> getBBGroups() async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => BBGroup.fromJson(json),
      );
    });
  }

  /// GET /buddyboss/v1/groups/{id}
  Future<BBGroup> getBBGroup(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/$groupId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBGroup.fromJson(data),
      );
    });
  }

  /// POST/PATCH /buddyboss/v1/groups/{id}
  Future<BBGroup> updateBBGroup({
    required int groupId,
    String? name,
    String? description,
    String? status,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/buddyboss/v1/groups/$groupId',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (status != null) 'status': status,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBGroup.fromJson(data),
      );
    });
  }

  /// DELETE /buddyboss/v1/groups/{id}
  Future<void> deleteBBGroup(int groupId) async {
    return execute(() async {
      await _apiService.delete(
        '/buddyboss/v1/groups/$groupId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== BuddyBoss Group Members ====================

  /// GET /buddyboss/v1/groups/{id}/members
  Future<List<BBGroupMember>> getBBGroupMembers(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/$groupId/members',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => BBGroupMember.fromJson(json),
      );
    });
  }

  /// DELETE /buddyboss/v1/groups/{groupId}/members/{userId}
  Future<void> removeBBGroupMember({
    required int groupId,
    required int userId,
  }) async {
    return execute(() async {
      await _apiService.delete(
        '/buddyboss/v1/groups/$groupId/members/$userId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== BuddyBoss Group Details ====================

  /// GET /buddyboss/v1/groups/{id}/avatar
  Future<Map<String, dynamic>> getBBGroupAvatar(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/$groupId/avatar',
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// GET /buddyboss/v1/groups/{id}/cover
  Future<Map<String, dynamic>> getBBGroupCover(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/$groupId/cover',
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// GET /buddyboss/v1/groups/{id}/detail
  Future<Map<String, dynamic>> getBBGroupDetail(int groupId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/$groupId/detail',
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  /// GET /buddyboss/v1/groups/details
  Future<List<Map<String, dynamic>>> getBBGroupsDetails() async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/details',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => json,
      );
    });
  }

  /// GET /buddyboss/v1/groups/types
  Future<List<BBGroupType>> getBBGroupTypes() async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/groups/types',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => BBGroupType.fromJson(json),
      );
    });
  }

  // ==================== BuddyBoss Activity ====================

  /// GET /buddyboss/v1/activity
  Future<List<BBActivity>> getBBActivities({
    int? page,
    int? perPage,
    String? type,
    int? userId,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/activity',
        queryParameters: {
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
          if (type != null) 'type': type,
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => BBActivity.fromJson(json),
      );
    });
  }

  /// POST /buddyboss/v1/activity
  Future<BBActivity> createBBActivity({
    required String content,
    required String type,
    int? groupId,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/buddyboss/v1/activity',
        data: {
          'content': content,
          'type': type,
          if (groupId != null) 'primary_item_id': groupId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBActivity.fromJson(data),
      );
    });
  }

  /// GET /buddyboss/v1/activity/{id}
  Future<BBActivity> getBBActivity(int activityId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/activity/$activityId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBActivity.fromJson(data),
      );
    });
  }

  /// DELETE /buddyboss/v1/activity/{id}
  Future<void> deleteBBActivity(int activityId) async {
    return execute(() async {
      await _apiService.delete(
        '/buddyboss/v1/activity/$activityId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// POST /buddyboss/v1/activity/{id}/close-comments
  Future<void> closeBBActivityComments(int activityId) async {
    return execute(() async {
      await _apiService.post(
        '/buddyboss/v1/activity/$activityId/close-comments',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// GET /buddyboss/v1/activity/details
  Future<Map<String, dynamic>> getBBActivityDetails() async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/activity/details',
        backend: ApiBackend.wordpress,
      );
      return response.data;
    });
  }

  // ==================== BuddyBoss Messages ====================

  /// GET /buddyboss/v1/messages
  /// Get all message threads for a user
  Future<List<Map<String, dynamic>>> getBBMessageThreads({
    int? userId,
    int? page,
    int? perPage,
  }) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/messages',
        queryParameters: {
          if (userId != null) 'user_id': userId,
          if (page != null) 'page': page,
          if (perPage != null) 'per_page': perPage,
        },
        backend: ApiBackend.wordpress,
      );
      // Return raw data since thread structure might differ from message
      return (response.data as List).cast<Map<String, dynamic>>();
    });
  }

  /// POST /buddyboss/v1/messages
  /// Create a new message thread
  Future<Map<String, dynamic>> createBBMessageThread({
    required List<int> recipientIds,
    required String message,
    String? subject,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/buddyboss/v1/messages',
        data: {
          'recipients': recipientIds,
          'message': message,
          if (subject != null) 'subject': subject,
        },
        backend: ApiBackend.wordpress,
      );
      return response.data as Map<String, dynamic>;
    });
  }

  /// POST /buddyboss/v1/messages/{id}
  /// Send a message to an existing thread
  Future<BBMessage> createBBMessage({
    required int threadId,
    required String message,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/buddyboss/v1/messages/$threadId',
        data: {
          'message': message,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBMessage.fromJson(data),
      );
    });
  }

  /// GET /buddyboss/v1/messages/{id}
  /// Get messages in a thread
  Future<List<BBMessage>> getBBMessages(int threadId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/buddyboss/v1/messages/$threadId',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => BBMessage.fromJson(json),
      );
    });
  }

  /// PATCH /buddyboss/v1/messages/{id}
  /// Update a message
  Future<BBMessage> updateBBMessage({
    required int messageId,
    String? subject,
    String? message,
  }) async {
    return execute(() async {
      final response = await _apiService.patch(
        '/buddyboss/v1/messages/$messageId',
        data: {
          if (subject != null) 'subject': subject,
          if (message != null) 'message': message,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => BBMessage.fromJson(data),
      );
    });
  }

  /// DELETE /buddyboss/v1/messages/{id}
  /// Delete a message
  Future<void> deleteBBMessage(int messageId) async {
    return execute(() async {
      await _apiService.delete(
        '/buddyboss/v1/messages/$messageId',
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// PATCH /buddyboss/v1/messages/{id}/read
  /// Mark a thread as read
  Future<void> markThreadAsRead(int threadId) async {
    return execute(() async {
      await _apiService.patch(
        '/buddyboss/v1/messages/$threadId/read',
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Course Enrollment ====================

  /// POST /ldlms/v2/sfwd-courses/{id}/enroll
  /// Enroll user in a course
  Future<void> enrollInCourse(int courseId, {int? userId}) async {
    return execute(() async {
      await _apiService.post(
        '/ldlms/v2/sfwd-courses/$courseId/enroll',
        data: {
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// DELETE /ldlms/v2/sfwd-courses/{id}/enroll
  /// Unenroll user from a course
  Future<void> unenrollFromCourse(int courseId, {int? userId}) async {
    return execute(() async {
      await _apiService.delete(
        '/ldlms/v2/sfwd-courses/$courseId/enroll',
        queryParameters: {
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Lessons by Course ====================

  /// GET /ldlms/v2/sfwd-lessons?course={id}
  /// Get lessons for a specific course
  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-lessons',
        queryParameters: {
          'course': courseId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Lesson.fromJson(json),
      );
    });
  }

  // ==================== LearnDash Topics by Lesson ====================

  /// GET /ldlms/v2/sfwd-topic?lesson={id}
  /// Get topics for a specific lesson
  Future<List<Topic>> getTopicsByLesson(int lessonId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-topic',
        queryParameters: {
          'lesson': lessonId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => Topic.fromJson(json),
      );
    });
  }

  // ==================== LearnDash Progress Tracking ====================

  /// GET /ldlms/v2/users/{userId}/course-progress/{courseId}
  /// Get user's progress for a course
  Future<CourseProgress> getCourseProgress(int userId, int courseId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/users/$userId/course-progress/$courseId',
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => CourseProgress.fromJson(data),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-lessons/{id}/complete
  /// Mark lesson as complete
  Future<void> completeLesson(int lessonId, {int? userId}) async {
    return execute(() async {
      await _apiService.post(
        '/ldlms/v2/sfwd-lessons/$lessonId/complete',
        data: {
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// POST /ldlms/v2/sfwd-topic/{id}/complete
  /// Mark topic as complete
  Future<void> completeTopic(int topicId, {int? userId}) async {
    return execute(() async {
      await _apiService.post(
        '/ldlms/v2/sfwd-topic/$topicId/complete',
        data: {
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
    });
  }

  /// POST /ldlms/v2/sfwd-lessons/{id}/progress
  /// Update lesson progress (e.g., video position)
  Future<void> updateLessonProgress(
    int lessonId, {
    int? userId,
    int? progressPercentage,
    int? videoPosition,
  }) async {
    return execute(() async {
      await _apiService.post(
        '/ldlms/v2/sfwd-lessons/$lessonId/progress',
        data: {
          if (userId != null) 'user_id': userId,
          if (progressPercentage != null) 'progress': progressPercentage,
          if (videoPosition != null) 'video_position': videoPosition,
        },
        backend: ApiBackend.wordpress,
      );
    });
  }

  // ==================== LearnDash Quiz Questions & Submission ====================

  /// GET /ldlms/v2/sfwd-quiz/{id}/questions
  /// Get questions for a quiz
  Future<List<QuizQuestion>> getQuizQuestions(int quizId) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-quiz/$quizId/questions',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => QuizQuestion.fromJson(json),
      );
    });
  }

  /// POST /ldlms/v2/sfwd-quiz/{id}/submit
  /// Submit quiz answers
  Future<QuizResult> submitQuiz({
    required int quizId,
    required Map<int, dynamic> answers,
    int? userId,
  }) async {
    return execute(() async {
      final response = await _apiService.post(
        '/ldlms/v2/sfwd-quiz/$quizId/submit',
        data: {
          'answers': answers,
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => QuizResult.fromJson(data),
      );
    });
  }

  /// GET /ldlms/v2/sfwd-quiz/{id}/results
  /// Get quiz results for a user
  Future<QuizResult> getQuizResults(int quizId, {int? userId}) async {
    return execute(() async {
      final response = await _apiService.get(
        '/ldlms/v2/sfwd-quiz/$quizId/results',
        queryParameters: {
          if (userId != null) 'user_id': userId,
        },
        backend: ApiBackend.wordpress,
      );
      return handleResponse(
        response,
        (data) => QuizResult.fromJson(data),
      );
    });
  }

  // ==================== LearnDash Course Categories ====================

  /// GET /wp/v2/ld_course_category
  /// Get course categories
  Future<List<Map<String, dynamic>>> getCourseCategories() async {
    return execute(() async {
      final response = await _apiService.get(
        '/wp/v2/ld_course_category',
        backend: ApiBackend.wordpress,
      );
      return handleListResponse(
        response,
        (json) => json,
      );
    });
  }
}
