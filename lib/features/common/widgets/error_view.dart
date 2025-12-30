import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Reusable error view widget for displaying errors with retry action
class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  String _getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }

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
              Icons.error_outline,
              size: 100.sp,
              color: Colors.red.shade300,
            ),
            Gap(16.h),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(8.h),
            Text(
              _getErrorMessage(error),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              Gap(24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0082DF),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
