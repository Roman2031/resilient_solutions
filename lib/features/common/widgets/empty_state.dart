import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Reusable empty state widget for when there's no data to display
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 100.sp,
              color: Colors.white54,
            ),
            Gap(16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              Gap(24.h),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0082DF),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  actionText!,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
