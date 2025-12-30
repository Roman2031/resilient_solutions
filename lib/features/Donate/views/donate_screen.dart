import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';
import 'package:kindomcall/core/widgets/custom_text_formfield.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String? selectedDonation;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Gap(40.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff023C7B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0082DF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "DONATE TO CALL CIRCLE APP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Gap(40.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          "Thanks for helping us keep people connected and growing",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Gap(16.h),
                        CustomTextFormField(
                          name: 'donationamount',
                          hintText: 'Donation Amount*',
                          textInputType: TextInputType.number,
                          controller: TextEditingController(),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            return null;
                          },
                        ),
                        Gap(16.h),
                        Text(
                          "Is this a One-time donation?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Gap(16.h),
                        Row(
                          children: [
                            Radio<String>(
                              value: "one-time",
                              groupValue: selectedDonation,
                              activeColor:
                                  Colors.red, // circle color when selected
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.red; // selected fill
                                  }
                                  return Colors
                                      .white; // border color when unselected
                                },
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedDonation = value;
                                });
                              },
                            ),
                            const Text(
                              "One-time Donation",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Monthly Donation
                        Row(
                          children: [
                            Radio<String>(
                              value: "monthly",
                              groupValue: selectedDonation,
                              activeColor: Colors.red,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.red;
                                  }
                                  return Colors.white;
                                },
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedDonation = value;
                                });
                              },
                            ),
                            const Text(
                              "Monthly Donation",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Gap(16.h),
                        SizedBox(
                          height: 46.h,
                          width: 164.w,
                          child: CustomButton(
                            buttonText: 'Next',
                            onPressed: () {},
                          ),
                        ),
                        Gap(50.h),
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
