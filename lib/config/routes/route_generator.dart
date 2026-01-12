import 'package:flutter/material.dart';

import '../../feature/add_child/view/add_your_child.dart';
import '../../feature/home/view/home.dart';
import '../../feature/profile_selection/view/profile_selection.dart';
import '../../feature/signup/view/forgot_password.dart';
import '../../feature/signup/view/otp_verification.dart';
import '../../feature/signup/view/signup.dart';
import '../../feature/splash/splash_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initialRoute || AppRoutes.splashRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.profileSelectionRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ProfileSelection(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

      case AppRoutes.signupRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Signup(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

      case AppRoutes.otpVerificationRoute:
        return MaterialPageRoute(
          builder: (_) => const OtpVerification(),
          settings: settings,
        );

      case AppRoutes.forgotPasswordRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ForgotPassword(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

      case AppRoutes.addChildRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AddYourChild(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

      case AppRoutes.homeRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page not found'),
          ),
        );
      },
    );
  }
}
