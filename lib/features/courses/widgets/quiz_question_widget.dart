import 'package:flutter/material.dart';
import '../data/models/quiz_models.dart';

/// Quiz Question Widget
/// Displays a quiz question with answer options
class QuizQuestionWidget extends StatelessWidget {
  final QuizQuestion question;
  final dynamic selectedAnswer;
  final Function(dynamic)? onAnswerSelected;
  final bool showCorrectAnswer;

  const QuizQuestionWidget({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.onAnswerSelected,
    this.showCorrectAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question text
        Text(
          question.question,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Points
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${question.points} ${question.points == 1 ? 'point' : 'points'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(height: 24),

        // Answer options based on type
        _buildAnswerOptions(context),

        // Explanation (if showing correct answer)
        if (showCorrectAnswer && question.explanation != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.explanation!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnswerOptions(BuildContext context) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceOptions(context);
      case QuestionType.trueFalse:
        return _buildTrueFalseOptions(context);
      case QuestionType.fillInBlank:
        return _buildFillInBlankOption(context);
      case QuestionType.essay:
        return _buildEssayOption(context);
    }
  }

  Widget _buildMultipleChoiceOptions(BuildContext context) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedAnswer == index;
        final isCorrect = showCorrectAnswer && question.correctAnswer == index;
        final isWrong = showCorrectAnswer && isSelected && !isCorrect;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isCorrect
              ? Colors.green.withOpacity(0.1)
              : isWrong
                  ? Colors.red.withOpacity(0.1)
                  : null,
          child: RadioListTile<int>(
            value: index,
            groupValue: selectedAnswer,
            onChanged: onAnswerSelected != null && !showCorrectAnswer
                ? (value) => onAnswerSelected!(value)
                : null,
            title: Text(option),
            selected: isSelected,
            secondary: showCorrectAnswer
                ? Icon(
                    isCorrect ? Icons.check_circle : isWrong ? Icons.cancel : null,
                    color: isCorrect ? Colors.green : isWrong ? Colors.red : null,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseOptions(BuildContext context) {
    return Column(
      children: [
        _buildTrueFalseOption(context, true, 'True'),
        const SizedBox(height: 12),
        _buildTrueFalseOption(context, false, 'False'),
      ],
    );
  }

  Widget _buildTrueFalseOption(BuildContext context, bool value, String label) {
    final isSelected = selectedAnswer == value;
    final isCorrect = showCorrectAnswer && question.correctAnswer == value;
    final isWrong = showCorrectAnswer && isSelected && !isCorrect;

    return Card(
      color: isCorrect
          ? Colors.green.withOpacity(0.1)
          : isWrong
              ? Colors.red.withOpacity(0.1)
              : null,
      child: RadioListTile<bool>(
        value: value,
        groupValue: selectedAnswer,
        onChanged: onAnswerSelected != null && !showCorrectAnswer
            ? (val) => onAnswerSelected!(val)
            : null,
        title: Text(label),
        selected: isSelected,
        secondary: showCorrectAnswer
            ? Icon(
                isCorrect ? Icons.check_circle : isWrong ? Icons.cancel : null,
                color: isCorrect ? Colors.green : isWrong ? Colors.red : null,
              )
            : null,
      ),
    );
  }

  Widget _buildFillInBlankOption(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Type your answer here',
        enabled: !showCorrectAnswer,
        suffixIcon: showCorrectAnswer
            ? Icon(
                selectedAnswer == question.correctAnswer
                    ? Icons.check_circle
                    : Icons.cancel,
                color: selectedAnswer == question.correctAnswer
                    ? Colors.green
                    : Colors.red,
              )
            : null,
      ),
      onChanged: onAnswerSelected,
      controller: TextEditingController(
        text: selectedAnswer?.toString() ?? '',
      ),
    );
  }

  Widget _buildEssayOption(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Type your essay here',
        enabled: !showCorrectAnswer,
      ),
      maxLines: 8,
      onChanged: onAnswerSelected,
      controller: TextEditingController(
        text: selectedAnswer?.toString() ?? '',
      ),
    );
  }
}
