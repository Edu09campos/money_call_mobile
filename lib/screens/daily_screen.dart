import 'package:flutter/material.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/controller/transaction_controller.dart';
import 'package:money_call/models/transaction.dart';
import 'package:money_call/provider/currency_provider.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/screens/new_transaction_screen.dart';
import 'package:money_call/utils/colors.dart';
import 'package:money_call/widgets/day_indicator.dart';
import 'package:money_call/widgets/transaction_card.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatefulWidget {
  final int activeIndex;
  final Function handleActiveIndex;
  const DailyScreen(
      {Key? key, required this.activeIndex, required this.handleActiveIndex})
      : super(key: key);

  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  late List<Transaction> _transactions = [];
  late bool _isLoading;
  final ScrollController _controller = ScrollController();
  late DateTime _activeDate;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _activeDate =
        DateTime.now().subtract(Duration(days: (13 - widget.activeIndex)));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  @override
  void didChangeDependencies() {
    _refreshTransactions();
    super.didChangeDependencies();
  }

  double _calculateDailyValue() {
    return _transactions.fold(0, (double acc, Transaction t) => acc + t.amount);
  }

  Future _refreshTransactions() async {
    setState(() {
      _isLoading = true;
    });

    List<Transaction> temp =
        await TransactionController.getTransactionsByDay(_activeDate);

    setState(() {
      _transactions = temp;
      _isLoading = false;
    });

    _total = _calculateDailyValue();
  }

  void _setIndex(int index) {
    if (index != widget.activeIndex) {
      widget.handleActiveIndex(index);

      setState(() {
        _activeDate = DateTime.now().subtract(Duration(days: (13 - index)));
      });

      _refreshTransactions();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(),
    );
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
                        AppLocalizations.of(context)!
                            .translate("Daily Transactions"),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewTransactionScreen()))
                              .whenComplete(_refreshTransactions);
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                              color: primary, shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(Icons.add_rounded,
                                color: Colors.white, size: 35),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      _dailyScreenIcon()
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 57,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      itemCount: 14,
                      itemBuilder: (BuildContext context, int index) {
                        return DayIndicator(
                            date: DateTime.now()
                                .subtract(Duration(days: -index + 13)),
                            active: widget.activeIndex == index,
                            index: index,
                            handler: _setIndex);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _buildTransactions(isDark),
        ],
      ),
    );
  }

  Widget _dailyScreenIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.calendar_today_rounded, size: 32),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            DateTime.now().day.toString(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _buildTransactions(bool isDark) {
    final currency = Provider.of<CurrencyProvider>(context).sign;
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.673,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              )
            : _transactions.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!
                        .translate("No transactions today")),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ..._transactions.map((t) {
                          return TransactionCard(
                            category: t.category,
                            description: t.description,
                            date: t.createTime,
                            amount: t.amount,
                            isExpense: t.isExpense,
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("TOTAL",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : grey)),
                              const SizedBox(
                                width: 20,
                              ),
                              Text('$currency${_total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
  }
}
