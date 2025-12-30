import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kindomcall/features/courses/data/models/course.dart'; // For Quiz
import 'package:kindomcall/features/courses/data/models/quiz_models.dart'; // For QuizQuestion, QuizResult
import '../../wordpress/data/repositories/wordpress_repository.dart';
import 'courses_provider.dart';

part 'quiz_provider.g.dart';

/// Provider for quiz details with questions
@riverpod
Future<Quiz> quizDetails(QuizDetailsRef ref, int quizId) async {
  final repository = ref.watch(wordPressRepositoryProvider);

  // Fetch quiz
  final quiz = await repository.getQuiz(quizId);

  // Fetch questions
  try {
    final questions = await repository.getQuizQuestions(quizId);
    // Note: We can't modify the quiz object directly since it's immutable
    // The UI will need to fetch questions separately if needed
  } catch (e) {
    // Questions not available
  }

  return quiz;
}

/// Provider for quiz questions
@riverpod
Future<List<QuizQuestion>> quizQuestions(
  QuizQuestionsRef ref,
  int quizId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  return await repository.getQuizQuestions(quizId);
}

/// Provider for quiz results
@riverpod
Future<QuizResult?> quizResults(
  QuizResultsRef ref,
  int quizId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  try {
    return await repository.getQuizResults(quizId);
  } catch (e) {
    // No results available yet
    return null;
  }
}

/// Notifier for quiz actions
@riverpod
class QuizActions extends _$QuizActions {
  @override
  FutureOr<QuizResult?> build() {
    return null;
  }

  /// Submit quiz answers
  Future<QuizResult> submitQuiz({
    required int quizId,
    required Map<int, dynamic> answers,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);

      final result = await repository.submitQuiz(
        quizId: quizId,
        answers: answers,
      );

      // Invalidate to refresh course progress
      ref.invalidate(quizResultsProvider(quizId));

      state = AsyncValue.data(result);
      return result;
    }).then((asyncValue) {
      return asyncValue.when(
        data: (data) => data!,
        loading: () => throw Exception('Loading'),
        error: (error, stack) => throw error,
      );
    });
  }
}
