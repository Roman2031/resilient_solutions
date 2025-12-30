import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

/// LearnDash Course Model
/// Represents a course from WordPress LearnDash LMS
@freezed
class Course with _$Course {
  const factory Course({
    required int id,
    required String title,
    required String content,
    required String excerpt,
    required String slug,
    required String status,
    @JsonKey(name: 'featured_media') int? featuredMedia,
    @JsonKey(name: 'featured_media_url') String? featuredMediaUrl,
    required List<int> categories,
    @JsonKey(name: 'author_id') required int authorId,
    @JsonKey(name: 'author_name') String? authorName,
    @JsonKey(name: 'date_created') required DateTime dateCreated,
    @JsonKey(name: 'date_modified') required DateTime dateModified,
    @JsonKey(name: 'course_price') String? coursePrice,
    @JsonKey(name: 'course_price_type') String? coursePriceType,
    @JsonKey(name: 'enrolled_users_count') @Default(0) int enrolledUsersCount,
    @JsonKey(name: 'lessons_count') @Default(0) int lessonsCount,
    @JsonKey(name: 'topics_count') @Default(0) int topicsCount,
    @JsonKey(name: 'is_enrolled') @Default(false) bool isEnrolled,
    @JsonKey(name: 'progress_percentage') @Default(0) int progressPercentage,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) =>
      _$CourseFromJson(json);
}

/// Lesson Model
@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required int id,
    required String title,
    required String content,
    required String excerpt,
    @JsonKey(name: 'course_id') required int courseId,
    @JsonKey(name: 'lesson_order') int? lessonOrder,
    @JsonKey(name: 'featured_media_url') String? featuredMediaUrl,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'materials') String? materials,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'topics_count') @Default(0) int topicsCount,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);
}

/// Topic Model
@freezed
class Topic with _$Topic {
  const factory Topic({
    required int id,
    required String title,
    required String content,
    @JsonKey(name: 'lesson_id') required int lessonId,
    @JsonKey(name: 'course_id') required int courseId,
    @JsonKey(name: 'topic_order') int? topicOrder,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'materials') String? materials,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) =>
      _$TopicFromJson(json);
}

/// Quiz Model
@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required int id,
    required String title,
    required String content,
    @JsonKey(name: 'course_id') int? courseId,
    @JsonKey(name: 'lesson_id') int? lessonId,
    @JsonKey(name: 'passing_percentage') int? passingPercentage,
    @JsonKey(name: 'questions_count') @Default(0) int questionsCount,
    @JsonKey(name: 'time_limit') int? timeLimit,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'last_score') double? lastScore,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) =>
      _$QuizFromJson(json);
}

/// Course Progress Model
@freezed
class CourseProgress with _$CourseProgress {
  const factory CourseProgress({
    @JsonKey(name: 'course_id') required int courseId,
    @JsonKey(name: 'total_lessons') required int totalLessons,
    @JsonKey(name: 'completed_lessons') required int completedLessons,
    @JsonKey(name: 'total_topics') required int totalTopics,
    @JsonKey(name: 'completed_topics') required int completedTopics,
    @JsonKey(name: 'progress_percentage') required double progressPercentage,
    @JsonKey(name: 'last_activity') DateTime? lastActivity,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'completion_date') DateTime? completionDate,
  }) = _CourseProgress;

  factory CourseProgress.fromJson(Map<String, dynamic> json) =>
      _$CourseProgressFromJson(json);
}
