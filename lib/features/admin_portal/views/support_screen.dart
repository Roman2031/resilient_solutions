import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';

/// Support Screen
/// Help desk and support (Placeholder for future implementation)
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required',
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Support & Help Desk'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                size: 80.sp,
                color: Colors.white38,
              ),
              Gap(24.h),
              Text(
                'Support Center',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Gap(12.h),
              Text(
                'Help desk and support ticket management coming soon.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(32.h),
              Card(
                color: const Color(0xff023C7B),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Text(
                        'Planned Features:',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Gap(12.h),
                      _buildFeature('User support tickets'),
                      _buildFeature('Respond to inquiries'),
                      _buildFeature('FAQ management'),
                      _buildFeature('Help documentation'),
                      _buildFeature('Live chat with users'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xff0082DF),
            size: 16.sp,
          ),
          Gap(8.w),
          Text(
            feature,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
