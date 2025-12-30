import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Simplified calendar view for displaying calls by date
class CalendarView extends StatelessWidget {
  final Map<DateTime, List<Call>> callsByDate;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<Call>? onCallTap;

  const CalendarView({
    super.key,
    required this.callsByDate,
    required this.selectedMonth,
    required this.onMonthChanged,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MonthSelector(
          selectedMonth: selectedMonth,
          onMonthChanged: onMonthChanged,
        ),
        Gap(16.h),
        Expanded(
          child: _CallsList(
            callsByDate: callsByDate,
            onCallTap: onCallTap,
          ),
        ),
      ],
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const _MonthSelector({
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff023C7B),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              final newMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month - 1,
              );
              onMonthChanged(newMonth);
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(selectedMonth),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              final newMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month + 1,
              );
              onMonthChanged(newMonth);
            },
          ),
        ],
      ),
    );
  }
}

class _CallsList extends StatelessWidget {
  final Map<DateTime, List<Call>> callsByDate;
  final ValueChanged<Call>? onCallTap;

  const _CallsList({
    required this.callsByDate,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    if (callsByDate.isEmpty) {
      return Center(
        child: Text(
          'No calls scheduled this month',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
      );
    }

    final sortedDates = callsByDate.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: sortedDates.length,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final calls = callsByDate[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMM dd').format(date),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8.h),
            ...calls.map((call) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _CallItem(call: call, onTap: () => onCallTap?.call(call)),
                )),
          ],
        );
      },
    );
  }
}

class _CallItem extends StatelessWidget {
  final Call call;
  final VoidCallback? onTap;

  const _CallItem({
    required this.call,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xff023C7B),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xff0082DF),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    DateFormat('h:mm a').format(call.scheduledAt),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
