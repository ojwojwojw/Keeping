import 'package:flutter/material.dart';

// 메인페이지 배경 스타일
BoxDecoration bgStyle() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Color(0xFF1C0038),
        Color(0xFF401C64)
      ]
    )
  );
}

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