import 'package:flutter/material.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/categories.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class ExpenditureCard extends StatefulWidget {
  final String category;
  final double value, pastValue;
  final bool isExpense;
  const ExpenditureCard(
      {Key? key,
      required this.category,
      required this.value,
      required this.pastValue,
      required this.isExpense})
      : super(key: key);

  @override
  _ExpenditureCardState createState() => _ExpenditureCardState();
}

class _ExpenditureCardState extends State<ExpenditureCard> {
  late Color _color;
  late String _differencePercentage;

  @override
  void initState() {
    super.initState();
    _color = getCategoryColor(widget.category);
    _differencePercentage = _getDifferencePercentage();
  }

  String _getDifferencePercentage() {
    if (widget.pastValue == 0) {
      return "";
    } else {
      if (widget.value - widget.pastValue < 0) {
        double decrease = widget.pastValue - widget.value,
            decreasePerc = (decrease / widget.pastValue) * 100;

        return decreasePerc.toStringAsFixed(0);
      } else {
        double increase = widget.value - widget.pastValue,
            increasePerc = (increase / widget.pastValue) * 100;

        return increasePerc.toStringAsFixed(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final currency = Provider.of<CurrencyProvider>(context).sign;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Card(
        color: isDark ? darkGrey : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          getCategoryIcon(widget.category),
                          size: 20,
                          color: _color,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                            AppLocalizations.of(context)!
                                .translate(widget.category),
                            style: TextStyle(
                              color: _color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: grey,
                        ),
                        children: [
                          _buildSignaler(),
                          TextSpan(
                            text: _differencePercentage,
                            style: TextStyle(
                                color: isDark ? Colors.white : grey,
                                fontSize: 10),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!
                                .translate(" from last month"),
                            style: TextStyle(
                                color: isDark ? Colors.white : grey,
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                  color: _color.withOpacity(0.4),
                ),
                Text("$currency${widget.value.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildSignaler() {
    if (widget.value - widget.pastValue < 0) {
      return TextSpan(
          text: widget.isExpense
              ? AppLocalizations.of(context)!.translate("Up ")
              : AppLocalizations.of(context)!.translate("Down "),
          style: TextStyle(
              color: widget.isExpense
                  ? Colors.red.withOpacity(0.5)
                  : Colors.green.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 10));
    } else if (widget.value - widget.pastValue > 0) {
      return TextSpan(
          text: widget.isExpense
              ? AppLocalizations.of(context)!.translate("Down ")
              : AppLocalizations.of(context)!.translate("Up "),
          style: TextStyle(
              color: widget.isExpense
                  ? Colors.green.withOpacity(0.5)
                  : Colors.red.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 10));
    } else {
      return TextSpan(
        text: AppLocalizations.of(context)!.translate("Equal "),
        style: TextStyle(
            color: Colors.yellow.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 10),
      );
    }
  }
}
