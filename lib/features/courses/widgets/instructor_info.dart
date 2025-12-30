import 'package:flutter/material.dart';

/// Instructor Info Widget
/// Displays instructor information in a course
class InstructorInfo extends StatelessWidget {
  final int instructorId;
  final String instructorName;
  final String? instructorBio;
  final String? avatarUrl;
  final int? courseCount;

  const InstructorInfo({
    super.key,
    required this.instructorId,
    required this.instructorName,
    this.instructorBio,
    this.avatarUrl,
    this.courseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructor',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: avatarUrl == null
                      ? Text(
                          instructorName[0].toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instructorName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (courseCount != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '$courseCount ${courseCount == 1 ? 'course' : 'courses'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ],
                  ),
                ),

                // View profile button
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // TODO: Navigate to instructor profile
                  },
                ),
              ],
            ),

            // Bio
            if (instructorBio != null) ...[
              const SizedBox(height: 12),
              Text(
                instructorBio!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
