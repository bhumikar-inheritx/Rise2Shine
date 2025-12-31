import 'dart:ui';

class LanguageConstants {
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'es'];

  static Locale getLocaleFromLanguageCode(String languageCode) {
    return Locale(languageCode);
  }
}