import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';
import 'package:kindomcall/core/widgets/custom_text_formfield.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff023C7B),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 45.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.r),
                          topLeft: Radius.circular(24.r),
                        ),
                        color: Color(0xff0082DF),
                      ),
                      child: Text(
                        "MY PROFILE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        children: [
                          Container(
                            height: 56.h,
                            width: 56.w,
                            decoration: BoxDecoration(
                              color: Color(0xff0082DF),

                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              "assets/pngs/use.png",
                              height: 50.h,
                              width: 50.w,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "Jonathan Carter",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Learner",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Group : ',
                              style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'No group name set',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color(0xffFFFFFF),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(10.h),

                          Gap(4.h),
                          CustomTextFormField(
                            name: 'groupname',
                            hintText: 'Enter Group Name',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),

                          Gap(8.h),

                          Text(
                            "Phone Number",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gap(4.h),
                          CustomTextFormField(
                            name: 'phone',
                            hintText: 'Enter your Phne number',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(8.h),

                          Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gap(4.h),
                          CustomTextFormField(
                            name: 'phone',
                            hintText: 'Enter your Phne number',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),

                          CustomTextFormField(
                            maxLines: 8,
                            name: 'coursename',
                            hintText: 'Course Name',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),

                          CustomTextFormField(
                            maxLines: 8,
                            name: 'role',
                            hintText: 'Role',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(8.h),
                          Text(
                            "Call Schedule",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  suffixWidget: Image.asset(
                                    "assets/pngs/calendar.png",
                                  ),
                                  name: 'date',
                                  hintText: 'mm/dd/yyyy',
                                  textInputType: TextInputType.phone,
                                  controller: TextEditingController(),
                                  textInputAction: TextInputAction.next,
                                  validator: (String? p1) {
                                    return null;
                                  },
                                ),
                              ),
                              Gap(10.w),
                              Expanded(
                                child: CustomTextFormField(
                                  suffixWidget: Image.asset(
                                    "assets/pngs/clock.png",
                                  ),
                                  name: 'time',
                                  hintText: '12:00 PM',
                                  textInputType: TextInputType.phone,
                                  controller: TextEditingController(),
                                  textInputAction: TextInputAction.next,
                                  validator: (String? p1) {
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Gap(8.h),
                          Text(
                            "Time of Day",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gap(4.h),
                          CustomTextFormField(
                            name: 'norning',
                            hintText: 'Morning',
                            textInputType: TextInputType.phone,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),

                          Gap(16.h),
                          CustomButton(buttonText: "Cancel", onPressed: () {}),
                          Gap(37.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
