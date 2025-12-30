
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallButton extends StatelessWidget {
  const CallButton({super.key, required this.title,required this.onTap});
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 43.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Color(0xffEC5800),
          borderRadius: BorderRadius.circular(29.r),
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
