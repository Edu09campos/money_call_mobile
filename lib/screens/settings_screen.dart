import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/language_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _dropdownValue = "pt";
  String _currencyValue = "€";

  final Divider _myDivider = const Divider(
    color: grey,
    thickness: 0.5,
    indent: 15,
    endIndent: 15,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dropdownValue = Provider.of<LanguageProvider>(context).localeCode;
    _currencyValue = Provider.of<CurrencyProvider>(context).sign;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor, body: _buildBody());
  }

  Widget _buildBody() {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: isDark ? darkGrey : Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 25, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("Settings"),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.settings_applications, size: 40)
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Change Language"),
                  style: TextStyle(
                      fontSize: 20,
                      color: isDark ? Colors.white : grey,
                      fontWeight: FontWeight.w500),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: isDark ? Colors.white : grey,
                    ),
                    elevation: 16,
                    style: TextStyle(
                        color: isDark ? Colors.white : grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                      });
                      final languageProvider =
                          Provider.of<LanguageProvider>(context, listen: false);
                      languageProvider.changeLocale(newValue!);
                    },
                    items: _buildOptions(),
                  ),
                ),
              ],
            ),
          ),
          _myDivider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Enable Dark Mode"),
                  style: TextStyle(
                      fontSize: 20,
                      color: isDark ? Colors.white : grey,
                      fontWeight: FontWeight.w500),
                ),
                FlutterSwitch(
                  width: 70.0,
                  height: 35.0,
                  valueFontSize: 15.0,
                  toggleSize: 25.0,
                  activeColor: primary,
                  inactiveColor: grey,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  value: isDark,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) async {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(val);
                  },
                ),
              ],
            ),
          ),
          _myDivider,
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Default Currency"),
                  style: TextStyle(
                      fontSize: 20,
                      color: isDark ? Colors.white : grey,
                      fontWeight: FontWeight.w500),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currencyValue,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: isDark ? Colors.white : grey,
                    ),
                    elevation: 16,
                    style: TextStyle(
                        color: isDark ? Colors.white : grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    onChanged: (String? newValue) {
                      setState(() {
                        _currencyValue = newValue!;
                      });
                      final currencyProvider =
                          Provider.of<CurrencyProvider>(context, listen: false);
                      currencyProvider.changeSign(newValue!);
                    },
                    items: _buildCurrencyOptions(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildOptions() {
    return const [
      DropdownMenuItem<String>(
        value: "pt",
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "🇵🇹",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      DropdownMenuItem<String>(
        value: "en",
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "🇬🇧",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    ];
  }

  List<DropdownMenuItem<String>> _buildCurrencyOptions() {
    return const [
      DropdownMenuItem<String>(
        value: "€",
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            FontAwesomeIcons.euroSign,
            size: 25,
          ),
        ),
      ),
      DropdownMenuItem<String>(
        value: "\$",
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            FontAwesomeIcons.dollarSign,
            size: 25,
          ),
        ),
      ),
      DropdownMenuItem<String>(
        value: "£",
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            FontAwesomeIcons.sterlingSign,
            size: 25,
          ),
        ),
      ),
    ];
  }
}
