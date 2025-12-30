import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Messages List Skeleton
/// Loading placeholder for messages in a thread
class MessagesListSkeleton extends StatelessWidget {
  const MessagesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        final isMe = index % 3 == 0; // Alternate between sent and received
        
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe) ...[
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                ],
                Container(
                  width: 200.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
