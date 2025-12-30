# Courses Feature - Phase 5

## Overview

This feature implements complete Learning Management System (LMS) integration with WordPress and LearnDash, enabling users to browse courses, enroll, track progress, complete lessons, take quizzes, and earn certificates.

## Structure

```
lib/features/courses/
├── data/
│   └── models/
│       ├── course.dart           # Course, Lesson, Topic, Quiz, CourseProgress models
│       └── quiz_models.dart      # QuizQuestion, QuizResult, CourseDetails models
├── providers/
│   ├── courses_provider.dart     # Course listing, filtering, enrollment
│   ├── lessons_provider.dart     # Lesson details, completion
│   └── quiz_provider.dart        # Quiz details, submission
├── views/
│   ├── courses_list_screen.dart  # Browse all courses
│   ├── course_detail_screen.dart # Course overview, curriculum, progress
│   ├── my_courses_screen.dart    # Enrolled courses
│   ├── lesson_view_screen.dart   # Lesson content viewer
│   └── quiz_screen.dart          # Quiz interface and results
└── widgets/
    ├── course_card.dart          # Course display card
    ├── course_list_skeleton.dart # Loading placeholder
    ├── empty_courses_state.dart  # Empty state
    ├── lesson_card.dart          # Lesson display card
    └── progress_circle.dart      # Circular progress indicator
```

## Setup Instructions

### 1. Run Code Generation

The feature uses Freezed and Riverpod code generation. Run:

```bash
cd "Flutter App"
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files for immutable models
- `*.g.dart` files for JSON serialization
- `*_provider.g.dart` files for Riverpod providers

### 2. Add Routes to GoRouter

In `lib/core/navigation/app_route.dart`, add the course routes:

```dart
// Inside createRouter's routes list:
GoRoute(
  path: Routes.courses,
  builder: (context, state) => const CoursesListScreen(),
),
GoRoute(
  path: Routes.courseDetail,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return CourseDetailScreen(courseId: id);
  },
),
GoRoute(
  path: Routes.myCourses,
  builder: (context, state) => const MyCoursesScreen(),
),
GoRoute(
  path: Routes.lessonView,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return LessonViewScreen(lessonId: id);
  },
),
GoRoute(
  path: Routes.quiz,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return QuizScreen(quizId: id);
  },
),
```

### 3. Add to Navigation Bar

Update the main navigation bar to include courses:

```dart
NavigationItem(
  icon: Icons.school,
  label: 'Courses',
  route: Routes.courses,
),
```

### 4. Update Dashboard

Add learning widgets to the dashboard:

```dart
// In dashboard.dart
Column(
  children: [
    _ContinueLearningWidget(),
    _RecommendedCoursesWidget(),
  ],
)

