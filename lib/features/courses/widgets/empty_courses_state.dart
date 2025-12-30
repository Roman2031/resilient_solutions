import 'package:flutter/material.dart';

/// Empty Courses State Widget
/// Displayed when no courses are available
class EmptyCoursesState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onBrowseCourses;

  const EmptyCoursesState({
    super.key,
    this.title = 'No courses yet',
    this.message = 'Explore our catalog to find courses that interest you',
    this.onBrowseCourses,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 100,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // CTA Button
            if (onBrowseCourses != null)
              ElevatedButton.icon(
                onPressed: onBrowseCourses,
                icon: const Icon(Icons.explore),
                label: const Text('Browse Courses'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
