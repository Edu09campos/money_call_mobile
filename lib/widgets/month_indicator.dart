import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_call/provider/language_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class MonthIndicator extends StatefulWidget {
  final DateTime date;
  final int index;
  final bool active;
  final Function handler;
  const MonthIndicator(
      {Key? key,
      required this.date,
      required this.index,
      required this.active,
      required this.handler})
      : super(key: key);

  @override
  _MonthIndicatorState createState() => _MonthIndicatorState();
}

class _MonthIndicatorState extends State<MonthIndicator> {
  late String _locale;

  @override
  void didChangeDependencies() {
    _locale = Provider.of<LanguageProvider>(context).localeCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return GestureDetector(
      onTap: () => widget.handler(widget.index),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 40) / 7,
        child: Column(
          children: [
            Text(
              widget.date.year.toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: widget.active ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: primary)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                child: Text(
                  DateFormat.MMM(_locale).format(widget.date).toLowerCase(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.active || isDark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
