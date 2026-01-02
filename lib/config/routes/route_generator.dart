import 'package:flutter/material.dart';

import '../../feature/splash/splash_screen.dart';
import '../../feature/profile_selection/view/profile_selection.dart';
import '../../feature/signup/view/signup.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initialRoute:
      case AppRoutes.splashRoute:
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

      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Home Screen'),
            ),
          ),
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