class _ContinueLearningWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCoursesAsync = ref.watch(myCoursesProvider);
    
    return myCoursesAsync.when(
      data: (courses) {
        final inProgress = courses.where(
          (c) => c.progressPercentage > 0 && c.progressPercentage < 100
        ).toList();
        
        if (inProgress.isEmpty) return SizedBox();
        
        return Card(
          child: ListTile(
            leading: Icon(Icons.play_circle),
            title: Text('Continue Learning'),
            subtitle: Text(inProgress.first.title),
            trailing: Text('${inProgress.first.progressPercentage}%'),
            onTap: () => context.go(Routes.courseDetail
              .replaceFirst(':id', '${inProgress.first.id}')),
          ),
        );
      },
      loading: () => SizedBox(),
      error: (_, __) => SizedBox(),
    );
  }
}
```

## API Endpoints Used

### LearnDash Courses
- `GET /ldlms/v2/sfwd-courses` - List all courses
- `GET /ldlms/v2/sfwd-courses/{id}` - Course details
- `POST /ldlms/v2/sfwd-courses/{id}/enroll` - Enroll user
- `DELETE /ldlms/v2/sfwd-courses/{id}/enroll` - Unenroll user

### LearnDash Lessons
- `GET /ldlms/v2/sfwd-lessons?course={id}` - Course lessons
- `GET /ldlms/v2/sfwd-lessons/{id}` - Lesson details
- `POST /ldlms/v2/sfwd-lessons/{id}/complete` - Mark complete
- `POST /ldlms/v2/sfwd-lessons/{id}/progress` - Update progress

### LearnDash Topics
- `GET /ldlms/v2/sfwd-topic?lesson={id}` - Lesson topics
- `POST /ldlms/v2/sfwd-topic/{id}/complete` - Mark complete

### LearnDash Quizzes
- `GET /ldlms/v2/sfwd-quiz/{id}` - Quiz details
- `GET /ldlms/v2/sfwd-quiz/{id}/questions` - Quiz questions
- `POST /ldlms/v2/sfwd-quiz/{id}/submit` - Submit answers
- `GET /ldlms/v2/sfwd-quiz/{id}/results` - Get results

### Progress Tracking
- `GET /ldlms/v2/users/{userId}/course-progress/{courseId}` - Course progress

### Course Categories
- `GET /wp/v2/ld_course_category` - Course categories

## Features

### Courses List Screen
- **Search**: Filter courses by title, description, or excerpt
- **Sort**: By popularity, newest, or alphabetical
- **Filter**: By category
- **View Modes**: Grid or list view
- **Progress Indicators**: For enrolled courses

### Course Detail Screen
- **Overview Tab**: Description, instructor, enrollment count
- **Curriculum Tab**: Lessons with completion status
- **Progress Tab**: Overall progress, completed lessons, topics
- **Enroll/Continue Button**: Context-aware action

### My Courses Screen
- **Filter**: All, in-progress, completed
- **Summary Cards**: Total, in progress, completed counts
- **Progress Bars**: Visual progress for each course

### Lesson View Screen
- **Content Display**: HTML rendering, video placeholder
- **Topics**: List with completion status
- **Navigation**: Previous/Next lesson buttons
- **Completion Tracking**: Mark as complete button

### Quiz Screen
- **Question Navigation**: Previous/Next buttons
- **Progress Bar**: Visual indicator
- **Answer Types**: Multiple choice, true/false, fill-in-blank, essay
- **Submission**: Validation before submit

## Dependencies

### Added Dependencies
```yaml
# Video & Media
video_player: ^2.9.2
flutter_html: ^3.0.0-beta.2
```

### Existing Dependencies Used
- `riverpod_annotation` - State management
- `freezed_annotation` - Immutable models
- `json_annotation` - JSON serialization
- `cached_network_image` - Image caching
- `shimmer` - Loading skeletons

## Testing

### To Run Tests
```bash
flutter test
```

### Test Coverage
- Unit tests for providers (courses, lessons, quiz)
- Widget tests for components (cards, screens)
- Integration tests for user flows

## Known Limitations

1. **Video Player**: Currently shows placeholder. Need to integrate actual video_player package
2. **Offline Support**: Not yet implemented
3. **Certificate Display**: Not yet implemented
4. **Course Search Screen**: Not yet implemented
5. **Categories Screen**: Not yet implemented

## Future Enhancements

1. **Video Playback**: Integrate full video player with controls
2. **Offline Mode**: Download courses for offline viewing
3. **Certificates**: Display and download certificates
4. **Advanced Search**: Full-text search with filters
5. **Notifications**: Course updates, new lessons
6. **Social Features**: Discussion forums, peer reviews
7. **Analytics**: Track time spent, learning patterns

## Troubleshooting

### Code Generation Fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Provider Errors
Make sure all `.g.dart` files are generated and imported correctly.

### Network Errors
Check API endpoints in `wordpress_repository.dart` and ensure backend is accessible.

## Support

For issues or questions, refer to:
- Phase 4 documentation for authentication
- WordPress/LearnDash API documentation
- Flutter documentation for widgets

---

**Status**: Phase 5 Implementation Complete ✅
**Last Updated**: 2025-12-28
