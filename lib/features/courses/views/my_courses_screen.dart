import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/courses_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/course_list_skeleton.dart';
import '../widgets/empty_courses_state.dart';

/// My Courses Screen
/// Shows enrolled courses with progress tracking
class MyCoursesScreen extends ConsumerStatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  ConsumerState<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends ConsumerState<MyCoursesScreen> {
  String _filter = 'all'; // all, in-progress, completed

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(myCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Courses'),
              ),
              const PopupMenuItem(
                value: 'in-progress',
                child: Text('In Progress'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: coursesAsync.when(
        data: (courses) {
          // Apply filter
          var filteredCourses = courses;
          if (_filter == 'in-progress') {
            filteredCourses = courses
                .where((c) => c.progressPercentage > 0 && c.progressPercentage < 100)
                .toList();
          } else if (_filter == 'completed') {
            filteredCourses =
                courses.where((c) => c.progressPercentage == 100).toList();
          }

          if (filteredCourses.isEmpty) {
            return EmptyCoursesState(
              title: _filter == 'all'
                  ? 'No enrolled courses'
                  : _filter == 'completed'
                      ? 'No completed courses yet'
                      : 'No courses in progress',
              message: _filter == 'all'
                  ? 'Enroll in courses to start learning'
                  : 'Keep learning to complete your courses',
              onBrowseCourses: () {
                // Navigate to courses list
                Navigator.of(context).pop();
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Filter chip
              if (_filter != 'all')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Chip(
                    label: Text(
                      _filter == 'in-progress'
                          ? 'In Progress'
                          : 'Completed',
                    ),
                    onDeleted: () {
                      setState(() {
                        _filter = 'all';
                      });
                    },
                  ),
                ),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.school,
                      title: 'Total',
                      value: '${courses.length}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.auto_graph,
                      title: 'In Progress',
                      value: '${courses.where((c) => c.progressPercentage > 0 && c.progressPercentage < 100).length}',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.check_circle,
                      title: 'Completed',
                      value: '${courses.where((c) => c.progressPercentage == 100).length}',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Courses list
              ...filteredCourses.map((course) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseCard(
                    course: course,
                    showProgress: true,
                    onTap: () => _navigateToCourseDetail(course.id),
                  ),
                );
              }).toList(),
            ],
          );
        },
        loading: () => const CourseListSkeleton(),
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
                'Failed to load courses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: () {
                  ref.invalidate(myCoursesProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCourseDetail(int courseId) {
    // TODO: Navigate to course detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Course $courseId selected')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
