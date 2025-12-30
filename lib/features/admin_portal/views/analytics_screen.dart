import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/export_dialog.dart';

/// Analytics Screen
/// Displays platform analytics and metrics
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check permissions
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to view analytics',
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Analytics & Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _showExportDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userAnalyticsProvider);
          ref.invalidate(circleAnalyticsProvider);
          ref.invalidate(learningAnalyticsProvider);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserAnalytics(ref),
              Gap(16.h),
              _buildCircleAnalytics(ref),
              Gap(16.h),
              _buildLearningAnalytics(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAnalytics(WidgetRef ref) {
    final analyticsAsync = ref.watch(userAnalyticsProvider());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Analytics',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(12.h),
        analyticsAsync.when(
          data: (analytics) => Column(
            children: [
              AnalyticsChart(
                title: 'User Growth Trend',
                data: analytics.userGrowth,
                type: ChartType.line,
              ),
              Gap(12.h),
              _buildMetricCards([
                ('Total Users', analytics.totalUsers.toString()),
                ('Active Users', analytics.activeUsers.toString()),
                ('Retention Rate', '${analytics.retentionRate.toStringAsFixed(1)}%'),
              ]),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorCard('Error loading user analytics'),
        ),
      ],
    );
  }

  Widget _buildCircleAnalytics(WidgetRef ref) {
    final analyticsAsync = ref.watch(circleAnalyticsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Circle Analytics',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(12.h),
        analyticsAsync.when(
          data: (analytics) => Column(
            children: [
              AnalyticsChart(
                title: 'Circle Creation Trend',
                data: analytics.circleCreationTrend,
                type: ChartType.bar,
              ),
              Gap(12.h),
              _buildMetricCards([
                ('Total Circles', analytics.totalCircles.toString()),
                ('Active Circles', analytics.activeCircles.toString()),
                ('Avg Members', analytics.averageMembers.toStringAsFixed(1)),
              ]),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorCard('Error loading circle analytics'),
        ),
      ],
    );
  }

  Widget _buildLearningAnalytics(WidgetRef ref) {
    final analyticsAsync = ref.watch(learningAnalyticsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Analytics',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(12.h),
        analyticsAsync.when(
          data: (analytics) => _buildMetricCards([
            ('Total Enrollments', analytics.totalEnrollments.toString()),
            ('Completion Rate', '${analytics.averageCompletionRate.toStringAsFixed(1)}%'),
            ('Certificates', analytics.certificatesIssued.toString()),
          ]),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorCard('Error loading learning analytics'),
        ),
      ],
    );
  }

  Widget _buildMetricCards(List<(String, String)> metrics) {
    return Card(
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: metrics.map((metric) {
            return Column(
              children: [
                Text(
                  metric.$2,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Gap(4.h),
                Text(
                  metric.$1,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: const Color(0xff023C7B),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(
        onExport: (format, startDate, endDate) {
          // Export functionality - implementation in future phase
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export to $format coming soon. Data will be available via API.'),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }
}
