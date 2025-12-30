import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Widget for displaying circle statistics
class CircleStatsCard extends StatelessWidget {
  final int totalMembers;
  final int upcomingCalls;
  final int completedCalls;
  final int activeActions;

  const CircleStatsCard({
    super.key,
    required this.totalMembers,
    required this.upcomingCalls,
    required this.completedCalls,
    required this.activeActions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff023C7B),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.people,
                  label: 'Members',
                  value: totalMembers.toString(),
                  color: Colors.blue.shade300,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _StatItem(
                  icon: Icons.event_available,
                  label: 'Upcoming',
                  value: upcomingCalls.toString(),
                  color: Colors.green.shade300,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle,
                  label: 'Completed',
                  value: completedCalls.toString(),
                  color: Colors.purple.shade300,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _StatItem(
                  icon: Icons.assignment,
                  label: 'Actions',
                  value: activeActions.toString(),
                  color: Colors.orange.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff00519A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.sp),
          Gap(8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
