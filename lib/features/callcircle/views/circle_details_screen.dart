import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/error_view.dart';
import '../providers/circle_details_provider.dart';
import '../widgets/circle_member_item.dart';
import '../widgets/circle_stats_card.dart';
import '../../mycalls/widgets/call_card.dart';

class CircleDetailsScreen extends ConsumerWidget {
  final int circleId;

  const CircleDetailsScreen({
    super.key,
    required this.circleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleDetailsAsync = ref.watch(circleDetailsProvider(circleId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff00519A),
        appBar: AppBar(
          backgroundColor: const Color(0xff023C7B),
          title: const Text('Circle Details'),
          bottom: TabBar(
            indicatorColor: const Color(0xff0082DF),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Members'),
              Tab(text: 'Calls'),
            ],
          ),
        ),
        body: circleDetailsAsync.when(
          data: (details) => TabBarView(
            children: [
              _OverviewTab(details: details),
              _MembersTab(details: details),
              _CallsTab(details: details),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (error, stack) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(circleDetailsProvider),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final details;

  const _OverviewTab({required this.details});

  @override
  Widget build(BuildContext context) {
    final circle = details.circle;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Header
          Container(
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
                    Expanded(
                      child: Text(
                        circle.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: circle.status == 'active'
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        circle.status.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                Text(
                  circle.description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                if (circle.startDate != null || circle.endDate != null) ...[
                  Gap(16.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.white54, size: 16.sp),
                      Gap(8.w),
                      if (circle.startDate != null)
                        Text(
                          DateFormat('MMM dd, yyyy').format(circle.startDate!),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                      if (circle.startDate != null && circle.endDate != null)
                        Text(
                          ' → ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                      if (circle.endDate != null)
                        Text(
                          DateFormat('MMM dd, yyyy').format(circle.endDate!),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                    ],
                  ),
                ],
                if (circle.meetingSchedule != null) ...[
                  Gap(8.h),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.white54, size: 16.sp),
                      Gap(8.w),
                      Text(
                        circle.meetingSchedule!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Gap(16.h),
          // Stats
          CircleStatsCard(
            totalMembers: details.members.length,
            upcomingCalls: details.upcomingCalls.length,
            completedCalls: details.pastCalls.length,
            activeActions: details.activeActions.length,
          ),
        ],
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  final details;

  const _MembersTab({required this.details});

  @override
  Widget build(BuildContext context) {
    if (details.members.isEmpty) {
      return Center(
        child: Text(
          'No members yet',
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: details.members.length,
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        final member = details.members[index];
        return CircleMemberItem(member: member);
      },
    );
  }
}

class _CallsTab extends StatelessWidget {
  final details;

  const _CallsTab({required this.details});

  @override
  Widget build(BuildContext context) {
    final allCalls = [...details.upcomingCalls, ...details.pastCalls];

    if (allCalls.isEmpty) {
      return Center(
        child: Text(
          'No calls scheduled',
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.upcomingCalls.isNotEmpty) ...[
            Text(
              'Upcoming Calls',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(12.h),
            ...details.upcomingCalls.map(
              (call) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: CallCard(
                  call: call,
                  onTap: () {
                    // TODO: Navigate to call details
                  },
                ),
              ),
            ),
            Gap(16.h),
          ],
          if (details.pastCalls.isNotEmpty) ...[
            Text(
              'Past Calls',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(12.h),
            ...details.pastCalls.map(
              (call) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: CallCard(
                  call: call,
                  showActions: false,
                  onTap: () {
                    // TODO: Navigate to call details
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
