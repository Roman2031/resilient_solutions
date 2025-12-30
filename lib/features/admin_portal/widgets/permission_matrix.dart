import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Permission Matrix Widget - Visual permission grid
class PermissionMatrix extends StatelessWidget {
  const PermissionMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = ['Learner', 'Facilitator', 'Instructor', 'Admin'];
    final permissions = [
      'View Circles',
      'Manage Circles',
      'Schedule Calls',
      'Manage Members',
      'Manage Courses',
      'View Analytics',
      'Platform Settings',
      'User Management',
      'Content Moderation',
    ];

    // Permission matrix (role x permission)
    final matrix = {
      'Learner': [true, false, false, false, false, false, false, false, false],
      'Facilitator': [true, true, true, true, false, false, false, false, false],
      'Instructor': [true, false, false, false, true, true, false, false, false],
      'Admin': [true, true, true, true, true, true, true, true, true],
    };

    return Card(
      elevation: 2,
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permission Matrix',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(16.h),
            
            // Header Row
            Row(
              children: [
                SizedBox(width: 140.w), // Space for permission names
                ...roles.map((role) => Expanded(
                  child: Center(
                    child: Text(
                      role,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
              ],
            ),
            Gap(12.h),
            Divider(color: Colors.white24),
            Gap(12.h),
            
            // Permission Rows
            ...permissions.asMap().entries.map((entry) {
              final index = entry.key;
              final permission = entry.value;
              
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140.w,
                      child: Text(
                        permission,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    ...roles.map((role) {
                      final hasPermission = matrix[role]![index];
                      return Expanded(
                        child: Center(
                          child: Icon(
                            hasPermission ? Icons.check_circle : Icons.cancel,
                            color: hasPermission ? Colors.green : Colors.red.withOpacity(0.3),
                            size: 20.sp,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
