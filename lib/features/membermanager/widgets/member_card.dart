import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Widget for displaying a member card
class MemberCard extends StatelessWidget {
  final CircleMember member;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const MemberCard({
    super.key,
    required this.member,
    this.onTap,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xff023C7B),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.sp,
                  backgroundColor: const Color(0xff0082DF),
                  child: Text(
                    (member.userName ?? member.userEmail ?? 'U')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
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
                        member.userName ?? 'Unknown User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (member.userEmail != null) ...[
                        Gap(4.h),
                        Text(
                          member.userEmail!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Gap(12.h),
            Row(
              children: [
                Chip(
                  label: Text(
                    member.role.toUpperCase(),
                    style: TextStyle(fontSize: 11.sp),
                  ),
                  backgroundColor: const Color(0xff0082DF),
                  labelStyle: const TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
                Gap(8.w),
                Chip(
                  label: Text(
                    member.status.toUpperCase(),
                    style: TextStyle(fontSize: 11.sp),
                  ),
                  backgroundColor: member.status == 'active'
                      ? Colors.green.shade700
                      : Colors.grey.shade700,
                  labelStyle: const TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
                const Spacer(),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    iconSize: 20.sp,
                    onPressed: onEdit,
                  ),
                if (onRemove != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade300),
                    iconSize: 20.sp,
                    onPressed: onRemove,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
