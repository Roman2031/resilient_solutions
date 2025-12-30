import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kindomcall/features/courses/data/models/course.dart';
import 'package:kindomcall/features/courses/data/models/quiz_models.dart';
import '../../wordpress/data/repositories/wordpress_repository.dart';
import '../../../core/auth/auth_repository.dart';

part 'courses_provider.g.dart';

/// Provider for all courses
@riverpod
Future<List<Course>> allCourses(AllCoursesRef ref) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  return await repository.getCourses();
}

/// Provider for filtered courses
@riverpod
Future<List<Course>> filteredCourses(
  FilteredCoursesRef ref, {
  String? searchQuery,
  int? categoryId,
  CourseSortOption? sortOption,
}) async {
  final courses = await ref.watch(allCoursesProvider.future);

  var filtered = courses;

  // Search filter
  if (searchQuery != null && searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filtered = filtered
        .where((course) =>
            course.title.toLowerCase().contains(query) ||
            course.content.toLowerCase().contains(query) ||
            course.excerpt.toLowerCase().contains(query))
        .toList();
  }

  // Category filter
  if (categoryId != null) {
    filtered =
        filtered.where((c) => c.categories.contains(categoryId)).toList();
  }

  // Sort
  switch (sortOption) {
    case CourseSortOption.popular:
      filtered
          .sort((a, b) => b.enrolledUsersCount.compareTo(a.enrolledUsersCount));
      break;
    case CourseSortOption.newest:
      filtered.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      break;
    case CourseSortOption.alphabetical:
      filtered.sort((a, b) => a.title.compareTo(b.title));
      break;
    case CourseSortOption.progress:
      filtered
          .sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
      break;
    default:
      break;
  }

  return filtered;
}

/// Provider for my enrolled courses
@riverpod
Future<List<Course>> myCourses(MyCoursesRef ref) async {
  final courses = await ref.watch(allCoursesProvider.future);

  // Filter only enrolled courses
  return courses.where((c) => c.isEnrolled).toList();
}

/// Provider for course details
@riverpod
Future<CourseDetails> courseDetails(
  CourseDetailsRef ref,
  int courseId,
) async {
  final repository = ref.watch(wordPressRepositoryProvider);

  // Fetch course
  final course = await repository.getCourse(courseId);

  // Fetch lessons
  final lessons = await repository.getLessonsByCourse(courseId);

  // Fetch topics for each lesson
  Map<int, List<Topic>> lessonTopics = {};
  for (final lesson in lessons) {
    try {
      final topics = await repository.getTopicsByLesson(lesson.id);
      lessonTopics[lesson.id] = topics;
    } catch (e) {
      // If topics fail, continue with empty list
      lessonTopics[lesson.id] = [];
    }
  }

  // Fetch user progress if enrolled
  CourseProgress? progress;
  if (course.isEnrolled) {
    final authState = ref.watch(authRepositoryProvider).value;
    if (authState is AuthenticatedState) {
      final userId = authState.userInfo['sub'];
      if (userId != null) {
        try {
          progress = await repository.getCourseProgress(
            int.parse(userId.toString()),
            courseId,
          );
        } catch (e) {
          // Progress not available, continue without it
        }
      }
    }
  }

  return CourseDetails(
    course: course,
    lessons: lessons,
    lessonTopics: lessonTopics,
    progress: progress,
  );
}

/// Provider for course categories
@riverpod
Future<List<Map<String, dynamic>>> courseCategories(
    CourseCategoriesRef ref) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  return await repository.getCourseCategories();
}

/// Notifier for course actions
@riverpod
class CourseActions extends _$CourseActions {
  @override
  FutureOr<void> build() {
    return null;
  }

  /// Enroll in a course
  Future<void> enrollInCourse(int courseId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      await repository.enrollInCourse(courseId);

      // Invalidate to refresh
      ref.invalidate(allCoursesProvider);
      ref.invalidate(myCoursesProvider);
      ref.invalidate(courseDetailsProvider(courseId));
    });
  }

  /// Unenroll from a course
  Future<void> unenrollFromCourse(int courseId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(wordPressRepositoryProvider);
      await repository.unenrollFromCourse(courseId);

      // Invalidate to refresh
      ref.invalidate(allCoursesProvider);
      ref.invalidate(myCoursesProvider);
      ref.invalidate(courseDetailsProvider(courseId));
    });
  }
}
