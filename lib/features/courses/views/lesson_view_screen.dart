import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/lessons_provider.dart';
import '../data/models/quiz_models.dart';

/// Lesson View Screen
/// Displays lesson content with navigation and completion tracking
class LessonViewScreen extends ConsumerStatefulWidget {
  final int lessonId;
  final List<Lesson>? allLessons;

  const LessonViewScreen({
    super.key,
    required this.lessonId,
    this.allLessons,
  });

  @override
  ConsumerState<LessonViewScreen> createState() => _LessonViewScreenState();
}

class _LessonViewScreenState extends ConsumerState<LessonViewScreen> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonDetailsProvider(widget.lessonId));
    final topicsAsync = ref.watch(lessonTopicsProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        title: lessonAsync.whenOrNull(
          data: (lesson) => Text(lesson.title),
        ),
        actions: [
          lessonAsync.whenOrNull(
            data: (lesson) {
              if (!lesson.isCompleted && !_isCompleted) {
                return TextButton(
                  onPressed: () => _markAsComplete(lesson),
                  child: const Text(
                    'Mark Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return null;
            },
          ) ?? const SizedBox(),
        ],
      ),
      body: lessonAsync.when(
        data: (lesson) {
          _isCompleted = lesson.isCompleted;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion badge
                if (lesson.isCompleted || _isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Completed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Video placeholder (if has video)
                if (lesson.videoUrl != null) ...[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Video Player',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson.videoUrl!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Lesson content
                Html(data: lesson.content),
                const SizedBox(height: 24),

                // Topics section
                topicsAsync.when(
                  data: (topics) {
                    if (topics.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Topics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...topics.map((topic) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                topic.isCompleted
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: topic.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              title: Text(topic.title),
                              onTap: () => _openTopic(topic),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const SizedBox(),
                ),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_hasPreviousLesson())
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        onPressed: _goToPreviousLesson,
                      )
                    else
                      const SizedBox(),
                    if (_hasNextLesson())
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        onPressed: _goToNextLesson,
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ],
            ),
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
                'Failed to load lesson',
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
                  ref.invalidate(lessonDetailsProvider(widget.lessonId));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markAsComplete(Lesson lesson) async {
    try {
      await ref.read(lessonActionsProvider.notifier).completeLesson(lesson.id);

      setState(() {
        _isCompleted = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lesson completed!')),
        );

        // Auto-advance to next lesson after a delay
        if (_hasNextLesson()) {
          await Future.delayed(const Duration(seconds: 1));
          _goToNextLesson();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark as complete')),
        );
      }
    }
  }

  void _openTopic(Topic topic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening topic: ${topic.title}')),
    );
  }

  bool _hasPreviousLesson() {
    if (widget.allLessons == null) return false;
    final currentIndex =
        widget.allLessons!.indexWhere((l) => l.id == widget.lessonId);
    return currentIndex > 0;
  }

  bool _hasNextLesson() {
    if (widget.allLessons == null) return false;
    final currentIndex =
        widget.allLessons!.indexWhere((l) => l.id == widget.lessonId);
    return currentIndex >= 0 && currentIndex < widget.allLessons!.length - 1;
  }

  void _goToPreviousLesson() {
    if (!_hasPreviousLesson()) return;
    final currentIndex =
        widget.allLessons!.indexWhere((l) => l.id == widget.lessonId);
    final previousLesson = widget.allLessons![currentIndex - 1];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LessonViewScreen(
          lessonId: previousLesson.id,
          allLessons: widget.allLessons,
        ),
      ),
    );
  }

  void _goToNextLesson() {
    if (!_hasNextLesson()) return;
    final currentIndex =
        widget.allLessons!.indexWhere((l) => l.id == widget.lessonId);
    final nextLesson = widget.allLessons![currentIndex + 1];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LessonViewScreen(
          lessonId: nextLesson.id,
          allLessons: widget.allLessons,
        ),
      ),
    );
  }
}
