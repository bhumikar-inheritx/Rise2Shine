import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Helper method to check if a locale is supported
  bool isSupported(String languageCode) {
    return ['en', 'es'].contains(languageCode);
  }
}
