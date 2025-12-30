import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';
import 'package:kindomcall/features/auth/views/widgets/bg.dart';

import '../../../core/widgets/custom_text_formfield.dart';
import 'widgets/fotter_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SvgBackground(
        assetPath: 'assets/pngs/loginpagebg.png',
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 55.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/pngs/logo.png", height: 90.h, width: 249.w),
                Gap(22.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0082DF),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(12.h),
                          Text(
                            "First Name",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Gap(6.h),
                          CustomTextFormField(
                            name: 'firtname',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(10.h),
                          Text(
                            "Last Name",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Gap(6.h),
                          CustomTextFormField(
                            name: 'lastname',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Gap(6.h),
                          CustomTextFormField(
                            name: 'phone',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Gap(6.h),
                          CustomTextFormField(
                            name: 'email',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          Text(
                            "Create Username",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Gap(6.h),
                          CustomTextFormField(
                            name: 'username',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          Text(
                            "Create Password",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Gap(6.h),
                          CustomTextFormField(
                            name: 'password',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          Text(
                            "Repeat Password",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Gap(6.h),
                          CustomTextFormField(
                            name: 'repeatpassword',
                            hintText: '',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(22.h),
                SizedBox(
                  height: 46.h,
                  width: 220.w,
                  child: CustomButton(buttonText: 'Sign Up', onPressed: () {}),
                ),
                Gap(10.h),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Gap(20.h),
                FotterScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
