import 'package:flutter/material.dart';
import 'package:money_call/user_preferences.dart';
import 'package:money_call/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = _initThemeMode();

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    await UserPreferences.setDarkMode(isOn);
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static ThemeMode _initThemeMode() {
    if (UserPreferences.getDarkMode() == null) {
      return ThemeMode.light;
    } else {
      if (UserPreferences.getDarkMode()!) {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    }
  }
}

class MyThemes {
  static final dark = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(secondary: secondary));

  static final light = ThemeData(
      scaffoldBackgroundColor: background,
      backgroundColor: background,
      colorScheme: const ColorScheme.light(secondary: secondary));
}
