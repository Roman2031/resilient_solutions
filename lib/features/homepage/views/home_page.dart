import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0056A6),
      body: Stack(
        children: [
          // === Main Scrollable Content ===
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 60.h, bottom: 80.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ======= Logo & Menu =======
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("aassets/pngs/logo.png", height: 40.h),
                      Icon(Icons.menu, color: Colors.white, size: 28.sp),
                    ],
                  ),
                ),

                Gap(25.h),

                // ======= Verse of the Day =======
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff0077D7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "VERSE OF THE DAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Gap(10.h),
                        Text(
                          "But let justice roll on like a river,\n righteousness like a never failing stream.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),
                        Gap(8.h),
                        Text(
                          "Amos 5:24 (KJV)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(25.h),

                // ======= Upcoming Calls Section =======
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff0077D7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UPCOMING CALLS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(16.h),
                          ...List.generate(3, (index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 18.h),
                              child: _buildCallCard(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======= Bottom Bar =======
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 65.h,
                  color: const Color(0xff023C7B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _bottomIcon(Icons.chat_bubble, "Chats"),
                      _bottomIcon(Icons.people, "Groups"),
                      _bottomIcon(Icons.phone, "Phone"),
                      _bottomIcon(Icons.message, "Message"),
                      _bottomIcon(Icons.person, "Profile"),
                    ],
                  ),
                ),
                Container(
                  height: 39.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xff012B5E)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "©2025 Kingdom® Call Circles",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Licensed Trademark",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Helper Widgets ===

  Widget _buildCallCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff0056A6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ann Smith",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Wednesday, July 05 | 11:30 AM EST",
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          Text(
            "Discipleship 7 Circle\nLove Your Neighbor",
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton("Make Call"),
              _actionButton("Manage Call"),
              _actionButton("Notes"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xffFF6600),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 22.sp),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 11.sp),
        ),
      ],
    );
  }
}
