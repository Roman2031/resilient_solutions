import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../data/models/admin_models.dart';

/// Activity Feed Item Widget
class ActivityFeedItem extends StatelessWidget {
  final AdminActivity activity;

  const ActivityFeedItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: _getActivityColor(activity.activityType).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                _getActivityIcon(activity.activityType),
                color: _getActivityColor(activity.activityType),
                size: 20.sp,
              ),
            ),
            Gap(12.w),
            
            // Activity Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      if (activity.userName != null) ...[
                        Icon(
                          Icons.person,
                          size: 12.sp,
                          color: Colors.white54,
                        ),
                        Gap(4.w),
                        Text(
                          activity.userName!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white54,
                          ),
                        ),
                        Gap(8.w),
                      ],
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: Colors.white54,
                      ),
                      Gap(4.w),
                      Text(
                        _formatTime(activity.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'user_registered':
        return Icons.person_add;
      case 'circle_created':
        return Icons.group_add;
      case 'content_flagged':
        return Icons.flag;
      case 'system_alert':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'user_login':
        return Icons.login;
      case 'settings_changed':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'user_registered':
        return Colors.green;
      case 'circle_created':
        return Colors.blue;
      case 'content_flagged':
        return Colors.orange;
      case 'system_alert':
        return Colors.amber;
      case 'error':
        return Colors.red;
      case 'user_login':
        return Colors.cyan;
      case 'settings_changed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
