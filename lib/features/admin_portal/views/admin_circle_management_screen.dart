import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../data/repositories/admin_portal_repository.dart';

/// Admin Circle Management Screen
/// Manages all circles from admin perspective
class AdminCircleManagementScreen extends ConsumerWidget {
  const AdminCircleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to manage circles',
      );
    }

    final repository = ref.watch(adminPortalRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Circle Management'),
      ),
      body: FutureBuilder(
        future: repository.getCircles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final circles = snapshot.data ?? [];
          
          if (circles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off, size: 64.sp, color: Colors.white38),
                  Gap(16.h),
                  Text(
                    'No circles found',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: circles.length,
            itemBuilder: (context, index) {
              final circle = circles[index];
              return Card(
                color: const Color(0xff023C7B),
                margin: EdgeInsets.only(bottom: 12.h),
                child: ListTile(
                  leading: const Icon(Icons.group, color: Color(0xff0082DF)),
                  title: Text(
                    circle.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Facilitator: ${circle.facilitatorName ?? 'Unknown'} • ${circle.membersCount} members',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xff012B5E),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive', style: TextStyle(color: Colors.orange)),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
