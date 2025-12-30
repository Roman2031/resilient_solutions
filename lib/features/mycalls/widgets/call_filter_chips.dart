import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/call_filter.dart';

/// Filter chips for call list filtering
class CallFilterChips extends StatelessWidget {
  final CallFilter selectedFilter;
  final ValueChanged<CallFilter> onFilterChanged;

  const CallFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: CallFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              label: Text(filter.displayName),
              selected: isSelected,
              onSelected: (_) => onFilterChanged(filter),
              backgroundColor: const Color(0xff023C7B),
              selectedColor: const Color(0xff0082DF),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
          );
        }).toList(),
      ),
    );
  }
}
