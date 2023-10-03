import 'package:flutter/material.dart';

Widget requestPocketMoneyBox(responseData, bool isParent, {String? childName}) {
  return Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
      color: Color(0xFF8320E7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isParent && childName != null ? '$childName는' : '용돈을 조를까요?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              backgroundColor: Color(0xFF8320E7),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '이번 달에 $responseData번의 \n 용돈을 졸랐어요!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              backgroundColor: Color(0xFF8320E7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget emptyBox() {
  return Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
      color: Color(0xFF8320E7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
        child: Text(
      '로딩 중...',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        backgroundColor: Color(0xFF8320E7),
      ),
    )),
  );
}
