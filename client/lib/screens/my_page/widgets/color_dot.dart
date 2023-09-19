import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  final Color dotColor;
  const ColorDot({Key? key, required this.dotColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: dotColor, borderRadius: BorderRadius.circular(100)),
    );
  }
}
