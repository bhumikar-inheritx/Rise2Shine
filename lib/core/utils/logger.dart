import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  late Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: kDebugMode ? Level.trace : Level.off,
    );
  }

  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.t(message, error: error, stackTrace: stackTrace);
  }

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.e(message, error: error, stackTrace: stackTrace);
  }
}
