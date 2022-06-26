import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_call/user_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = _initLocale();

  String get localeCode => _locale.languageCode;
  Locale get locale => _locale;

  void changeLocale(String local) async {
    await UserPreferences.setLocale(local);
    _locale = Locale(local);
    notifyListeners();
  }

  static Locale _initLocale() {
    String? local = UserPreferences.getLocale();

    if (local == null) {
      String sysLocal = Platform.localeName.split("_")[0];
      return Locale(sysLocal);
    } else {
      return Locale(local);
    }
  }
}
