import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';

class SignupContainer extends StatelessWidget {
  final List<Widget> children;

  const SignupContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 316,
      left: 32,
      child: Container(
        width: 376.w,
        height: 324.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
