import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/commonbutton.dart';

class LearnerPopupCard extends StatelessWidget {
  const LearnerPopupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF023C7B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                height: 164.h,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xff0257B3)),
                child: Column(
                  children: [
                    Gap(24.h),
                    Image.asset(
                      "assets/pngs/logo.png",
                      height: 79.h,
                      width: 219,
                    ),
                    Text(
                      "Reminder - Upcoming Call",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // User Info
              Text(
                "Ann Smith",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "July 05 | 09:30 AM EST",
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              const SizedBox(height: 8),

              // Course Info
              Text(
                "Discipleship 7 Circle\nLove Your Neighbor",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                "Living out your faith in practical ways each day. ... More",
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonButton(title: 'Make Call', ontab: () {}),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: CommonButton(title: 'Manage Call', ontab: () {}),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: CommonButton(title: 'Notes', ontab: () {}),
                  ),
                ],
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}
