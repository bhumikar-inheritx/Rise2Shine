import 'package:flutter/material.dart';
import '../../config/routes/app_routes.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // List of routes for each bottom navigation item
  final List<String> _routes = [
    AppRoutes.homeRoute,
    AppRoutes.todoRoute,
    AppRoutes.homeRoute, // rewards - placeholder
    AppRoutes.homeRoute, // stats - placeholder
    AppRoutes.profileRoute,
  ];

  // Get route for a specific index
  String getRouteForIndex(int index) {
    if (index >= 0 && index < _routes.length) {
      return _routes[index];
    }
    return AppRoutes.homeRoute;
  }

  // Set current index and navigate
  void setCurrentIndex(int index, BuildContext context) {
    if (_currentIndex != index && index >= 0 && index < _routes.length) {
      _currentIndex = index;
      notifyListeners();
      
      // Navigate to the corresponding route
      final route = getRouteForIndex(index);
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => route.isFirst || route.settings.name == AppRoutes.homeRoute,
      );
    }
  }

  // Update index based on current route
  void updateIndexForRoute(String route) {
    final index = _routes.indexOf(route);
    if (index != -1 && _currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  // Reset to home
  void resetToHome() {
    _currentIndex = 0;
    notifyListeners();
  }
}
