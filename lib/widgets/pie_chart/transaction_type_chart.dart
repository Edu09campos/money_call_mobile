import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_call/utils/categories.dart';
import 'package:money_call/widgets/pie_chart/chart_legend.dart';

class TransactionTypeChart extends StatefulWidget {
  final Map<String, double> values;
  final double total;
  final bool isExpense;
  const TransactionTypeChart(
      {Key? key,
      required this.values,
      required this.total,
      required this.isExpense})
      : super(key: key);

  @override
  _TransactionTypeChartState createState() => _TransactionTypeChartState();
}

class _TransactionTypeChartState extends State<TransactionTypeChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: widget.isExpense
                        ? _showingExpensesSections(widget.values, widget.total)
                        : _showingIncomeSections(widget.values, widget.total)),
              ),
            ),
          ),
          ChartLegend(
            categories: widget.values,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingExpensesSections(
      Map<String, double> values, double total) {
    return List.generate(values.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (values.keys.elementAt(i)) {
        case "Bills":
          return _myPieChartSection("Bills", values, total, radius, fontSize);
        case "Car":
          return _myPieChartSection("Car", values, total, radius, fontSize);
        case "Clothes":
          return _myPieChartSection("Clothes", values, total, radius, fontSize);
        case "Travel":
          return _myPieChartSection("Travel", values, total, radius, fontSize);
        case "Food":
          return _myPieChartSection("Food", values, total, radius, fontSize);
        case "Health":
          return _myPieChartSection("Health", values, total, radius, fontSize);
        case "Shopping":
          return _myPieChartSection(
              "Shopping", values, total, radius, fontSize);
        case "House":
          return _myPieChartSection("House", values, total, radius, fontSize);
        case "Entertainment":
          return _myPieChartSection(
              "Entertainment", values, total, radius, fontSize);
        case "Phone":
          return _myPieChartSection("Phone", values, total, radius, fontSize);
        case "Pets":
          return _myPieChartSection("Pets", values, total, radius, fontSize);
        case "Other":
          return _myPieChartSection("Other", values, total, radius, fontSize);
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> _showingIncomeSections(
      Map<String, double> values, double total) {
    return List.generate(values.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (values.keys.elementAt(i)) {
        case "Business":
          return _myPieChartSection(
              "Business", values, total, radius, fontSize);
        case "Investments":
          return _myPieChartSection(
              "Investments", values, total, radius, fontSize);
        case "Extra Income":
          return _myPieChartSection(
              "Extra Income", values, total, radius, fontSize);
        case "Deposits":
          return _myPieChartSection(
              "Deposits", values, total, radius, fontSize);
        case "Lottery":
          return _myPieChartSection("Lottery", values, total, radius, fontSize);
        case "Gifts":
          return _myPieChartSection("Gifts", values, total, radius, fontSize);
        case "Salary":
          return _myPieChartSection("Salary", values, total, radius, fontSize);
        case "Savings":
          return _myPieChartSection("Savings", values, total, radius, fontSize);
        case "Rental Income":
          return _myPieChartSection(
              "Rental Income", values, total, radius, fontSize);
        case "Other":
          return _myPieChartSection("Other", values, total, radius, fontSize);
        default:
          throw Error();
      }
    });
  }

  PieChartSectionData _myPieChartSection(
      String category,
      Map<String, double> values,
      double total,
      double radius,
      double fontSize) {
    final double val = ((values[category]! / total) * 100).roundToDouble();
    return PieChartSectionData(
        color: getCategoryColor(category),
        value: val,
        title: '${val.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ));
  }
}
