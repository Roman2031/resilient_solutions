import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Widget for a single step in the circle creation form
class CircleFormStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final int stepNumber;

  const CircleFormStep({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xff023C7B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Color(0xff0082DF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      Gap(4.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          child,
        ],
      ),
    );
  }
}
