
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MemBerList extends StatelessWidget {
  const MemBerList({super.key, required this.title, required this.midtitle});

  final String title;
  final String midtitle;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),

          Text(
            midtitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 28.h,
            width: 117.w,
            decoration: BoxDecoration(
              color: Color(0xff074A93),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12,bottom: 0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/pngs/settings.png",
                    height: 16.h,
                    width: 16.w,
                  ),
                  Gap(8.w),
                  Text(
                    "Manage",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFFFFFF),
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
