import 'package:flutter/material.dart';

/// Supported locales for the app
class AppLocales {
  static const Locale en = Locale('en');
  static const Locale my = Locale('my');

  static const List<Locale> supportedLocales = [en, my];
  static const Locale fallbackLocale = en;
  static const String path = 'assets/translations';
}
