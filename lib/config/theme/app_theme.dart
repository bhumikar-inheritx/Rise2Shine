import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    // brightness: Brightness.light,
    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: AppColors.primaryColor,
    //   brightness: Brightness.light,
    // ),
    // Text Theme
    // textTheme: const TextTheme(
    //   displayLarge: TextStyle(
    //     fontSize: 32,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   displayMedium: TextStyle(
    //     fontSize: 28,
    //     // fontWeight: FontWeight.bold,
    //   ),
    //   bodyLarge: TextStyle(
    //     fontSize: 16,
    //     fontWeight: FontWeight.normal,
    //   ),
    //   bodyMedium: TextStyle(
    //     fontSize: 14,
    //     fontWeight: FontWeight.normal,
    //   ),
    // ),
    // Input Decoration
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: AppColors.surfaceColor,
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: BorderSide.none,
    //   ),
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: BorderSide.none,
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //     borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
    //   ),
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    // ),
    // // Button Theme
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // ),
  );

  static ThemeData darkTheme = lightTheme;
}
