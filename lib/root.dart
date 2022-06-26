import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_call/provider/theme_provider.dart';
import 'package:money_call/screens/daily_screen.dart';
import 'package:money_call/screens/expenditures_screen.dart';
import 'package:money_call/screens/settings_screen.dart';
import 'package:money_call/screens/stats_screen.dart';
import 'package:money_call/utils/colors.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _index = 0,
      _activeIndexDailyTransactions = 13,
      _activeIndexExpenditures = 11,
      _activeIndexStats = 11;

  void _handleActiveIndexDailyTransactions(int index) {
    setState(() {
      _activeIndexDailyTransactions = index;
    });
  }

  void _handleActiveIndexExpenditures(int index) {
    setState(() {
      _activeIndexExpenditures = index;
    });
  }

  void _handleActiveIndexStats(int index) {
    setState(() {
      _activeIndexStats = index;
    });
  }

  void _selectTab(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return DailyScreen(
          activeIndex: _activeIndexDailyTransactions,
          handleActiveIndex: _handleActiveIndexDailyTransactions,
        );
      case 1:
        return StatsScreen(
          activeIndex: _activeIndexStats,
          handleActiveIndex: _handleActiveIndexStats,
        );
      case 2:
        return ExpendituresScreen(
          activeIndex: _activeIndexExpenditures,
          handleActiveIndex: _handleActiveIndexExpenditures,
        );
      case 3:
        return SettingsScreen();
      default:
        return DailyScreen(
          activeIndex: _activeIndexDailyTransactions,
          handleActiveIndex: _handleActiveIndexDailyTransactions,
        );
    }
  }

  Widget _buildBottomNavBar() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    List<IconData> iconItems = [
      Icons.calendar_month_rounded,
      Icons.bar_chart_rounded,
      Icons.account_balance_wallet_rounded,
      Icons.settings
    ];

    return AnimatedBottomNavigationBar(
        icons: iconItems,
        activeColor: primary,
        splashColor: secondary,
        inactiveColor: isDarkMode ? Colors.white : grey,
        backgroundColor: isDarkMode ? darkGrey : Colors.white,
        activeIndex: _index,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        rightCornerRadius: 10,
        iconSize: 33,
        onTap: (index) => _selectTab(index));
  }
}
