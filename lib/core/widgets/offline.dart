import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kindomcall/core/theme/theme_extensions.dart';

import '../constants/app_colors.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // Assets.pngs.noInternetConnection.image(),
              const SizedBox(height: 40),
              Text(
                "Whoops!",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "No Internet Connection",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 50.h,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Check Connection",
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String noInternetDes =
      "No Internet connection was found. Check you connection or try again.";
}