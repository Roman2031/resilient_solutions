
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, required this.title, required this.ontab});
  final String title;
  final VoidCallback ontab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        alignment: Alignment.center,
        height: 40.h,
        width: 115.w,
        decoration: BoxDecoration(
          color: Color(0xffEC5800),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
