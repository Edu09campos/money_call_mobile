import 'package:flutter/material.dart';
import 'package:money_call/utils/categories.dart';

import 'indicator.dart';

class ChartLegend extends StatefulWidget {
  final Map<String, double> categories;
  const ChartLegend({Key? key, required this.categories}) : super(key: key);

  @override
  _ChartLegendState createState() => _ChartLegendState();
}

class _ChartLegendState extends State<ChartLegend> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.categories.keys.map((exp) {
            return widget.categories[exp]!.abs() > 0.0
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Indicator(
                        color: getCategoryColor(exp),
                        text: exp,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                : Container();
          }).toList()
        ],
      ),
    );
  }
}
