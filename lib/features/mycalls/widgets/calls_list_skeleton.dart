import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loading widget for call list
class CallsListSkeleton extends StatelessWidget {
  final int itemCount;

  const CallsListSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: itemCount,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xff023C7B),
          highlightColor: const Color(0xff0082DF).withOpacity(0.3),
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
                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Gap(8.h),
                          Container(
                            width: 150.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(12.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Gap(12.h),
                Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index < 2 ? 8.w : 0),
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
