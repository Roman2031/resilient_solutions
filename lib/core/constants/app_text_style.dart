import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = "JosefinSans";

  /// Light theme text
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceLight,
    ),
    displayMedium: TextStyle(
      fontSize: 45.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceLight,
    ),
    displaySmall: TextStyle(
      fontSize: 36.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceLight,
    ),

    headlineLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceLight,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceLight,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
    ),

    titleLarge: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceLight,
    ),
    titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceLight,
    ),
    titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceLight,
    ),

    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceLight,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceLight,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceLight,
    ),

    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.primaryColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceLight70,
    ),
    labelSmall: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceLight,
    ),
  );

  /// Dark theme text
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),
    displayMedium: TextStyle(
      fontSize: 45.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),
    displaySmall: TextStyle(
      fontSize: 36.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),

    headlineLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceDark,
    ),

    titleLarge: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceDark,
    ),
    titleMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceDark,
    ),
    titleSmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceDark,
    ),

    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceDark,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceDark,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,

      color: AppColors.onSurfaceDark,
    ),

    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.primaryColor,
    ),
    labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceDark,
    ),
    labelSmall: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,

      color: AppColors.onSurfaceDark,
    ),
  );
}
