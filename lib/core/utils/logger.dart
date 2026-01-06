import 'package:flutter/foundation.dart';

class Logger {
  static void i(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }

  static void e(String message) {
    if (kDebugMode) {
      print('ERROR: $message');
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      print('WARNING: $message');
    }
  }
}
