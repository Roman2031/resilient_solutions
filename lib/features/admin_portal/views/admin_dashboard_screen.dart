import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/activity_feed_item.dart';
import '../widgets/system_health_indicator.dart';

/// Admin Dashboard Screen
/// Main overview screen for administrators
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check permissions
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to view this page',
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(adminDashboardStatsProvider);
              ref.invalidate(recentActivityProvider);
              ref.invalidate(systemHealthProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminDashboardStatsProvider);
          ref.invalidate(recentActivityProvider);
          ref.invalidate(systemHealthProvider);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Stats
              _buildStatsSection(ref),
              Gap(16.h),
              
              // Quick Actions
              _buildQuickActions(context),
              Gap(16.h),
              
              // System Health
              _buildSystemHealthSection(ref),
              Gap(16.h),
              
              // Recent Activity
              _buildRecentActivitySection(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    
    return statsAsync.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Gap(12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.4,
            children: [
              StatCard(
                title: 'Total Users',
                value: stats.totalUsers.toString(),
                icon: Icons.people,
                iconColor: Colors.blue,
                trend: '+${stats.userGrowth.growthPercentage.toStringAsFixed(1)}%',
                isTrendPositive: stats.userGrowth.growthPercentage >= 0,
              ),
              StatCard(
                title: 'Active Circles',
                value: stats.activeCircles.toString(),
                icon: Icons.group,
                iconColor: Colors.green,
              ),
              StatCard(
                title: 'Upcoming Calls',
                value: stats.upcomingCalls.toString(),
                icon: Icons.phone,
                iconColor: Colors.orange,
              ),
              StatCard(
                title: 'Total Courses',
                value: stats.totalCourses.toString(),
                icon: Icons.school,
                iconColor: Colors.purple,
              ),
            ],
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading stats: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(12.h),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              icon: Icons.person_add,
              label: 'Users',
              onTap: () => context.push('/admin/users'),
            ),
            _buildActionCard(
              icon: Icons.analytics,
              label: 'Analytics',
              onTap: () => context.push('/admin/analytics'),
            ),
            _buildActionCard(
              icon: Icons.group,
              label: 'Circles',
              onTap: () => context.push('/admin/circles'),
            ),
            _buildActionCard(
              icon: Icons.admin_panel_settings,
              label: 'Roles',
              onTap: () => context.push('/admin/roles'),
            ),
            _buildActionCard(
              icon: Icons.flag,
              label: 'Moderation',
              onTap: () => context.push('/admin/moderation'),
            ),
            _buildActionCard(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => context.push('/admin/settings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: const Color(0xff023C7B),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xff0082DF), size: 32.sp),
              Gap(8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemHealthSection(WidgetRef ref) {
    final healthAsync = ref.watch(systemHealthProvider);
    
    return healthAsync.when(
      data: (health) => SystemHealthIndicator(health: health),
      loading: () => const Card(
        color: Color(0xff023C7B),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        color: const Color(0xff023C7B),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Error loading health: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(WidgetRef ref) {
    final activityAsync = ref.watch(recentActivityProvider());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(12.h),
        activityAsync.when(
          data: (activities) => activities.isEmpty
              ? Card(
                  color: const Color(0xff023C7B),
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Center(
                      child: Text(
                        'No recent activity',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: activities
                      .take(10)
                      .map((activity) => ActivityFeedItem(activity: activity))
                      .toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading activity: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
