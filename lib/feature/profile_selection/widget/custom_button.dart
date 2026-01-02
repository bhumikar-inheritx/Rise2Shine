import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;

  const CustomButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.width,
      this.height,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: fontSize,
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
