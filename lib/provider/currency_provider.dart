import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_call/user_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencySign = _initSign();

  String get sign => _currencySign;

  IconData getIcon() {
    switch (_currencySign) {
      case "€":
        return FontAwesomeIcons.euroSign;
      case "\$":
        return FontAwesomeIcons.dollarSign;
      case "£":
        return FontAwesomeIcons.sterlingSign;
      default:
        return FontAwesomeIcons.euroSign;
    }
  }

  void changeSign(String sign) async {
    await UserPreferences.setSign(sign);
    _currencySign = sign;
    notifyListeners();
  }

  static String _initSign() {
    String? sign = UserPreferences.getSign();

    if (sign == null) {
      return "€";
    } else {
      return sign;
    }
  }
}
