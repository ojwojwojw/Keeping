import 'package:flutter/material.dart';

Widget MainDescriptionText(String text) {
  return Container(
    margin: EdgeInsets.fromLTRB(40, 30, 40, 20), // 좌우 및 상하 여백 설정
    child: Text(
      text,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
    ),
  );
}
