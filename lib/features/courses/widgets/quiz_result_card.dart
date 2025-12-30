import 'package:flutter/material.dart';
import '../data/models/quiz_models.dart';

/// Quiz Result Card Widget
/// Displays quiz result summary in a card format
class QuizResultCard extends StatelessWidget {
  final QuizResult result;
  final VoidCallback? onRetake;
  final VoidCallback? onReview;

  const QuizResultCard({
    super.key,
    required this.result,
    this.onRetake,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (result.score / result.totalPoints * 100).round();
    final isPassed = result.passed;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Pass/Fail Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPassed
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPassed
                      ? Colors.green.withOpacity(0.5)
                      : Colors.red.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPassed ? Icons.check_circle : Icons.cancel,
                    color: isPassed ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPassed ? 'PASSED' : 'FAILED',
                    style: TextStyle(
                      color: isPassed ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score Circle
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Score',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score Details
            Text(
              '${result.score} / ${result.totalPoints} points',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Attempt number
            Text(
              'Attempt #${result.attemptsCount}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),

            // Date
            Text(
              'Completed: ${_formatDate(result.completedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                if (onReview != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReview,
                      icon: const Icon(Icons.visibility),
                      label: const Text('Review'),
                    ),
                  ),
                if (onReview != null && onRetake != null)
                  const SizedBox(width: 12),
                if (onRetake != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRetake,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
