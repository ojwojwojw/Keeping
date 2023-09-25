import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyRecordsDate extends StatefulWidget {
  final DateTime date;

  MoneyRecordsDate({
    super.key,
    required this.date
  });

  @override
  State<MoneyRecordsDate> createState() => _MoneyRecordsDateState();
}

class _MoneyRecordsDateState extends State<MoneyRecordsDate> {
  final formattedDate = DateFormat('M월 d일');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 360,
        child: Text(
          formattedDate.format(widget.date).toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),
        )  
      )
    );
  }
}