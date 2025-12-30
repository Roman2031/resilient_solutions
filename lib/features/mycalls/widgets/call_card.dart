import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Widget for displaying an individual call card in the list
class CallCard extends StatelessWidget {
  final Call call;
  final VoidCallback? onTap;
  final VoidCallback? onMakeCall;
  final VoidCallback? onReschedule;
  final VoidCallback? onNotes;
  final bool showActions;

  const CallCard({
    super.key,
    required this.call,
    this.onTap,
    this.onMakeCall,
    this.onReschedule,
    this.onNotes,
    this.showActions = true,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'Today | ${DateFormat('h:mm a').format(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow | ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('EEEE, MMM dd | h:mm a').format(dateTime);
    }
  }

  Color _getStatusColor() {
    switch (call.status) {
      case 'completed':
        return Colors.green.shade300;
      case 'cancelled':
        return Colors.red.shade300;
      case 'in_progress':
        return Colors.orange.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  IconData _getStatusIcon() {
    switch (call.status) {
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'in_progress':
        return Icons.phone_in_talk;
      default:
        return Icons.schedule;
    }
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
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 24.sp,
                ),
                Gap(8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        _formatDateTime(call.scheduledAt),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (call.description != null) ...[
              Gap(8.h),
              Text(
                call.description!,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (showActions) ...[
              Gap(12.h),
              Row(
                children: [
                  if (onMakeCall != null)
                    Expanded(
                      child: _ActionButton(
                        title: 'Join Call',
                        onTap: onMakeCall,
                        icon: Icons.phone,
                      ),
                    ),
                  if (onReschedule != null) ...[
                    Gap(8.w),
                    Expanded(
                      child: _ActionButton(
                        title: 'Reschedule',
                        onTap: onReschedule,
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                  if (onNotes != null) ...[
                    Gap(8.w),
                    Expanded(
                      child: _ActionButton(
                        title: 'Notes',
                        onTap: onNotes,
                        icon: Icons.note,
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

class _ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData icon;

  const _ActionButton({
    required this.title,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xff0082DF),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16.sp),
            Gap(4.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
