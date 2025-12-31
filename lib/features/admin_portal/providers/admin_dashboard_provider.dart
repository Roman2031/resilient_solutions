import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../data/models/admin_models.dart';
import '../data/repositories/admin_portal_repository.dart';

part 'admin_dashboard_provider.g.dart';

/// Admin Dashboard Stats Provider
@riverpod
Future<AdminDashboardStats> adminDashboardStats(Ref ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getDashboardStats();
}

/// Recent Activity Provider
@riverpod
Future<List<AdminActivity>> recentActivity(
  Ref ref, {
  int limit = 20,
}) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getRecentActivity(limit: limit);
}

/// System Health Provider
@riverpod
Future<SystemHealth> systemHealth(Ref ref) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getSystemHealth();
}
