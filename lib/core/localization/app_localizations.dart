import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'My App',
      'welcome': 'Welcome',
      'todo_details': 'Todo Details',
      'completed': 'Completed',
      'pending': 'Pending',
      'retry': 'Retry'
    },
    'es': {
      'app_name': 'Mi Aplicación',
      'welcome': 'Bienvenido',
      'todo_details': 'Detalles de la tarea',
      'completed': 'Completado',
      'pending': 'Pendiente',
      'retry': 'rever'
    },
  };


  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}