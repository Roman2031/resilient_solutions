import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../../callcircle/providers/circles_provider.dart';

part 'circle_management_provider.g.dart';

/// Provider for circles managed by the current user (facilitator)
@riverpod
Future<List<Circle>> managedCircles(Ref ref) async {
  final repository = ref.watch(callServiceRepositoryProvider);
  final authState = ref.watch(authRepositoryProvider);
  
  return await authState.when(
    data: (state) => state.when(
      authenticated: (_, __, permissions, userInfo) async {
        // Check if user has permission to manage circles
        if (!permissions.canManageCircles) {
          return <Circle>[];
        }
        
        // Get all circles and filter by facilitator
        try {
          final circles = await repository.getCircles();
          final userId = int.tryParse(userInfo['sub'] ?? '');
          
          if (userId == null) return <Circle>[];
          
          return circles.where((c) => c.facilitatorId == userId).toList();
        } catch (e) {
          throw Exception('Failed to load managed circles: ${e.toString()}');
        }
      },
      unauthenticated: () async => <Circle>[],
    ),
    loading: () async => <Circle>[],
    error: (_, __) async => <Circle>[],
  );
}

/// Provider for circle management actions
@riverpod
class CircleManagement extends _$CircleManagement {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Create a new circle
  Future<Circle> createCircle({
    required String name,
    required String description,
    int? courseId,
    int? maxMembers,
    DateTime? startDate,
    DateTime? endDate,
    String? meetingSchedule,
  }) async {
    state = const AsyncValue.loading();
    
    Circle? createdCircle;
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      createdCircle = await repository.createCircle(
        name: name,
        description: description,
        courseId: courseId,
        maxMembers: maxMembers,
        startDate: startDate,
        endDate: endDate,
        meetingSchedule: meetingSchedule,
      );
      
      // Invalidate to refresh lists
      ref.invalidate(managedCirclesProvider);
      ref.invalidate(myCirclesProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to create circle: ${state.error}');
    }
    
    return createdCircle!;
  }

  /// Update a circle
  Future<void> updateCircle({
    required int circleId,
    String? name,
    String? description,
    int? maxMembers,
    String? meetingSchedule,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.updateCircle(
        circleId: circleId,
        name: name,
        description: description,
        maxMembers: maxMembers,
        meetingSchedule: meetingSchedule,
        status: status,
      );
      
      // Invalidate to refresh
      ref.invalidate(managedCirclesProvider);
      ref.invalidate(myCirclesProvider);
      ref.invalidate(circleProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to update circle: ${state.error}');
    }
  }

  /// Delete a circle
  Future<void> deleteCircle(int circleId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.deleteCircle(circleId);
      
      // Invalidate to refresh
      ref.invalidate(managedCirclesProvider);
      ref.invalidate(myCirclesProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to delete circle: ${state.error}');
    }
  }
}
