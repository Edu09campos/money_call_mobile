import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  static const String _darkMode = "darkModeMoneyCall",
      _language = "languageMoneyCall",
      _currency = "currencyMoneyCall";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setDarkMode(bool isDark) async =>
      await _preferences.setBool(_darkMode, isDark);

  static Future setLocale(String local) async =>
      await _preferences.setString(_language, local);

  static Future setSign(String currency) async =>
      await _preferences.setString(_currency, currency);

  static bool? getDarkMode() => _preferences.getBool(_darkMode);

  static String? getLocale() => _preferences.getString(_language);

  static String? getSign() => _preferences.getString(_currency);
}
