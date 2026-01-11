import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? AppColors.white : AppColors.buttonColor,
          side: isOutlined
              ? BorderSide(color: AppColors.buttonColor, width: 1.w)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          disabledBackgroundColor: isOutlined 
              ? AppColors.white.withValues(alpha: 0.7)
              : AppColors.buttonColor.withValues(alpha: 0.7),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined ? AppColors.buttonColor : AppColors.white,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isOutlined ? AppColors.buttonColor : AppColors.white,
                  fontSize: fontSize,
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
