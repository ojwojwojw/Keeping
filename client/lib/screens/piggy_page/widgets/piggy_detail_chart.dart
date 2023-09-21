import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PiggyDetailChart extends StatelessWidget {
  double balance;
  double goalMoney;

  PiggyDetailChart({
    super.key,
    required this.balance,
    required this.goalMoney,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: goalMoney,
      )
    );
  }
}