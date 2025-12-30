import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../widgets/permission_matrix.dart';

/// Role Management Screen
/// Manages user roles and permissions
class RoleManagementScreen extends ConsumerWidget {
  const RoleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to manage roles',
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Role Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: const PermissionMatrix(),
      ),
    );
  }
}
