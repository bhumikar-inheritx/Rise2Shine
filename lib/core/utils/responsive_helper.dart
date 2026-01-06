import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  // Screen breakpoints
  static bool isSmallScreen() => 1.sw < 375;
  static bool isMediumScreen() => 1.sw >= 375 && 1.sw < 768;
  static bool isLargeScreen() => 1.sw >= 768;

  // Responsive spacing
  static double spacing(double value) {
    if (isSmallScreen()) return (value * 0.8).w;
    if (isLargeScreen()) return (value * 1.2).w;
    return value.w;
  }

  // Responsive container width
  static double containerWidth() {
    if (isSmallScreen()) return 0.9.sw;
    if (isLargeScreen()) return 400.w;
    return 376.w;
  }

  // Safe padding for different screens
  static EdgeInsets safePadding() {
    return EdgeInsets.symmetric(
      horizontal: isSmallScreen() ? 16.w : 32.w,
      vertical: 24.h,
    );
  }
}