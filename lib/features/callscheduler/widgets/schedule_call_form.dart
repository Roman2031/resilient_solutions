import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../call_service/data/models/call_service_models.dart';

/// Form for scheduling a new call
class ScheduleCallForm extends StatefulWidget {
  final List<Circle> circles;
  final Function(
    int circleId,
    String title,
    DateTime scheduledAt,
    int durationMinutes,
    String? description,
    String? agenda,
    String? meetingLink,
  ) onSchedule;

  const ScheduleCallForm({
    super.key,
    required this.circles,
    required this.onSchedule,
  });

  @override
  State<ScheduleCallForm> createState() => _ScheduleCallFormState();
}

class _ScheduleCallFormState extends State<ScheduleCallForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _agendaController = TextEditingController();
  final _meetingLinkController = TextEditingController();

  Circle? _selectedCircle;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationMinutes = 60;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _agendaController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _handleSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCircle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a circle')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final scheduledAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await widget.onSchedule(
        _selectedCircle!.id,
        _titleController.text.trim(),
        scheduledAt,
        _durationMinutes,
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        _agendaController.text.trim().isEmpty
            ? null
            : _agendaController.text.trim(),
        _meetingLinkController.text.trim().isEmpty
            ? null
            : _meetingLinkController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to schedule call: $e')),
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(),
            Gap(16.h),
            _buildTextField(
              controller: _titleController,
              label: 'Call Title',
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            Gap(16.h),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description (Optional)',
              maxLines: 3,
            ),
            Gap(16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDateTimeField(
                    label: 'Date',
                    value: DateFormat('MMM dd, yyyy').format(_selectedDate),
                    onTap: _selectDate,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: _buildDateTimeField(
                    label: 'Time',
                    value: _selectedTime.format(context),
                    onTap: _selectTime,
                  ),
                ),
              ],
            ),
            Gap(16.h),
            _buildDurationSelector(),
            Gap(16.h),
            _buildTextField(
              controller: _agendaController,
              label: 'Agenda (Optional)',
              maxLines: 3,
            ),
            Gap(16.h),
            _buildTextField(
              controller: _meetingLinkController,
              label: 'Meeting Link (Optional)',
            ),
            Gap(24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0082DF),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('Schedule Call', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<Circle>(
      value: _selectedCircle,
      dropdownColor: const Color(0xff023C7B),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Circle',
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      items: widget.circles
          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
          .toList(),
      onChanged: (v) => setState(() => _selectedCircle = v),
      validator: (v) => v == null ? 'Please select a circle' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: value,
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return DropdownButtonFormField<int>(
      value: _durationMinutes,
      dropdownColor: const Color(0xff023C7B),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Duration',
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      items: const [
        DropdownMenuItem(value: 30, child: Text('30 minutes')),
        DropdownMenuItem(value: 60, child: Text('1 hour')),
        DropdownMenuItem(value: 90, child: Text('1.5 hours')),
        DropdownMenuItem(value: 120, child: Text('2 hours')),
      ],
      onChanged: (v) => setState(() => _durationMinutes = v!),
    );
  }
}
