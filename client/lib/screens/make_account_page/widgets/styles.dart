import 'package:flutter/material.dart';

// 계좌 정보 안에 쓰이는 버튼
ButtonStyle accountInfoRoundedBtn(double width, double height) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFC286FF)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(fontSize: 18)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    minimumSize: MaterialStateProperty.all<Size>(
      Size(width, height),
    ),
  );
}