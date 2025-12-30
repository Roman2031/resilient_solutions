import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Loading skeleton for user list
class UserListSkeleton extends StatelessWidget {
  final int itemCount;

  const UserListSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Shimmer.fromColors(
          baseColor: const Color(0xff012B5E),
          highlightColor: const Color(0xff0082DF),
          child: Row(
            children: [
              // Avatar skeleton
              CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 12.w),
              
              // Info skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 14.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          height: 20.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          height: 20.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status skeleton
              Container(
                height: 24.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
