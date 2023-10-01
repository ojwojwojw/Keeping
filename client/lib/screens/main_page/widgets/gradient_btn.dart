import 'package:flutter/material.dart';
import 'package:keeping/widgets/rounded_modal.dart';

class GradientBtn extends StatelessWidget {
  final Widget path;
  final bool? hasAccount;
  final String text;
  final Color beginColor;
  final Color endColor;
  final double fontSize;

  GradientBtn({
    super.key,
    required this.hasAccount,
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
        if (hasAccount != null) {
          hasAccount! ? 
          Navigator.push(context, MaterialPageRoute(builder: (_) => path))
          : roundedModal(context: context, title: '계좌 개설 후에 이용하실 수 있습니다.');
        } else  {
          roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
        }
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