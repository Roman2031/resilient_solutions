import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Dialog for adding a new member to a circle
class AddMemberDialog extends StatefulWidget {
  final Function(int userId, String role) onAdd;

  const AddMemberDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _userIdController = TextEditingController();
  String _selectedRole = 'learner';
  bool _isLoading = false;

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    final userIdText = _userIdController.text.trim();
    if (userIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a user ID')),
      );
      return;
    }

    final userId = int.tryParse(userIdText);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid user ID')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.onAdd(userId, _selectedRole);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add member: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff023C7B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Member',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(20.h),
            TextField(
              controller: _userIdController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'User ID',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xff0082DF)),
                ),
              ),
            ),
            Gap(16.h),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              dropdownColor: const Color(0xff023C7B),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'learner', child: Text('Learner')),
                DropdownMenuItem(
                    value: 'facilitator', child: Text('Facilitator')),
                DropdownMenuItem(
                    value: 'instructor', child: Text('Instructor')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            Gap(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
                Gap(12.w),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0082DF),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Add', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
