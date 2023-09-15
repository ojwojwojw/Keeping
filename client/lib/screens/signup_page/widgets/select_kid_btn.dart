import 'package:flutter/material.dart';

class SelectKidBtn extends StatelessWidget {
  const SelectKidBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.purple[600],
      child: Text('자녀'),
      margin: EdgeInsets.all(10), // 마진 주기
    );
  }
}
