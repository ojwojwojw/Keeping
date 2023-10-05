import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/util/display_format.dart';

class CurrentBalance extends StatefulWidget {
  final num balance;

  CurrentBalance({
    super.key,
    required this.balance,
  });

  @override
  State<CurrentBalance> createState() => _CurrentBalanceState();
}

class _CurrentBalanceState extends State<CurrentBalance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Text('출금 가능액'),
            Text(formattedMoney(widget.balance))
          ],
        ),
      ),
    );
  }
}