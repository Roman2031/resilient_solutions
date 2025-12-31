import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../../call_service/data/models/call_service_models.dart';
import '../../call_service/data/repositories/call_service_repository.dart';

part 'dashboard_providers.g.dart';

/// Provider for upcoming calls displayed on dashboard
/// Fetches the user's upcoming calls from the backend
@riverpod
Future<List<UpcomingCall>> upcomingCalls(Ref ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getMyUpcomingCalls();
}

/// Provider for current user profile
/// Fetches the user's profile information from the backend
@riverpod
Future<UserProfile> currentUserProfile(Ref ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getMe();
}

/// Provider for user action items
/// Fetches pending action items assigned to the user
@riverpod
Future<List<ActionItem>> myActionItems(Ref ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getMyActions();
}

/// Provider for user's circles
/// Fetches all circles the user is a member of
@riverpod
Future<List<Circle>> myCircles(Ref ref) async {
  // Ensure user is authenticated
  final authState = await ref.watch(authRepositoryProvider.future);
  if (authState is! AuthenticatedState) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(callServiceRepositoryProvider);
  return await repository.getCircles();
}
