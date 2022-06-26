import 'package:flutter/material.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class StatCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String description;
  final double value;
  final bool small;
  const StatCard(
      {Key? key,
      required this.icon,
      required this.iconColor,
      required this.description,
      required this.value,
      this.small = false})
      : super(key: key);

  @override
  _StatCardState createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final currency = Provider.of<CurrencyProvider>(context).sign;
    return Padding(
      padding: widget.small
          ? const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5)
          : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 15.0, vertical: widget.small ? 5 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: widget.small ? 40 : 55,
                    height: widget.small ? 40 : 55,
                    decoration: BoxDecoration(
                        color: widget.iconColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: widget.small ? 20 : 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                        fontSize: widget.small ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : grey),
                  ),
                ],
              ),
              Text(
                "$currency${widget.value.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: widget.small ? 20 : 25,
                    fontWeight: FontWeight.bold,
                    color: getValueColor(widget.value)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Color getValueColor(double value) {
  if (value > 0) {
    return Colors.green;
  } else if (value < 0) {
    return Colors.red;
  } else {
    return netBalance;
  }
}
