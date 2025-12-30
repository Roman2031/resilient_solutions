import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../providers/user_management_provider.dart';
import '../widgets/admin_user_card.dart';
import '../widgets/user_list_skeleton.dart';
import '../widgets/role_assignment_dialog.dart';
import '../widgets/admin_confirmation_dialog.dart';

/// User Management Screen
/// Allows admins to manage all platform users
class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _roleFilter;
  String? _statusFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check permissions
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to manage users',
      );
    }

    final usersAsync = ref.watch(allUsersProvider(
      search: _searchQuery.isEmpty ? null : _searchQuery,
      roleFilter: _roleFilter,
      statusFilter: _statusFilter,
    ));

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showCreateUserDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(),
          
          // User List
          Expanded(
            child: usersAsync.when(
              data: (users) => users.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(allUsersProvider);
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return AdminUserCard(
                            user: user,
                            onTap: () => _showUserDetails(user.id),
                            onEdit: () => _showEditUserDialog(user.id),
                            onManageRoles: () => _showRoleAssignmentDialog(user.id, user.roles),
                            onDelete: () => _confirmDeleteUser(user.id, user.name),
                          );
                        },
                      ),
                    ),
              loading: () => const UserListSkeleton(),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: const Color(0xff023C7B),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search users by name or email...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xff012B5E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          Gap(12.h),
          
          // Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'Role: ${_roleFilter ?? 'All'}',
                  onTap: () => _showRoleFilterDialog(),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: _buildFilterChip(
                  label: 'Status: ${_statusFilter ?? 'All'}',
                  onTap: () => _showStatusFilterDialog(),
                ),
              ),
              if (_roleFilter != null || _statusFilter != null) ...[
                Gap(8.w),
                IconButton(
                  icon: const Icon(Icons.clear_all, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _roleFilter = null;
                      _statusFilter = null;
                    });
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xff012B5E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64.sp, color: Colors.white38),
          Gap(16.h),
          Text(
            'No users found',
            style: TextStyle(fontSize: 18.sp, color: Colors.white70),
          ),
          Gap(8.h),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14.sp, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            Gap(16.h),
            Text(
              'Error loading users',
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
            Gap(8.h),
            Text(
              error,
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            Gap(16.h),
            ElevatedButton(
              onPressed: () => ref.invalidate(allUsersProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Filter by Role', style: TextStyle(color: Colors.white)),
        children: [
          'All',
          'learner',
          'facilitator',
          'instructor',
          'admin',
        ].map((role) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _roleFilter = role == 'All' ? null : role);
              Navigator.pop(context);
            },
            child: Text(
              role == 'All' ? role : role.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showStatusFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Filter by Status', style: TextStyle(color: Colors.white)),
        children: [
          'All',
          'active',
          'inactive',
          'suspended',
        ].map((status) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _statusFilter = status == 'All' ? null : status);
              Navigator.pop(context);
            },
            child: Text(
              status == 'All' ? status : status.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showUserDetails(int userId) {
    // Navigate to user details - implementation in future phase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User details view coming soon')),
    );
  }

  void _showEditUserDialog(int userId) {
    // Edit user dialog - implementation in future phase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User editing coming soon')),
    );
  }

  void _showRoleAssignmentDialog(int userId, List<String> currentRoles) {
    showDialog(
      context: context,
      builder: (context) => RoleAssignmentDialog(
        currentRoles: currentRoles,
        onAssign: (roles) async {
          final userManagement = ref.read(userManagementProvider.notifier);
          await userManagement.assignRoles(userId: userId, roles: roles);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Roles updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _confirmDeleteUser(int userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AdminConfirmationDialog(
        title: 'Delete User',
        message: 'Are you sure you want to delete user "$userName"? This action cannot be undone.',
        confirmText: 'Delete',
        isDangerous: true,
        requireReason: true,
        onConfirm: () {},
        onConfirmWithReason: (reason) async {
          final userManagement = ref.read(userManagementProvider.notifier);
          await userManagement.deleteUser(userId);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User deleted successfully')),
            );
          }
        },
      ),
    );
  }

  void _showCreateUserDialog() {
    // Create user form - implementation in future phase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User creation form coming soon. Use Keycloak admin console for now.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
