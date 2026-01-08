import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextAlign textAlign;
  final double? width;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 312.w,
      height: 51.h,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textAlign: textAlign,
        maxLength: maxLength,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
          suffixIcon: suffixIcon != null ? Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: suffixIcon,
          ) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide(
              width: 1.w,
              color: errorText != null ? Colors.red : AppColors.inputTextBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide(
              width: 1.w,
              color: errorText != null ? Colors.red : AppColors.inputTextBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
            borderSide: BorderSide(
              width: 1.w,
              color: errorText != null ? Colors.red : AppColors.primaryColor,
            ),
          ),
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        ),
      ),
    );
  }
}