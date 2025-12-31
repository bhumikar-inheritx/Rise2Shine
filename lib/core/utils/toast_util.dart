import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../core/utils/extensions/widget_extension.dart';

class ToastUtils {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showToast(message, AppColors.successColor, AppColors.white);
  }

  static void showError(String message) {
    _showToast(message, AppColors.errorColor, AppColors.white);
  }

  static void showInfo(String message) {
    _showToast(message, AppColors.backgroundColor, AppColors.white);
  }

  static void _showToast(
      String message, Color backgroundColor, Color textColor) {
    key.currentState?.showSnackBar(
      SnackBar(
        content: message.textWidget(
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
