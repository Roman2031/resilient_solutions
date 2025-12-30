import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../../callcircle/providers/circles_provider.dart';
import '../../callcirclemanager/providers/circle_management_provider.dart';
import '../../courses/data/models/course.dart';
import '../../wordpress/data/repositories/wordpress_repository.dart';

part 'circle_creation_provider.g.dart';

/// Provider for available courses from LearnDash
@riverpod
Future<List<Course>> availableCourses(AvailableCoursesRef ref) async {
  final repository = ref.watch(wordPressRepositoryProvider);
  
  try {
    return await repository.getCourses();
  } catch (e) {
    throw Exception('Failed to load courses: ${e.toString()}');
  }
}

/// Provider for circle creation with course integration
@riverpod
class CircleCreation extends _$CircleCreation {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Create a circle with course and initial members
  Future<Circle> createCircleWithCourse({
    required String name,
    required String description,
    int? courseId,
    int? maxMembers,
    DateTime? startDate,
    DateTime? endDate,
    String? meetingSchedule,
    List<int>? initialMemberIds,
  }) async {
    state = const AsyncValue.loading();
    
    Circle? createdCircle;
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      // Create circle
      createdCircle = await repository.createCircle(
        name: name,
        description: description,
        courseId: courseId,
        maxMembers: maxMembers,
        startDate: startDate,
        endDate: endDate,
        meetingSchedule: meetingSchedule,
      );
      
      // Add initial members if provided
      if (initialMemberIds != null && initialMemberIds.isNotEmpty) {
        for (final userId in initialMemberIds) {
          try {
            await repository.addCircleMember(
              circleId: createdCircle!.id,
              userId: userId,
              role: 'learner',
            );
          } catch (e) {
            // Continue if adding a member fails
            continue;
          }
        }
      }
      
      // Invalidate to refresh lists
      ref.invalidate(myCirclesProvider);
      ref.invalidate(managedCirclesProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to create circle: ${state.error}');
    }
    
    return createdCircle!;
  }
}
