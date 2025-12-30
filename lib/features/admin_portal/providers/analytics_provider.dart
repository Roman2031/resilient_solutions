import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../data/models/analytics_models.dart';
import '../data/repositories/admin_portal_repository.dart';

part 'analytics_provider.g.dart';

/// User Analytics Provider
@riverpod
Future<UserAnalytics> userAnalytics(
  UserAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getUserAnalytics(
    startDate: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
    endDate: endDate ?? DateTime.now(),
  );
}

/// Circle Analytics Provider
@riverpod
Future<CircleAnalytics> circleAnalytics(CircleAnalyticsRef ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getCircleAnalytics();
}

/// Learning Analytics Provider
@riverpod
Future<LearningAnalytics> learningAnalytics(LearningAnalyticsRef ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getLearningAnalytics();
}

/// Call Analytics Provider
@riverpod
Future<CallAnalytics> callAnalytics(CallAnalyticsRef ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getCallAnalytics();
}

/// Engagement Analytics Provider
@riverpod
Future<EngagementAnalytics> engagementAnalytics(EngagementAnalyticsRef ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getEngagementAnalytics();
}
