import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_call/app_localizations.dart';
import 'package:money_call/controller/transaction_controller.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/utils/colors.dart';
import 'package:money_call/widgets/expenditure_card.dart';
import 'package:money_call/widgets/month_indicator.dart';
import 'package:provider/provider.dart';

class ExpendituresScreen extends StatefulWidget {
  final int activeIndex;
  final Function handleActiveIndex;
  const ExpendituresScreen(
      {Key? key, required this.activeIndex, required this.handleActiveIndex})
      : super(key: key);

  @override
  _ExpendituresScreenState createState() => _ExpendituresScreenState();
}

class _ExpendituresScreenState extends State<ExpendituresScreen>
    with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late final TabController _tabController;
  Map<String, double> _distInc = {},
      _distExp = {},
      _pastMonthInc = {},
      _pastMonthExp = {};
  late DateTime _activeDate;
  final DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _activeDate = DateTime(
        _date.year, _date.month + (widget.activeIndex - 11), _date.day);
    _tabController = TabController(length: 2, vsync: this);
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
    Map<String, double> tempExpCat =
        await TransactionController.getAmountByCategoryByMonth(_activeDate,
            isExpense: true);
    _pastMonthExp = await TransactionController.getAmountByCategoryByMonth(
        DateTime(_activeDate.year, _activeDate.month - 1),
        isExpense: true);

    Map<String, double> tempIncCat =
        await TransactionController.getAmountByCategoryByMonth(_activeDate,
            isExpense: false);
    _pastMonthInc = await TransactionController.getAmountByCategoryByMonth(
        DateTime(_activeDate.year, _activeDate.month - 1),
        isExpense: false);

    setState(() {
      _distInc = tempIncCat;
      _distExp = tempExpCat;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
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
                            .translate("Your Balances"),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(FontAwesomeIcons.fileInvoiceDollar, size: 32)
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
                            date: DateTime(
                                date.year, date.month + (index - 11), date.day),
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
          Material(
            color: isDark ? Colors.grey.shade800 : secondary.withOpacity(0.1),
            child: TabBar(
              controller: _tabController,
              indicatorColor: primary,
              tabs: [_buildTabIcon(false, isDark), _buildTabIcon(true, isDark)],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(controller: _tabController, children: [
              _distInc.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._distInc.keys.map((cat) {
                            return ExpenditureCard(
                              category: cat,
                              value: _distInc[cat]!,
                              pastValue: _pastMonthInc[cat] ?? 0,
                              isExpense: false,
                            );
                          }).toList()
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("No Income recorded this month"),
                        textAlign: TextAlign.center,
                      ),
                    ),
              _distExp.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._distExp.keys.map((cat) {
                            return ExpenditureCard(
                              category: cat,
                              value: _distExp[cat]!,
                              pastValue: _pastMonthExp[cat] ?? 0,
                              isExpense: true,
                            );
                          }).toList()
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("No Expenses recorded this month"),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ]),
          )
        ],
      ),
    );
  }

  Tab _buildTabIcon(bool isExpense, bool isDark) {
    return Tab(
        icon: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: isDark ? grey : Colors.white),
          child: Icon(
            isExpense ? FontAwesomeIcons.minus : FontAwesomeIcons.plus,
            color: isExpense ? expense : income,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          isExpense
              ? AppLocalizations.of(context)!.translate("Expenses")
              : AppLocalizations.of(context)!.translate("Income"),
          style: TextStyle(
            fontSize: 25,
            color: isExpense ? expense : income,
          ),
        )
      ],
    ));
  }
}
