import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';
import '../../callcircle/providers/circles_provider.dart';

part 'member_management_provider.g.dart';

/// Provider for member management actions
@riverpod
class MemberManagement extends _$MemberManagement {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Add a member to a circle
  Future<CircleMember> addMember({
    required int circleId,
    required int userId,
    String role = 'learner',
  }) async {
    state = const AsyncValue.loading();
    
    CircleMember? addedMember;
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      addedMember = await repository.addCircleMember(
        circleId: circleId,
        userId: userId,
        role: role,
      );
      
      // Invalidate to refresh
      ref.invalidate(circleMembersProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to add member: ${state.error}');
    }
    
    return addedMember!;
  }

  /// Update a circle member
  Future<void> updateMember({
    required int memberId,
    String? role,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.updateCircleMember(
        memberId: memberId,
        role: role,
        status: status,
      );
      
      // Invalidate to refresh
      ref.invalidate(circleMembersProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to update member: ${state.error}');
    }
  }

  /// Remove a member from a circle
  Future<void> removeMember(int memberId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      await repository.deleteCircleMember(memberId);
      
      // Invalidate to refresh
      ref.invalidate(circleMembersProvider);
    });
    
    if (state.hasError) {
      throw Exception('Failed to remove member: ${state.error}');
    }
  }
}
