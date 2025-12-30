import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../data/models/admin_models.dart';

/// Admin User Card Widget
class AdminUserCard extends StatelessWidget {
  final AdminUser user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onManageRoles;

  const AdminUserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onManageRoles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: const Color(0xff023C7B),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xff0082DF),
                backgroundImage: user.avatar != null
                    ? NetworkImage(user.avatar!)
                    : null,
                child: user.avatar == null
                    ? Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              Gap(12.w),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                    Gap(6.h),
                    
                    // Role Badges
                    Wrap(
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: user.roles
                          .map((role) => _buildRoleBadge(role))
                          .toList(),
                    ),
                  ],
                ),
              ),
              
              // Status & Actions
              Column(
                children: [
                  _buildStatusBadge(user.status),
                  Gap(8.h),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xff012B5E),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'roles':
                          onManageRoles?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.white70),
                            SizedBox(width: 8),
                            Text('Edit', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'roles',
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, color: Colors.white70),
                            SizedBox(width: 8),
                            Text('Manage Roles', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final roleColors = {
      'admin': Colors.red,
      'instructor': Colors.purple,
      'facilitator': Colors.blue,
      'learner': Colors.green,
    };
    
    final color = roleColors[role.toLowerCase()] ?? Colors.grey;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusColors = {
      'active': Colors.green,
      'inactive': Colors.grey,
      'suspended': Colors.red,
    };
    
    final color = statusColors[status.toLowerCase()] ?? Colors.grey;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
