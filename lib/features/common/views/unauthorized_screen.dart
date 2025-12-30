import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// Screen displayed when user lacks permissions for a feature
class UnauthorizedScreen extends StatelessWidget {
  final String? message;

  const UnauthorizedScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Access Denied'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 120.sp,
                color: Colors.white54,
              ),
              Gap(24.h),
              Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Gap(16.h),
              Text(
                message ??
                    'You don\'t have permission to access this feature. '
                        'Please contact your administrator if you believe this is an error.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(32.h),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0082DF),
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
                ),
                child: Text(
                  'Go Back',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
