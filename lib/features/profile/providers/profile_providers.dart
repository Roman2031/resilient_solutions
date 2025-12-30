import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';

part 'profile_providers.g.dart';

/// Provider for user profile data
/// Fetches and caches the current user's profile
@riverpod
Future<UserProfile> userProfile(UserProfileRef ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getMe();
}

/// Notifier for profile update operations
/// Handles updating user profile with optimistic updates
@riverpod
class ProfileUpdateNotifier extends _$ProfileUpdateNotifier {
  @override
  FutureOr<void> build() async {
    // No initial state needed
  }

  /// Update user profile
  /// Returns the updated profile on success
  Future<UserProfile> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    // Set loading state
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(callServiceRepositoryProvider);
      
      final updatedProfile = await repository.updateMyProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      // Invalidate the profile provider to refetch fresh data
      ref.invalidate(userProfileProvider);

      return updatedProfile;
    });

    // Return the updated profile or throw error
    return state.when(
      data: (profile) => profile as UserProfile,
      loading: () => throw Exception('Update in progress'),
      error: (error, stack) => throw error,
    );
  }
}
