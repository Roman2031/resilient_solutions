import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kindomcall/features/callcirclemanager/views/callcirclemanager.dart';

import '../../../core/auth/auth_repository.dart';
import '../../../core/navigation/app_router.dart';
import '../../allnotes/views/all_notes_screen.dart';
import '../../createcallcarclecourse/views/create_call_circle_course.dart';
import '../../membermanager/views/membermanager.dart';
import '../../mycalls/views/mycalls.dart';
import 'my_profile.dart';

class ProfilePageScreen extends ConsumerWidget {
  const ProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    final isAdmin = permissions?.hasAdminPrivileges ?? false;
    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 75.h,
                decoration: BoxDecoration(color: Color(0xff023C7B)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/pngs/logo.png", height: 40.h),
                      Icon(Icons.menu, color: Colors.white, size: 28.sp),
                    ],
                  ),
                ),
              ),

              Gap(24.h),

              // ===== Profile Card =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff023C7B),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundImage: AssetImage("assets/pngs/profile.png"),
                      ),
                      Gap(14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Linda Hovitz",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isAdmin) ...[
                                Gap(8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.red, width: 1),
                                  ),
                                  child: Text(
                                    'ADMIN',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            "Facilitator",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                          if (isAdmin)
                            InkWell(
                              onTap: () => context.push(Routes.admin),
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings,
                                      size: 14.sp,
                                      color: const Color(0xff0082DF),
                                    ),
                                    Gap(4.w),
                                    Text(
                                      'Admin Portal',
                                      style: TextStyle(
                                        color: const Color(0xff0082DF),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Gap(10.h),

              // ===== Feature Grid =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileCardResuable(
                          image: 'assets/pngs/call.png',
                          title: 'My Calls',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MycallsScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileCardResuable(
                          image: 'assets/pngs/users.png',
                          title: 'My Call Circles',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCallCircleCourseScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileCardResuable(
                          image: 'assets/pngs/call.png',
                          title: 'Call Circle Manager',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallCircleManagerScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileCardResuable(
                          image: 'assets/pngs/users.png',
                          title: 'Member Manager',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberManagerScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileCardResuable(
                          image: 'assets/pngs/call.png',
                          title: 'All My Notes',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllNotesScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileCardResuable(
                          image: 'assets/pngs/users.png',
                          title: 'My Profile',
                          ontab: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCardResuable extends StatelessWidget {
  const ProfileCardResuable({
    super.key,
    required this.image,
    required this.title,
    required this.ontab,
  });

  final String image, title;
  final VoidCallback ontab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        height: 95.h,
        width: 175.w,
        decoration: BoxDecoration(
          color: const Color(0xff07468B),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 31, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(image, height: 28, width: 28),
              Gap(8.h),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
