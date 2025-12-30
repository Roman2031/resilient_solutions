import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../data/models/quiz_models.dart';

/// Quiz Screen
/// Interactive quiz interface with question navigation and submission
class QuizScreen extends ConsumerStatefulWidget {
  final int quizId;

  const QuizScreen({
    super.key,
    required this.quizId,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, dynamic> _answers = {};
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizDetailsProvider(widget.quizId));
    final questionsAsync = ref.watch(quizQuestionsProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        title: quizAsync.whenOrNull(
          data: (quiz) => Text(quiz.title),
        ),
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(
              child: Text('No questions available'),
            );
          }

          final currentQuestion = questions[_currentQuestionIndex];

          return Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questions.length,
                minHeight: 4,
              ),

              // Question counter
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${currentQuestion.points} pts',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),

              // Question content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question text
                      Text(
                        currentQuestion.question,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Answer options
                      _buildAnswerOptions(currentQuestion),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentQuestionIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          },
                          child: const Text('Previous'),
                        ),
                      ),
                    if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentQuestionIndex < questions.length - 1
                            ? () {
                                setState(() {
                                  _currentQuestionIndex++;
                                });
                              }
                            : () => _submitQuiz(questions),
                        child: Text(
                          _currentQuestionIndex < questions.length - 1
                              ? 'Next'
                              : 'Submit Quiz',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load quiz',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(QuizQuestion question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoice(question);
      case QuestionType.trueFalse:
        return _buildTrueFalse(question);
      case QuestionType.fillInBlank:
        return _buildFillInBlank(question);
      case QuestionType.essay:
        return _buildEssay(question);
    }
  }

  Widget _buildMultipleChoice(QuizQuestion question) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _answers[question.id] == index;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: RadioListTile<int>(
            value: index,
            groupValue: _answers[question.id],
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
            title: Text(option),
            selected: isSelected,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalse(QuizQuestion question) {
    return Column(
      children: [
        Card(
          child: RadioListTile<bool>(
            value: true,
            groupValue: _answers[question.id],
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
            title: const Text('True'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: RadioListTile<bool>(
            value: false,
            groupValue: _answers[question.id],
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
            title: const Text('False'),
          ),
        ),
      ],
    );
  }

  Widget _buildFillInBlank(QuizQuestion question) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your answer',
      ),
      onChanged: (value) {
        _answers[question.id] = value;
      },
      controller: TextEditingController(
        text: _answers[question.id]?.toString() ?? '',
      ),
    );
  }

  Widget _buildEssay(QuizQuestion question) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Type your essay here',
      ),
      maxLines: 10,
      onChanged: (value) {
        _answers[question.id] = value;
      },
      controller: TextEditingController(
        text: _answers[question.id]?.toString() ?? '',
      ),
    );
  }

  Future<void> _submitQuiz(List<QuizQuestion> questions) async {
    // Check if all questions are answered
    final unansweredCount = questions.length - _answers.length;
    if (unansweredCount > 0) {
      final shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Quiz'),
          content: Text(
            'You have $unansweredCount unanswered question(s). Do you want to submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (shouldSubmit != true) return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final quizActions = ref.read(quizActionsProvider.notifier);
      final result = await quizActions.submitQuiz(
        quizId: widget.quizId,
        answers: _answers,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit quiz: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

/// Quiz Result Screen
/// Displays quiz results with score and pass/fail status
class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (result.score / result.totalPoints * 100).round();
    final isPassed = result.passed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pass/Fail icon
              Icon(
                isPassed ? Icons.check_circle : Icons.cancel,
                size: 100,
                color: isPassed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),

              // Status text
              Text(
                isPassed ? 'Congratulations!' : 'Not Passed',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
              ),
              const SizedBox(height: 12),

              // Score
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Points
              Text(
                '${result.score} / ${result.totalPoints} points',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 48),

              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
