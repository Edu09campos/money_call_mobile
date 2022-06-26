import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/language_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/categories.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatefulWidget {
  final String category, description;
  final DateTime date;
  final double amount;
  final bool isExpense;
  const TransactionCard(
      {Key? key,
      required this.category,
      required this.description,
      required this.date,
      required this.amount,
      required this.isExpense})
      : super(key: key);

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late String _locale;

  @override
  void didChangeDependencies() {
    _locale = Provider.of<LanguageProvider>(context).localeCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final currency = Provider.of<CurrencyProvider>(context).sign;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: isDark ? darkGrey : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: (size.width - 40) * 0.7,
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: const BoxDecoration(
                                color: grey, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                getCategoryIcon(widget.category),
                                size: 30,
                                color: getCategoryColor(widget.category),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: (size.width - 90) * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.description.isEmpty
                                      ? AppLocalizations.of(context)!
                                          .translate(widget.category)
                                      : widget.description,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${DateFormat.MMMEd(_locale).format(widget.date)} ${DateFormat.jm().format(widget.date)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                      child: Text(
                    "$currency${widget.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.isExpense ? expense : income),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
