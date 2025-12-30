import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_button.dart';

class NewTemplateScreen extends StatelessWidget {
  const NewTemplateScreen({super.key});

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
            Gap(24.h),
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
                    alignment: Alignment.center,
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0082DF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Text(
                      "NEW TEMPLATE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: FileDownload()),
                        Gap(16.w),
                        Expanded(child: FileDownload()),
                      ],
                    ),
                  ),
                  Gap(16.h),

                  TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.file_download,
                        size: 24,
                        color: Color(0xff0082DF),
                      ),
                      fillColor: Color(0xFFFFFFFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter Template Name',
                    ),
                  ),
                  Gap(24.h),
                  SizedBox(
                    height: 46.h,
                    width: 164.w,
                    child: CustomButton(buttonText: "Save", onPressed: () {}),
                  ),
                  Gap(40.h),
                ],
              ),
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }
}

class FileDownload extends StatelessWidget {
  const FileDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: 165.w,
      decoration: BoxDecoration(
        color: Color(0xff0257B3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/pngs/filetext.png", height: 35.h, width: 35.w),
            Gap(10.h),

            Text(
              "Download\nPrevious Template",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
