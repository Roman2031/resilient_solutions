import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../data/models/analytics_models.dart';

/// Analytics Chart Widget - Placeholder for chart visualization
/// Note: This is a placeholder. For production, integrate with fl_chart or similar package.
/// Data is available via the 'data' parameter for when charts are implemented.
class AnalyticsChart extends StatelessWidget {
  final String title;
  final List<DataPoint> data;
  final ChartType type;

  const AnalyticsChart({
    super.key,
    required this.title,
    required this.data,
    this.type = ChartType.line,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(16.h),
            
            // Chart Placeholder
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: const Color(0xff012B5E),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getChartIcon(),
                      size: 48.sp,
                      color: Colors.white38,
                    ),
                    Gap(8.h),
                    Text(
                      'Chart Visualization',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      '${data.length} data points',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getChartIcon() {
    switch (type) {
      case ChartType.line:
        return Icons.show_chart;
      case ChartType.bar:
        return Icons.bar_chart;
      case ChartType.pie:
        return Icons.pie_chart;
    }
  }
}

enum ChartType {
  line,
  bar,
  pie,
}
