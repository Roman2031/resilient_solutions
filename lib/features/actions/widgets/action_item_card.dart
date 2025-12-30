import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

class ActionItemCard extends StatelessWidget {
  final ActionItem action;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  const ActionItemCard({
    super.key,
    required this.action,
    this.onTap,
    this.onDelete,
    this.onComplete,
  });

  Color _getStatusColor() {
    switch (action.status.toLowerCase()) {
      case 'completed':
        return const Color(0xff4CAF50); // Green
      case 'in_progress':
        return const Color(0xff2196F3); // Blue
      case 'pending':
        return const Color(0xffFF9800); // Orange
      case 'cancelled':
        return const Color(0xff9E9E9E); // Grey
      default:
        return const Color(0xff757575);
    }
  }

  Color _getPriorityColor() {
    switch (action.priority?.toLowerCase() ?? '') {
      case 'high':
        return const Color(0xffF44336); // Red
      case 'medium':
        return const Color(0xffFF9800); // Orange
      case 'low':
        return const Color(0xff4CAF50); // Green
      default:
        return const Color(0xff9E9E9E); // Grey
    }
  }

  IconData _getStatusIcon() {
    switch (action.status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.update;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  bool get _isOverdue {
    if (action.dueDate == null || action.status == 'completed') {
      return false;
    }
    return action.dueDate!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: _isOverdue ? const Color(0xffF44336) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and priority
              Row(
                children: [
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 14.sp,
                          color: Colors.white,
                        ),
                        Gap(4.w),
                        Text(
                          action.status.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  // Priority badge
                  if (action.priority != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withOpacity(0.2),
                        border: Border.all(color: _getPriorityColor()),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        action.priority!.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Actions menu
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xff012B5E),
                    onSelected: (value) {
                      if (value == 'complete' && onComplete != null) {
                        onComplete!();
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      }
                    },
                    itemBuilder: (context) => [
                      if (action.status != 'completed')
                        PopupMenuItem(
                          value: 'complete',
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              Gap(8.w),
                              const Text('Mark Complete', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.red),
                            Gap(8.w),
                            const Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(12.h),
              // Title
              Text(
                action.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Description
              if (action.description != null && action.description!.isNotEmpty) ...[
                Gap(8.h),
                Text(
                  action.description!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              Gap(12.h),
              // Footer with due date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp,
                    color: _isOverdue ? const Color(0xffF44336) : Colors.white70,
                  ),
                  Gap(4.w),
                  Text(
                    action.dueDate != null
                        ? 'Due: ${DateFormat('MMM dd, yyyy').format(action.dueDate!)}'
                        : 'No due date',
                    style: TextStyle(
                      color: _isOverdue ? const Color(0xffF44336) : Colors.white70,
                      fontSize: 12.sp,
                      fontWeight: _isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (_isOverdue) ...[
                    Gap(4.w),
                    Text(
                      '(OVERDUE)',
                      style: TextStyle(
                        color: const Color(0xffF44336),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
