import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/empty_state.dart';
import '../../common/widgets/error_view.dart';
import '../models/call_filter.dart';
import '../providers/call_actions_provider.dart';
import '../providers/my_calls_provider.dart';
import '../widgets/call_card.dart';
import '../widgets/call_filter_chips.dart';
import '../widgets/calls_list_skeleton.dart';
import '../widgets/empty_calls_state.dart';

class MycallsScreen extends ConsumerStatefulWidget {
  const MycallsScreen({super.key});

  @override
  ConsumerState<MycallsScreen> createState() => _MycallsScreenState();
}

class _MycallsScreenState extends ConsumerState<MycallsScreen> {
  CallFilter _selectedFilter = CallFilter.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchMeetingLink(String? link) async {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open meeting link')),
        );
      }
    }
  }

  Future<void> _handleReschedule(int callId) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    try {
      await ref
          .read(callActionsProvider.notifier)
          .rescheduleCall(callId: callId, newScheduledAt: newDateTime);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Call rescheduled successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reschedule: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCallsAsync = ref.watch(
      filteredCallsProvider(_selectedFilter, _searchQuery),
    );

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        automaticallyImplyLeading: false,
        title: Image.asset("assets/pngs/logo.png", height: 50.h),
      ),
      body: Column(
        children: [
          Gap(16.h),
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search calls...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xff023C7B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Gap(12.h),
          // Filter chips
          CallFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          Gap(16.h),
          // Calls list
          Expanded(
            child: filteredCallsAsync.when(
              data: (calls) {
                if (calls.isEmpty) {
                  return EmptyCallsState(
                    title: _searchQuery.isNotEmpty
                        ? 'No Results Found'
                        : 'No Calls Yet',
                    message: _searchQuery.isNotEmpty
                        ? 'Try adjusting your search or filters'
                        : null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.refresh(myCallsProvider.future);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: calls.length,
                    separatorBuilder: (_, __) => Gap(12.h),
                    itemBuilder: (context, index) {
                      final call = calls[index];
                      return CallCard(
                        call: call,
                        onTap: () {
                          // TODO: Navigate to call details
                        },
                        onMakeCall: call.meetingLink != null
                            ? () => _launchMeetingLink(call.meetingLink)
                            : null,
                        onReschedule: () => _handleReschedule(call.id),
                        onNotes: () {
                          // TODO: Navigate to notes
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const CallsListSkeleton(),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(myCallsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
