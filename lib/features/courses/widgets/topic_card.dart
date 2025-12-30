import 'package:flutter/material.dart';
import '../data/models/quiz_models.dart';

/// Topic Card Widget
/// Displays a topic with completion status
class TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;
  final bool showCheckbox;

  const TopicCard({
    super.key,
    required this.topic,
    this.onTap,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Completion checkbox
              if (showCheckbox)
                Icon(
                  topic.isCompleted
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: topic.isCompleted ? Colors.green : Colors.grey,
                  size: 24,
                ),
              if (showCheckbox) const SizedBox(width: 12),

              // Topic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (topic.videoUrl != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Video',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
