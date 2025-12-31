import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, AppRoutes.profileSelectionRoute);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SizedBox(
          child: Image.asset(
            'assets/icons/app_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
