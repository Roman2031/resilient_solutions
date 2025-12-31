import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kindomcall/features/courses/data/models/course.dart';
import '../data/models/quiz_models.dart';

/// Course Card Widget
/// Displays a course with thumbnail, title, progress, and enrollment status
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;
  final bool showProgress;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course thumbnail
            AspectRatio(
              aspectRatio: 16 / 9,
              child: course.featuredMediaUrl != null
                  ? CachedNetworkImage(
                      imageUrl: course.featuredMediaUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.school, size: 48),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.school, size: 48),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course title
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Instructor name
                  if (course.authorName != null)
                    Text(
                      course.authorName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  const SizedBox(height: 8),

                  // Course metadata
                  Row(
                    children: [
                      Icon(Icons.video_library,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.lessonsCount} lessons',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.enrolledUsersCount} enrolled',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  // Progress bar (if enrolled)
                  if (showProgress && course.isEnrolled) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: course.progressPercentage / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.progressPercentage}% complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],

                  // Enrollment badge
                  if (course.isEnrolled) ...[
                    const SizedBox(height: 8),
                    Chip(
                      label: const Text('Enrolled'),
                      backgroundColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
