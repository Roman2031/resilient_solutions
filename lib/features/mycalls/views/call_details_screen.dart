import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kindomcall/features/callcircle/providers/circle_details_provider.dart';
import 'package:kindomcall/features/callcircle/widgets/circle_member_item.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../common/widgets/error_view.dart';
//import '../providers/circle_details_provider.dart';
import '../../mycalls/widgets/call_card.dart';

class CallDetailsScreen extends ConsumerWidget {
  final int callId;

  const CallDetailsScreen({
    super.key,
    required this.callId,
  });

  Future<void> _launchMeetingLink(BuildContext context, String? link) async {
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No meeting link available')),
      );
      return;
    }

    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open meeting link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callDetailsAsync = ref.watch(callDetailsProvider(callId));

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Call Details'),
      ),
      body: callDetailsAsync.when(
        data: (details) => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Call Info Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff023C7B),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.call.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(12.h),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      text: DateFormat('EEEE, MMMM dd, yyyy')
                          .format(details.call.scheduledAt),
                    ),
                    Gap(8.h),
                    _InfoRow(
                      icon: Icons.access_time,
                      text: DateFormat('h:mm a').format(details.call.scheduledAt),
                    ),
                    if (details.call.durationMinutes != null) ...[
                      Gap(8.h),
                      _InfoRow(
                        icon: Icons.timer,
                        text: '${details.call.durationMinutes} minutes',
                      ),
                    ],
                    Gap(8.h),
                    _InfoRow(
                      icon: Icons.info,
                      text: details.call.status.toUpperCase(),
                      textColor: details.call.status == 'completed'
                          ? Colors.green.shade300
                          : Colors.blue.shade300,
                    ),
                    if (details.call.description != null) ...[
                      Gap(16.h),
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        details.call.description!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                    if (details.call.meetingLink != null) ...[
                      Gap(16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _launchMeetingLink(
                              context, details.call.meetingLink),
                          icon: const Icon(Icons.videocam),
                          label: Text('Join Call', style: TextStyle(fontSize: 16.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0082DF),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Gap(16.h),
              // Agenda
              if (details.call.agenda != null) ...[
                _SectionHeader(title: 'Agenda'),
                Gap(8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff023C7B),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    details.call.agenda!,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Gap(16.h),
              ],
              // Participants
              _SectionHeader(title: 'Participants (${details.participants.length})'),
              Gap(8.h),
              ...details.participants.map(
                (member) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: CircleMemberItem(member: member),
                ),
              ),
              Gap(16.h),
              // Notes
              _SectionHeader(title: 'Notes (${details.notes.length})'),
              Gap(8.h),
              if (details.notes.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff023C7B),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'No notes yet',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...details.notes.map(
                  (note) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff023C7B),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        note.content,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              Gap(16.h),
              // Action Items
              _SectionHeader(title: 'Action Items (${details.actions.length})'),
              Gap(8.h),
              if (details.actions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff023C7B),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'No action items',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...details.actions.map(
                  (action) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff023C7B),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  action.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  action.status.toUpperCase(),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                backgroundColor: action.status == 'completed'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          if (action.description != null) ...[
                            Gap(4.h),
                            Text(
                              action.description!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stack) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(callDetailsProvider),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 18.sp),
        Gap(8.w),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white70,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
