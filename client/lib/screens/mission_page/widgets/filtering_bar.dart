import 'package:flutter/material.dart';

class FilteringBar extends StatelessWidget {
  const FilteringBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        width: 400,
        height: 20,
        color: Colors.blue,
        child: (Center(
          child: Text('필터링 바',
              style: TextStyle(color: Colors.white, fontSize: 10)),
        )));
  }
}
