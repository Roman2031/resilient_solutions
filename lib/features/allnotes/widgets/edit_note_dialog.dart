import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../call_service/data/models/call_service_models.dart';

class EditNoteDialog extends ConsumerStatefulWidget {
  final Note note;

  const EditNoteDialog({
    super.key,
    required this.note,
  });

  @override
  ConsumerState<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends ConsumerState<EditNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  late bool _isPrivate;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
    _isPrivate = widget.note.isPrivate;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
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
                      Icons.edit_note,
                      color: const Color(0xff0082DF),
                      size: 24.sp,
                    ),
                    Gap(8.w),
                    Text(
                      'Edit Note',
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
                // Content field
                TextFormField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 8,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    labelText: 'Note Content *',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: 'Enter your note here...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xff012B5E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    counterStyle: const TextStyle(color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter note content';
                    }
                    if (value.trim().length < 3) {
                      return 'Note must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                Gap(16.h),
                // Privacy toggle
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff012B5E),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPrivate ? Icons.lock : Icons.lock_open,
                        color: _isPrivate ? const Color(0xffFF9800) : Colors.white70,
                        size: 20.sp,
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Private Note',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(2.h),
                            Text(
                              _isPrivate
                                  ? 'Only visible to you'
                                  : 'Visible to all circle members',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isPrivate,
                        onChanged: (value) => setState(() => _isPrivate = value),
                        activeColor: const Color(0xffFF9800),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.white30,
                      ),
                    ],
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
                            'content': _contentController.text.trim(),
                            'isPrivate': _isPrivate,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0082DF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
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
