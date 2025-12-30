import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Widget for displaying a circle member item
class CircleMemberItem extends StatelessWidget {
  final CircleMember member;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showActions;

  const CircleMemberItem({
    super.key,
    required this.member,
    this.onTap,
    this.onRemove,
    this.showActions = false,
  });

  Color _getRoleColor() {
    switch (member.role) {
      case 'facilitator':
        return Colors.orange.shade300;
      case 'instructor':
        return Colors.purple.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  String _getRoleLabel() {
    return member.role.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xff023C7B),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.sp,
              backgroundColor: _getRoleColor(),
              child: Text(
                (member.userName ?? member.userEmail ?? 'U')
                    .substring(0, 1)
                    .toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.userName ?? member.userEmail ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (member.userEmail != null && member.userName != null) ...[
                    Gap(2.h),
                    Text(
                      member.userEmail!,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Gap(8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getRoleColor(),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _getRoleLabel(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showActions && onRemove != null) ...[
              Gap(8.w),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red.shade300),
                iconSize: 20.sp,
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
