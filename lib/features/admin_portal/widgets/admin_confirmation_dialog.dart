import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Admin Confirmation Dialog for dangerous actions
class AdminConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDangerous;
  final bool requireReason;
  final VoidCallback onConfirm;
  final Function(String reason)? onConfirmWithReason;

  const AdminConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDangerous = false,
    this.requireReason = false,
    required this.onConfirm,
    this.onConfirmWithReason,
  });

  @override
  State<AdminConfirmationDialog> createState() => _AdminConfirmationDialogState();
}

class _AdminConfirmationDialogState extends State<AdminConfirmationDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
            // Header with icon
            Row(
              children: [
                Icon(
                  widget.isDangerous ? Icons.warning_amber_rounded : Icons.info_outline,
                  color: widget.isDangerous ? Colors.orange : const Color(0xff0082DF),
                  size: 32.sp,
                ),
                Gap(12.w),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Gap(16.h),
            
            // Message
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
            
            // Reason input if required
            if (widget.requireReason) ...[
              Gap(16.h),
              Text(
                'Reason',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(8.h),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter reason for this action...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  filled: true,
                  fillColor: const Color(0xff012B5E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            
            Gap(20.h),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Gap(8.w),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDangerous ? Colors.red : const Color(0xff0082DF),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          widget.confirmText,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirm() {
    if (widget.requireReason) {
      final reason = _reasonController.text.trim();
      if (reason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide a reason')),
        );
        return;
      }
      widget.onConfirmWithReason?.call(reason);
    } else {
      widget.onConfirm();
    }
    
    Navigator.of(context).pop();
  }
}
