import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_call/provider/language_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class DayIndicator extends StatefulWidget {
  final DateTime date;
  final int index;
  final bool active;
  final Function handler;
  const DayIndicator(
      {Key? key,
      required this.date,
      required this.index,
      required this.active,
      required this.handler})
      : super(key: key);

  @override
  _DayIndicatorState createState() => _DayIndicatorState();
}

class _DayIndicatorState extends State<DayIndicator> {
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
              DateFormat.E(_locale).format(widget.date),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: widget.active ? primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: primary)),
              child: Center(
                child: Text(
                  widget.date.day.toString(),
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
