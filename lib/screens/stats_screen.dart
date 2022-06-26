import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/controller/transaction_controller.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:money_call/widgets/month_indicator.dart';
import 'package:money_call/widgets/stat_card.dart';
import 'package:money_call/widgets/pie_chart/transaction_type_chart.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatefulWidget {
  final int activeIndex;
  final Function handleActiveIndex;
  const StatsScreen(
      {Key? key, required this.activeIndex, required this.handleActiveIndex})
      : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final ScrollController _controller = ScrollController();
  late bool _isLoading, _isEmpty;
  late DateTime _activeDate;
  final DateTime _date = DateTime.now();
  double _monthTotalExpenses = 0, _monthTotalIncome = 0;
  Map<String, double> _distInc = {}, _distExp = {};

  final SizedBox _mySpacer = const SizedBox(
    height: 15,
  );

  @override
  void initState() {
    super.initState();
    _activeDate = DateTime(
        _date.year, _date.month + (widget.activeIndex - 11), _date.day);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  @override
  void didChangeDependencies() {
    _refreshCards();
    super.didChangeDependencies();
  }

  Future _refreshCards() async {
    setState(() {
      _isLoading = true;
    });

    double tempEx = await TransactionController.getTypeTotalByMonth(_activeDate,
        isExpense: true);
    double tempIn = await TransactionController.getTypeTotalByMonth(_activeDate,
        isExpense: false);

    Map<String, double> tempExpCat =
        await TransactionController.getAmountByCategoryByMonth(_activeDate,
            isExpense: true);
    Map<String, double> tempIncCat =
        await TransactionController.getAmountByCategoryByMonth(_activeDate,
            isExpense: false);

    setState(() {
      _distInc = tempIncCat;
      _distExp = tempExpCat;
      _isEmpty = _distInc.isEmpty && _distExp.isEmpty;
      _monthTotalExpenses = tempEx;
      _monthTotalIncome = tempIn;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _setIndex(int index) {
    if (index != widget.activeIndex) {
      widget.handleActiveIndex(index);

      setState(() {
        _activeDate =
            DateTime(_date.year, _date.month + (index - 11), _date.day);
      });

      _refreshCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration:
                  BoxDecoration(color: isDark ? darkGrey : Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 60, bottom: 25, right: 20, left: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Your Stats"),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(FontAwesomeIcons.chartLine, size: 32)
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
                        itemCount: 12,
                        itemBuilder: (BuildContext context, int index) {
                          DateTime date = DateTime.now();
                          return MonthIndicator(
                              date: DateTime(date.year,
                                  date.month + (index - 11), date.day),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.673,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _mySpacer,
                          _isEmpty
                              ? Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                        "No transactions this month"),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Column(
                                  children: [
                                    StatCard(
                                      icon: FontAwesomeIcons.plusMinus,
                                      iconColor: netBalance,
                                      description: AppLocalizations.of(context)!
                                          .translate("Net Balance"),
                                      value: (_monthTotalIncome +
                                          _monthTotalExpenses),
                                    ),
                                    StatCard(
                                        icon: FontAwesomeIcons.plus,
                                        iconColor: income,
                                        description:
                                            AppLocalizations.of(context)!
                                                .translate("Income"),
                                        value: _monthTotalIncome,
                                        small: true),
                                    StatCard(
                                        icon: FontAwesomeIcons.minus,
                                        iconColor: expense,
                                        description:
                                            AppLocalizations.of(context)!
                                                .translate("Expenses"),
                                        value: _monthTotalExpenses,
                                        small: true),
                                  ],
                                ),
                          _mySpacer,
                          _buildIncomesChart(isDark),
                          _mySpacer,
                          _buildExpensesChart(isDark),
                          _mySpacer,
                        ],
                      ),
                    ),
            )
          ],
        ));
  }

  Widget _buildExpensesChart(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 340,
        decoration: BoxDecoration(
          color: isDark ? darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .translate("Expenses Distribution"),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : grey),
              ),
              _distExp.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!
                            .translate("No Expenses data")),
                      ),
                    )
                  : TransactionTypeChart(
                      values: _distExp,
                      total: _monthTotalExpenses,
                      isExpense: true,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomesChart(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 340,
        decoration: BoxDecoration(
          color: isDark ? darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("Income Distribution"),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : grey),
              ),
              _distInc.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!
                            .translate("No Income data")),
                      ),
                    )
                  : TransactionTypeChart(
                      values: _distInc,
                      total: _monthTotalIncome,
                      isExpense: false,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
