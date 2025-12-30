import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Export Dialog for exporting reports
class ExportDialog extends StatefulWidget {
  final Function(String format, DateTime? startDate, DateTime? endDate) onExport;

  const ExportDialog({
    super.key,
    required this.onExport,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String selectedFormat = 'PDF';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Report',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(16.h),
            
            // Format Selection
            Text(
              'Format',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            Gap(8.h),
            Wrap(
              spacing: 8.w,
              children: ['PDF', 'CSV', 'Excel'].map((format) {
                final isSelected = selectedFormat == format;
                return ChoiceChip(
                  label: Text(format),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => selectedFormat = format);
                  },
                  selectedColor: const Color(0xff0082DF),
                  backgroundColor: const Color(0xff012B5E),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                );
              }).toList(),
            ),
            
            Gap(16.h),
            
            // Date Range (Optional)
            Text(
              'Date Range (Optional)',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            Gap(8.h),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    label: startDate == null ? 'Start Date' : _formatDate(startDate!),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => startDate = date);
                      }
                    },
                  ),
                ),
                Gap(8.w),
                Expanded(
                  child: _buildDateButton(
                    label: endDate == null ? 'End Date' : _formatDate(endDate!),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: startDate ?? DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => endDate = date);
                      }
                    },
                  ),
                ),
              ],
            ),
            
            Gap(20.h),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),
                ),
                Gap(8.w),
                ElevatedButton(
                  onPressed: () {
                    widget.onExport(selectedFormat, startDate, endDate);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0082DF),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: Text('Export', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xff012B5E),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
