import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_routes.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/services/passcode_service.dart';
import '../signup/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStateAndNavigate();
  }

  Future<void> _checkLoginStateAndNavigate() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    try {
      // Get AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Check login state from SharedPreferences
      bool isLoggedIn = await authProvider.checkLoginState();

      if (!mounted) return;

      // Navigate based on login state
      if (!mounted) return;
      
      if (isLoggedIn) {
        // Check if passcode is set
        final isPasscodeSet = await PasscodeService.isPasscodeSet();
        
        if (!mounted) return;
        
        if (isPasscodeSet) {
          // Always show passcode entry screen even if session is valid
          print('ℹ️ SplashScreen: User is logged in, navigating to passcode entry');
          Navigator.pushReplacementNamed(context, AppRoutes.passcodeEntryRoute);
        } else {
          print('ℹ️ SplashScreen: User is logged in but passcode not set, navigating to signup');
          Navigator.pushReplacementNamed(context, AppRoutes.signupRoute);
        }
      } else {
        print('ℹ️ SplashScreen: User is not logged in, navigating to signup');
        Navigator.pushReplacementNamed(context, AppRoutes.signupRoute);
      }
    } catch (e) {
      print('❌ SplashScreen: Error checking login state - $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.signupRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
