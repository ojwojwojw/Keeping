import 'package:flutter/material.dart';

class GradientBtn extends StatelessWidget {
  final Widget path;
  final String text;
  final Color beginColor;
  final Color endColor;
  final double fontSize;

  GradientBtn({
    super.key,
    required this.path,
    required this.text,
    required this.beginColor,
    required this.endColor,
    this.fontSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => path));
      },
      child: Container(
        alignment: Alignment.center,
        width: 170,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              beginColor,
              endColor
            ]
          ),
          borderRadius: BorderRadius.circular(25)
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}