// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final double? textfieldHeight;
  final Color? fillColor;
  final Function(String?)? onChanged;

  const CustomTextFormField({
    super.key,
    required this.name,
    this.focusNode,
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.textInputAction,
    required this.validator,
    this.readOnly,
    this.prefixWidget,
    this.suffixWidget,
    this.obscureText,
    this.minLines,
    this.maxLines,
    this.fillColor,
    this.textfieldHeight,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: readOnly ?? false,
      child: FormBuilderTextField(
        readOnly: readOnly ?? false,
        name: name,
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText ?? false,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.error),
          ),
        ),
        keyboardType: textInputType,
        textInputAction: textInputAction,
        validator: validator,
      ),
    );
  }
}
