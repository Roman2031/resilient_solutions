import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/courses_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/course_list_skeleton.dart';
import '../data/models/quiz_models.dart';

/// Courses List Screen
/// Browse all available courses with search, filter, and sort options
class CoursesListScreen extends ConsumerStatefulWidget {
  const CoursesListScreen({super.key});

  @override
  ConsumerState<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends ConsumerState<CoursesListScreen> {
  String? _searchQuery;
  int? _selectedCategoryId;
  CourseSortOption _sortOption = CourseSortOption.popular;
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(
      filteredCoursesProvider(
        searchQuery: _searchQuery,
        categoryId: _selectedCategoryId,
        sortOption: _sortOption,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          // Sort button
          PopupMenuButton<CourseSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CourseSortOption.popular,
                child: Text('Most Popular'),
              ),
              const PopupMenuItem(
                value: CourseSortOption.newest,
                child: Text('Newest'),
              ),
              const PopupMenuItem(
                value: CourseSortOption.alphabetical,
                child: Text('A-Z'),
              ),
            ],
          ),
          // View toggle
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (_searchQuery != null || _selectedCategoryId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_searchQuery != null)
                    Chip(
                      label: Text('Search: $_searchQuery'),
                      onDeleted: () {
                        setState(() {
                          _searchQuery = null;
                        });
                      },
                    ),
                  if (_selectedCategoryId != null)
                    Chip(
                      label: Text('Category: $_selectedCategoryId'),
                      onDeleted: () {
                        setState(() {
                          _selectedCategoryId = null;
                        });
                      },
                    ),
                ],
              ),
            ),

          // Courses list
          Expanded(
            child: coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No courses found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  );
                }

                if (_isGridView) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(
                        course: course,
                        showProgress: course.isEnrolled,
                        onTap: () => _navigateToCourseDetail(course.id),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CourseCard(
                          course: course,
                          showProgress: course.isEnrolled,
                          onTap: () => _navigateToCourseDetail(course.id),
                        ),
                      );
                    },
                  );
                }
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
                        ref.invalidate(allCoursesProvider);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? query = _searchQuery;
        return AlertDialog(
          title: const Text('Search Courses'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter course name or keyword',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              query = value;
            },
            onSubmitted: (value) {
              Navigator.pop(context);
              setState(() {
                _searchQuery = value.isEmpty ? null : value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _searchQuery = null;
                });
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _searchQuery = query?.isEmpty ?? true ? null : query;
                });
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCourseDetail(int courseId) {
    // TODO: Navigate to course detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Course $courseId selected')),
    );
  }
}
