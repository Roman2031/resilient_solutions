import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/auth_repository.dart';
import '../data/models/admin_models.dart';
import '../data/repositories/admin_portal_repository.dart';

part 'user_management_provider.g.dart';

/// All Users Provider with pagination and filters
@riverpod
Future<List<AdminUser>> allUsers(
  AllUsersRef ref, {
  int page = 1,
  int perPage = 20,
  String? search,
  String? roleFilter,
  String? statusFilter,
}) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getUsers(
    page: page,
    perPage: perPage,
    search: search,
    role: roleFilter,
  );
}

/// User Details Provider
@riverpod
Future<AdminUserDetails> userDetails(
  UserDetailsRef ref,
  int userId,
) async {
  final repository = ref.watch(adminPortalRepositoryProvider);
  final permissions = ref.watch(userPermissionsProvider);
  
  if (permissions == null || !permissions.hasAdminPrivileges) {
    throw Exception('Admin access required');
  }
  
  return await repository.getUserDetails(userId);
}

/// User Management Actions Provider
@riverpod
class UserManagement extends _$UserManagement {
  @override
  FutureOr<void> build() async {
    // Initialize if needed
  }

  /// Assign roles to a user
  Future<void> assignRoles({
    required int userId,
    required List<String> roles,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.assignUserRoles(userId: userId, roles: roles);
      
      // Invalidate related providers to refresh data
      ref.invalidate(allUsersProvider);
      ref.invalidate(userDetailsProvider(userId));
    });
  }

  /// Suspend a user
  Future<void> suspendUser(int userId, String reason) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.suspendUser(userId: userId, reason: reason);
      
      // Invalidate related providers
      ref.invalidate(allUsersProvider);
      ref.invalidate(userDetailsProvider(userId));
    });
  }

  /// Activate a user
  Future<void> activateUser(int userId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.activateUser(userId);
      
      // Invalidate related providers
      ref.invalidate(allUsersProvider);
      ref.invalidate(userDetailsProvider(userId));
    });
  }

  /// Delete a user
  Future<void> deleteUser(int userId) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.deleteUser(userId);
      
      // Invalidate related providers
      ref.invalidate(allUsersProvider);
    });
  }

  /// Create a new user
  Future<void> createUser({
    required String name,
    required String email,
    String? password,
    List<String>? roles,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.createUser(
        name: name,
        email: email,
        password: password,
        roles: roles,
      );
      
      // Invalidate to refresh user list
      ref.invalidate(allUsersProvider);
    });
  }

  /// Update user information
  Future<void> updateUser({
    required int userId,
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(adminPortalRepositoryProvider);
      
      await repository.updateUser(
        userId: userId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      // Invalidate related providers
      ref.invalidate(allUsersProvider);
      ref.invalidate(userDetailsProvider(userId));
    });
  }
}
