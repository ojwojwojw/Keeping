import 'package:flutter/material.dart';

Widget requestPocketMoneyBox() {
  return Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
      color: const Color(0xFF8320E7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '용돈을 요청하시겠어요?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              backgroundColor: Color(0xFF8320E7),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '남은 횟수 : 10번',
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
