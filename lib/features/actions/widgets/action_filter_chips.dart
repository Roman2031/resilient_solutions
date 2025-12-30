import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActionFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const ActionFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'value': 'all', 'label': 'All', 'icon': Icons.list},
      {'value': 'pending', 'label': 'Pending', 'icon': Icons.pending},
      {'value': 'in_progress', 'label': 'In Progress', 'icon': Icons.update},
      {'value': 'completed', 'label': 'Completed', 'icon': Icons.check_circle},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['value'];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16.sp,
                    color: isSelected ? Colors.white : const Color(0xff0082DF),
                  ),
                  Gap(4.w),
                  Text(filter['label'] as String),
                ],
              ),
              onSelected: (_) => onFilterChanged(filter['value'] as String),
              backgroundColor: const Color(0xff023C7B),
              selectedColor: const Color(0xff0082DF),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xff0082DF),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  color: isSelected ? const Color(0xff0082DF) : Colors.white30,
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
