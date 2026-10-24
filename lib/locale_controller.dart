import 'package:flutter/material.dart';

/// A temporary, session-only language preference. Null follows the device locale.
class LocaleController extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
