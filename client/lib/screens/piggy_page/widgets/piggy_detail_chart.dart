import 'package:flutter/material.dart';
import 'package:keeping/util/display_format.dart';

class PiggyDetailChart extends StatelessWidget {
  final int balance;
  final int goalMoney;
  final DateTime createdDate;

  PiggyDetailChart({
    super.key,
    required this.balance,
    required this.goalMoney,
    required this.createdDate,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 50,
        child: Column(
          children: [
            _piggyChart(balance: balance, goalMoney: goalMoney),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formattedYMDDate(createdDate)} 시작', style: _piggyChartTextStyle()),
                Text(formattedMoney(goalMoney), style: _piggyChartTextStyle()),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _piggyChart({required int balance, required int goalMoney}) {
  return SizedBox(
    height: 10,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
        FractionallySizedBox(
          widthFactor: balance/goalMoney,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 112, 38, 186),
            ),
          ),
        )
      ],
    ),
  );
}

TextStyle _piggyChartTextStyle() {
  return TextStyle(
    color: Color.fromARGB(255, 31, 31, 31),
    fontSize: 12
  );
}