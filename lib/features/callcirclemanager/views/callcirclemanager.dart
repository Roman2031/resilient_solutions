import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kindomcall/core/widgets/custom_appbar.dart';

import 'widgets/member_list.dart';

class CallCircleManagerScreen extends StatelessWidget {
  const CallCircleManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00519A),
      endDrawer: Drawer(),
      appBar: const CustomAppBar(),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(24.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff023C7B),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.r),
                          topLeft: Radius.circular(24.r),
                        ),

                        color: Color(0xff0082DF),
                      ),
                      child: Text(
                        "CALL CIRCLE MANAGER",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                    Gap(48.h),
                    Text(
                      "Disciple 7\n16 Week Course",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xff7DC5FF),
                      ),
                    ),
                    Gap(8.h),

                    Container(
                      alignment: Alignment.center,
                      height: 35.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                        color: Color(0xffEC5800),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Text(
                        "Select a Course",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                    Gap(24.h),
                    Container(
                      height: 83.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                        color: Color(0xffD2ECFF).withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Learners: ',
                                style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 12.sp,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Jill Smith ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Course Start Date:  ',
                                style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 12.sp,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'September 25, 2025 ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ),
              Gap(24.h),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff023C7B),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          right: 12,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/pngs/person.png",
                              height: 21.h,
                              width: 21.w,
                            ),
                            Text(
                              "MEMBER LIST",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 28.h,
                              width: 117.w,
                              decoration: BoxDecoration(
                                color: Color(0xffEC5800),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Center(
                                child: Text(
                                  "New Member",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                    Divider(color: Color(0xffFFFFFF).withOpacity(0.3)),
                    MemBerList(title: "Jonathan Carter", midtitle: "Learner"),
                  ],
                ),
              ),
              Gap(24.h),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff023C7B),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          right: 12,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/pngs/person.png",
                              height: 21.h,
                              width: 21.w,
                            ),
                            Text(
                              "CALL CIRCLE ASSIGNMENTS",
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
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 12,
                            right: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DAY',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),

                              Text(
                                'NAME',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                              Text(
                                'TIME',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Color(0xffFFFFFF).withOpacity(0.3),
                        );
                      },
                    ),

                    
                  ],
                ),
              ),
              Gap(25.h),
                    TextFormField(
                      
                      decoration: InputDecoration(
                        hint: Text("NOTES",style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),),
                        fillColor: Color(0xff0082DF),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2
                          )
                        ),
                        suffixIcon: Image.asset("assets/pngs/file.png",height: 30.h,width: 30.w,)
                      ),


                    ),
                    Gap(24.h),
                    Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffEC5800),
                        borderRadius: BorderRadius.circular(15.r),

                      ),
                      child: Text("Send Member Message",style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),),
                    ),Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
