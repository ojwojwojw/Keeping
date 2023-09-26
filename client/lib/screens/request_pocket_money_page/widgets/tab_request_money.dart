import 'package:flutter/material.dart';

class TabRequestMoney extends StatelessWidget {
  final String name;

  TabRequestMoney({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        ClipOval(
          child: SizedBox(
            width: 60,
            height: 60,
          ),
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
