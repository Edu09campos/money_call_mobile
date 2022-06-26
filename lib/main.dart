import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/language_provider.dart';
import 'package:money_call/root.dart';
import 'package:money_call/user_preferences.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<LanguageProvider>(
            create: (_) => LanguageProvider()),
        ChangeNotifierProvider<CurrencyProvider>(
            create: (_) => CurrencyProvider())
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final languageProvider = Provider.of<LanguageProvider>(context);
        return MaterialApp(
          title: 'Money Call',
          themeMode: themeProvider.themeMode,
          theme: MyThemes.light,
          darkTheme: MyThemes.dark,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            // A class which loads the translations from JSON files
            AppLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            ...GlobalMaterialLocalizations.delegates,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('en'),
            Locale('pt'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          locale: languageProvider.locale,
          home: const Root(),
        );
      },
    );
  }
}
