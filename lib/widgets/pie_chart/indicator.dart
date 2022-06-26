import 'package:flutter/material.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(context)!.translate(text),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : grey),
        )
      ],
    );
  }
}
