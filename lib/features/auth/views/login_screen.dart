import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_text_formfield.dart';
import 'package:kindomcall/features/auth/views/signupscreen.dart';

import '../../../core/widgets/custom_button.dart';
import '../../dashboard/views/dashboard.dart';
import 'widgets/fotter_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff023C7B),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 SVG background (reusable bg.svg)
            Positioned.fill(
              child: Image.asset(
                "assets/pngs/loginpagebg.png",
                fit: BoxFit.cover,
              ),
            ),

            /// 🔹 Main content centered
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(150.h),
                Image.asset("assets/pngs/logo.png", height: 90.h, width: 249.w),
                Gap(29.h),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff0082DF),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(12.h),
                          CustomTextFormField(
                            name: '',
                            hintText: 'Enter your username',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.next,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Gap(12.h),
                          CustomTextFormField(
                            name: '',
                            hintText: 'Enter your password',
                            textInputType: TextInputType.text,
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.done,
                            validator: (String? p1) {
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(22.h),
                SizedBox(
                  height: 47.h,
                  width: 220.w,
                  child: CustomButton(
                    buttonText: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashBoardScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Gap(10.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                FotterScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
