import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';
import 'package:kindomcall/core/widgets/custom_text_formfield.dart';

import '../../newtemplate/views/newtemplate.dart';

class CreateCallCircleCourseScreen extends ConsumerStatefulWidget {
  const CreateCallCircleCourseScreen({super.key});

  @override
  ConsumerState<CreateCallCircleCourseScreen> createState() =>
      _CreateCallCircleCourseScreenState();
}

class _CreateCallCircleCourseScreenState
    extends ConsumerState<CreateCallCircleCourseScreen> {
  bool isChecked = false;
  final Map<String, bool> daysOfWeek = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };
  String? selectedOption;
  bool discipleship7 = false;
  bool discipleship16Week = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: Color(0xff023C7B),
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset("assets/pngs/logo.png", height: 50.h),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(24.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff023C7B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ), // Adjust the border radius as neededb
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff0082DF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Text(
                      'Create a Call Circle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Gap(24.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/pngs/map.png",
                              height: 96.h,
                              width: 96.w,
                            ),
                            Gap(10.w),
                            Container(
                              height: 52.h,
                              width: 230.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/pngs/upload.png",
                                    height: 25.h,
                                    width: 26.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(16.h),
                        CustomTextFormField(
                          name: 'coursename',
                          hintText: 'Course Name',
                          textInputType: TextInputType.text,
                          controller: TextEditingController(),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return null;
                          },
                        ),
                        Gap(24.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                prefixWidget: Image.asset(
                                  "assets/pngs/bookopen.png",
                                  height: 24.h,
                                  width: 24.w,
                                ),

                                name: 'newcourseorTemplate',
                                hintText: 'New Course or Template',
                                textInputType: TextInputType.text,
                                controller: TextEditingController(),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              "|",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                              ),
                            ),

                            Container(
                              height: 52.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xff0082DF),
                                size: 24.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Days of the Week",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Create a checklist for each day
                        ...daysOfWeek.keys.map((day) {
                          return Row(
                            children: [
                              Checkbox(
                                value: daysOfWeek[day],
                                activeColor: Colors
                                    .red, // Checkbox background color when active
                                checkColor:
                                    Colors.white, // ✅ Check icon color (white)
                                side: const BorderSide(color: Colors.white),
                                onChanged: (bool? value) {
                                  setState(() {
                                    daysOfWeek[day] = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                day,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        }),
                        Gap(24.h),
                        Text(
                          "Download Fillable Form?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),

                        Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: "Yes",
                                  groupValue: selectedOption,
                                  activeColor:
                                      Colors.red, // Circle color when selected
                                  fillColor: WidgetStateProperty.all(
                                    Colors.red,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                    // ✅ Condition check for YES
                                    if (value == "Yes") {
                                      debugPrint("User selected YES ✅");
                                    }
                                  },
                                ),
                                const Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: "No",
                                  groupValue: selectedOption,
                                  activeColor: Colors.red,
                                  fillColor: WidgetStateProperty.all(
                                    Colors.red,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                    // ❌ Condition check for NO
                                    if (value == "No") {
                                      debugPrint("User selected NO ❌");
                                    }
                                  },
                                ),
                                const Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(11.h),
                        Text(
                          "Templates",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        Gap(11.h),
                        SizedBox(
                          height: 46.h,
                          width: 150.w,

                          child: CustomButton(
                            buttonText: "New Template",
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) =>NewTemplateScreen()));
                            },
                          ),
                        ),
                        Gap(16.h),

                        Row(
                          children: [
                            Checkbox(
                              value: discipleship7,
                              activeColor:
                                  Colors.red, // background when checked
                              checkColor: Colors.white, // tick color
                              side: const BorderSide(
                                color: Colors.white,
                              ), // border color
                              onChanged: (value) {
                                setState(() {
                                  discipleship7 = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              "Discipleship 7",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Checkbox(
                              value: discipleship16Week,
                              activeColor: Colors.red,
                              checkColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  discipleship16Week = value ?? false;
                                });
                              },
                            ),
                            const Flexible(
                              child: Text(
                                "Discipleship 7 - 16 Week Course",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(40.h),

                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                buttonText: 'Save Course',
                                onPressed: () {},
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: CustomButton(
                                buttonText: 'Cancel',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Gap(40.h),
                      ],
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
