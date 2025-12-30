import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Empty state specifically for calls list
class EmptyCallsState extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;

  const EmptyCallsState({
    super.key,
    this.title,
    this.message,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 100.sp,
              color: Colors.white54,
            ),
            Gap(16.h),
            Text(
              title ?? 'No Calls Yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(8.h),
            Text(
              message ??
                  'You don\'t have any scheduled calls at the moment.\n'
                      'Check back later or join a circle to get started.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              Gap(24.h),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0082DF),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  'Explore Circles',
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
