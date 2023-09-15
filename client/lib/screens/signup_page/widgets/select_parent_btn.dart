import 'package:flutter/material.dart';

class SelectParentBtn extends StatelessWidget {
  const SelectParentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.purple[400],
      child: Text('부모'),
      margin: EdgeInsets.all(10), // 마진 주기
    );
  }
}
