import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/routes/app_routes.dart';
import '../../config/theme/app_colors.dart';
import '../../core/constants/asset_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 347.h,
            left: 64.w,
            child: SizedBox(
              width: 313,
              height: 262,
              child: Image.asset(
                AssetConstants.logo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
