import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kindomcall/core/theme/theme_extensions.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color buttonTextColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.buttonTextColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
          buttonColor ?? AppColors.primaryColor,
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 44.h)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: context.textTheme.bodyLarge!.copyWith(color: buttonTextColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
