import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';

class CallSchedulerScreen extends StatefulWidget {
  const CallSchedulerScreen({super.key});

  @override
  State<CallSchedulerScreen> createState() => _CallSchedulerScreenState();
}
class _CallSchedulerScreenState extends State<CallSchedulerScreen> {

 DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedPeriod = 'Morning';

  void _showDatePicker() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (date) => setState(() => selectedDate = date),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _outlinedButton("Cancel", () => Navigator.pop(context)),
                  _filledButton("Apply", () {
                    // Navigator.pop(context);
                    // _showTimePicker();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _timeColumn("06"),
                  _timeColumn("28"),
                  _timeColumn("55"),
                  const SizedBox(width: 8),
                  Column(
                    children: const [
                      Text(
                        "PM",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF0046A0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "AM",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                initialValue: selectedPeriod,
                items: const [
                  DropdownMenuItem(value: 'Morning', child: Text('Morning')),
                  DropdownMenuItem(value: 'Evening', child: Text('Evening')),
                ],
                onChanged: (value) => setState(() => selectedPeriod = value!),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _outlinedButton("Cancel", () => Navigator.pop(context)),
                  _filledButton("Save", () => Navigator.pop(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeColumn(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          Container(width: 36, height: 2, color: Colors.grey.shade200),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF0046A0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinedButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      ),
      child: Text(text),
    );
  }

  Widget _filledButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0046A0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00519A),
      endDrawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff023C7B),
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset("assets/pngs/logo.png", height: 50.h),
        ),
      ),
      body: Column(
        children: [
          Gap(38.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff023C7B),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0082DF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      "CALL SCHEDULER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ann Smith",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Wednesday, July 05 | 11:30 AM EST",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Gap(10.h),
                        Text(
                          "Discipleship 7 Circle\nLove Your Neighbor",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Gap(8.h),
                        Divider(color: Color(0xff949494)),
                        Gap(16.h),
                        Text(
                          "Schedule Call",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Gap(12.h),

                        SizedBox(
                          height: 40.h,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hint: Text('Select a date'),
                              suffixIcon: GestureDetector(
                                onTap: _showDatePicker,
                                
                                child: Icon(Icons.calendar_month)),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 8,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Gap(12.h),
                        SizedBox(
                          height: 40.h,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hint: Text('Select a time'),
                              suffixIcon: GestureDetector(
                                onTap: _showTimePicker,
                                child: Icon(Icons.lock_clock)),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 8,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Gap(10.h),
                        TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hint: Text('Call Instructions'),

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 8,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        Gap(16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomButton(
                                buttonText: "Cancel",
                                onPressed: () {},
                              ),
                            ),
                            Gap(10.w),
                             Expanded(
                               child: CustomButton(
                                buttonText: "Save",
                                onPressed: () {},
                                                           ),
                             ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
