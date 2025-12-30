import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Role Assignment Dialog for managing user roles
class RoleAssignmentDialog extends StatefulWidget {
  final List<String> currentRoles;
  final Function(List<String>) onAssign;

  const RoleAssignmentDialog({
    super.key,
    required this.currentRoles,
    required this.onAssign,
  });

  @override
  State<RoleAssignmentDialog> createState() => _RoleAssignmentDialogState();
}

class _RoleAssignmentDialogState extends State<RoleAssignmentDialog> {
  final List<String> availableRoles = ['learner', 'facilitator', 'instructor', 'admin'];
  late Set<String> selectedRoles;

  @override
  void initState() {
    super.initState();
    selectedRoles = widget.currentRoles.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assign Roles',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Gap(16.h),
            
            // Role List
            ...availableRoles.map((role) => CheckboxListTile(
              title: Text(
                role.toUpperCase(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _getRoleDescription(role),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
              ),
              value: selectedRoles.contains(role),
              activeColor: const Color(0xff0082DF),
              checkColor: Colors.white,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedRoles.add(role);
                  } else {
                    selectedRoles.remove(role);
                  }
                });
              },
            )),
            
            Gap(16.h),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Gap(8.w),
                ElevatedButton(
                  onPressed: selectedRoles.isEmpty
                      ? null
                      : () {
                          widget.onAssign(selectedRoles.toList());
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0082DF),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Assign Roles',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleDescription(String role) {
    switch (role.toLowerCase()) {
      case 'learner':
        return 'Default participant; consumes courses';
      case 'facilitator':
        return 'Leads a Circle; manages roster, attendance';
      case 'instructor':
        return 'Creates/manages courses; reviews analytics';
      case 'admin':
        return 'Platform governance, moderation, configuration';
      default:
        return '';
    }
  }
}
