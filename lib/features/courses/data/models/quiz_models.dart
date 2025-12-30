import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kindomcall/features/courses/data/models/course.dart';

part 'quiz_models.freezed.dart';
part 'quiz_models.g.dart';

/// Quiz Question Model
@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required int id,
    required String question,
    required QuestionType type,
    @Default([]) List<String> options,
    @JsonKey(name: 'correct_answer') dynamic correctAnswer,
    String? explanation,
    @Default(1) int points,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

/// Question Type Enum
enum QuestionType {
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('true_false')
  trueFalse,
  @JsonValue('fill_blank')
  fillInBlank,
  @JsonValue('essay')
  essay,
}

/// Quiz Result Model
@freezed
class QuizResult with _$QuizResult {
  const factory QuizResult({
    @JsonKey(name: 'quiz_id') required int quizId,
    required int score,
    @JsonKey(name: 'total_points') required int totalPoints,
    required bool passed,
    @Default({}) Map<int, dynamic> answers,
    @Default({}) Map<int, bool> correctness,
    @JsonKey(name: 'completed_at') required DateTime completedAt,
    @JsonKey(name: 'attempts_count') @Default(1) int attemptsCount,
  }) = _QuizResult;

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
}

/// Course Details Model (combines course, lessons, topics)
@freezed
class CourseDetails with _$CourseDetails {
  const factory CourseDetails({
    required Course course,
    @Default([]) List<Lesson> lessons,
    @Default({}) Map<int, List<Topic>> lessonTopics,
    CourseProgress? progress,
  }) = _CourseDetails;

  factory CourseDetails.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsFromJson(json);
}

/// Course Status Enum
enum CourseStatus {
  @JsonValue('not_started')
  notStarted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

/// Course Sort Option Enum
enum CourseSortOption {
  popular,
  newest,
  alphabetical,
  progress,
}

/// Lesson Type Enum
enum LessonType {
  video,
  text,
  pdf,
  audio,
  quiz,
}

// Re-export Course models from course.dart

