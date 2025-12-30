import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/courses_provider.dart';
import '../widgets/lesson_card.dart';
import '../widgets/progress_circle.dart';

/// Course Detail Screen
/// Shows course overview, curriculum, and progress with tabs
class CourseDetailScreen extends ConsumerStatefulWidget {
  final int courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  ConsumerState<CourseDetailScreen> createState() =>
      _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseDetailsAsync =
        ref.watch(courseDetailsProvider(widget.courseId));

    return Scaffold(
      body: courseDetailsAsync.when(
        data: (courseDetails) {
          final course = courseDetails.course;
          final isEnrolled = course.isEnrolled;

          return CustomScrollView(
            slivers: [
              // App Bar with course image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  background: course.featuredMediaUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              course.featuredMediaUrl!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          color: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.school,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              // Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Curriculum'),
                      if (isEnrolled) Tab(text: 'Progress'),
                    ],
                  ),
                ),
              ),

              // Tab Bar View
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _OverviewTab(courseDetails: courseDetails),
                    _CurriculumTab(courseDetails: courseDetails),
                    if (isEnrolled)
                      _ProgressTab(courseDetails: courseDetails),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
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
                  'Failed to load course',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  onPressed: () {
                    ref.invalidate(courseDetailsProvider(widget.courseId));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: courseDetailsAsync.whenOrNull(
        data: (courseDetails) {
          final course = courseDetails.course;
          return Container(
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
            child: course.isEnrolled
                ? ElevatedButton(
                    onPressed: () => _continueLearning(courseDetails),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continue Learning'),
                  )
                : ElevatedButton(
                    onPressed: () => _enrollInCourse(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Enroll Now'),
                  ),
          );
        },
      ),
    );
  }

  void _enrollInCourse() async {
    final courseActions = ref.read(courseActionsProvider.notifier);
    await courseActions.enrollInCourse(widget.courseId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully enrolled!')),
      );
    }
  }

  void _continueLearning(courseDetails) {
    // Find first incomplete lesson
    final firstIncompleteLesson = courseDetails.lessons
        .firstWhere((l) => !l.isCompleted, orElse: () => courseDetails.lessons.first);

    // Navigate to lesson
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening lesson: ${firstIncompleteLesson.title}')),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final courseDetails;

  const _OverviewTab({required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    final course = courseDetails.course;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course description
          Text(
            'About This Course',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Html(data: course.content),
          const SizedBox(height: 24),

          // Course metadata
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.video_library,
                    label: 'Lessons',
                    value: '${course.lessonsCount}',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.topic,
                    label: 'Topics',
                    value: '${course.topicsCount}',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.people,
                    label: 'Enrolled',
                    value: '${course.enrolledUsersCount}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Instructor info
          if (course.authorName != null) ...[
            Text(
              'Instructor',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(course.authorName![0]),
                ),
                title: Text(course.authorName!),
                subtitle: const Text('Course Instructor'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CurriculumTab extends StatelessWidget {
  final courseDetails;

  const _CurriculumTab({required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    final lessons = courseDetails.lessons;

    if (lessons.isEmpty) {
      return const Center(
        child: Text('No lessons available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return LessonCard(
          lesson: lesson,
          lessonNumber: index + 1,
          isLocked: !courseDetails.course.isEnrolled && index > 0,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening: ${lesson.title}')),
            );
          },
        );
      },
    );
  }
}

class _ProgressTab extends StatelessWidget {
  final courseDetails;

  const _ProgressTab({required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    final progress = courseDetails.progress;
    final course = courseDetails.course;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress circle
          ProgressCircle(
            progress: course.progressPercentage / 100,
            size: 150,
          ),
          const SizedBox(height: 32),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  label: 'Completed',
                  value: progress != null
                      ? '${progress.completedLessons}/${progress.totalLessons}'
                      : '0/0',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.topic,
                  label: 'Topics',
                  value: progress != null
                      ? '${progress.completedTopics}/${progress.totalTopics}'
                      : '0/0',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
