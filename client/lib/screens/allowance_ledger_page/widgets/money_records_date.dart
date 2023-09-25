import 'package:flutter/material.dart';
import 'package:keeping/util/display_format.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 360,
        child: Text(
          formattedMDDate(widget.date),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),
        )  
      )
    );
  }
}