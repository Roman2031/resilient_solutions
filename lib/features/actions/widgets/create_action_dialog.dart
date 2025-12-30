import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CreateActionDialog extends ConsumerStatefulWidget {
  final int circleId;
  final int assignedTo;
  final int? callId;

  const CreateActionDialog({
    super.key,
    required this.circleId,
    required this.assignedTo,
    this.callId,
  });

  @override
  ConsumerState<CreateActionDialog> createState() => _CreateActionDialogState();
}

class _CreateActionDialogState extends ConsumerState<CreateActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _priority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xff0082DF),
              surface: Color(0xff023C7B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.add_task,
                      color: const Color(0xff0082DF),
                      size: 24.sp,
                    ),
                    Gap(8.w),
                    Text(
                      'Create Action Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Gap(24.h),
                // Title field
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xff012B5E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                Gap(16.h),
                // Description field
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xff012B5E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Gap(16.h),
                // Due date selector
                InkWell(
                  onTap: _selectDueDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff012B5E),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white70),
                        Gap(12.w),
                        Text(
                          _dueDate != null
                              ? 'Due: ${DateFormat('MMM dd, yyyy').format(_dueDate!)}'
                              : 'Select Due Date',
                          style: TextStyle(
                            color: _dueDate != null ? Colors.white : Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        const Spacer(),
                        if (_dueDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () => setState(() => _dueDate = null),
                          ),
                      ],
                    ),
                  ),
                ),
                Gap(16.h),
                // Priority selector
                Text(
                  'Priority',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(8.h),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'low', label: Text('Low')),
                    ButtonSegment(value: 'medium', label: Text('Medium')),
                    ButtonSegment(value: 'high', label: Text('High')),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _priority = newSelection.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xff0082DF);
                        }
                        return const Color(0xff012B5E);
                      },
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                Gap(24.h),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Gap(8.w),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop({
                            'title': _titleController.text.trim(),
                            'description': _descriptionController.text.trim().isEmpty
                                ? null
                                : _descriptionController.text.trim(),
                            'dueDate': _dueDate,
                            'priority': _priority,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0082DF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
