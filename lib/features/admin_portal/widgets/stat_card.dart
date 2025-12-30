import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Stat Card Widget for displaying metrics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? trend;
  final bool? isTrendPositive;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.trend,
    this.isTrendPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xff023C7B),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? const Color(0xff0082DF),
                    size: 32.sp,
                  ),
                  if (trend != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isTrendPositive == true
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isTrendPositive == true
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isTrendPositive == true
                                ? Colors.green
                                : Colors.red,
                            size: 16.sp,
                          ),
                          Gap(4.w),
                          Text(
                            trend!,
                            style: TextStyle(
                              color: isTrendPositive == true
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Gap(16.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Gap(8.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
