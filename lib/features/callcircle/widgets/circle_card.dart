import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Widget for displaying a circle card in the list
class CircleCard extends StatelessWidget {
  final Circle circle;
  final VoidCallback? onTap;
  final int? nextCallDays;

  const CircleCard({
    super.key,
    required this.circle,
    this.onTap,
    this.nextCallDays,
  });

  Color _getStatusColor() {
    switch (circle.status) {
      case 'active':
        return Colors.green.shade300;
      case 'completed':
        return Colors.grey.shade300;
      case 'cancelled':
        return Colors.red.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  String _getStatusLabel() {
    return circle.status.toUpperCase();
  }

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
                Expanded(
                  child: Text(
                    circle.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Gap(8.h),
            Text(
              circle.description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(12.h),
            Row(
              children: [
                Icon(Icons.people, color: Colors.white54, size: 16.sp),
                Gap(4.w),
                Text(
                  '${circle.membersCount} members',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12.sp,
                  ),
                ),
                if (circle.maxMembers != null) ...[
                  Text(
                    ' / ${circle.maxMembers}',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
                const Spacer(),
                if (nextCallDays != null) ...[
                  Icon(Icons.event, color: Colors.white54, size: 16.sp),
                  Gap(4.w),
                  Text(
                    nextCallDays == 0
                        ? 'Today'
                        : nextCallDays == 1
                            ? 'Tomorrow'
                            : 'In $nextCallDays days',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ],
            ),
            if (circle.startDate != null || circle.endDate != null) ...[
              Gap(8.h),
              Row(
                children: [
                  if (circle.startDate != null) ...[
                    Icon(Icons.calendar_today,
                        color: Colors.white54, size: 14.sp),
                    Gap(4.w),
                    Text(
                      DateFormat('MMM dd, yyyy').format(circle.startDate!),
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                  if (circle.startDate != null && circle.endDate != null) ...[
                    Gap(8.w),
                    Text(
                      '→',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                    Gap(8.w),
                  ],
                  if (circle.endDate != null) ...[
                    Text(
                      DateFormat('MMM dd, yyyy').format(circle.endDate!),
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
