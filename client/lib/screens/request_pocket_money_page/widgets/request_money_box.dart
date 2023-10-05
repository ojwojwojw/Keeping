import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

Widget requestPocketMoneyBox(responseData, bool isParent, {String? childName}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Container(
      width: double.infinity,
      height: 150,
      decoration: roundedBoxWithShadowStyle(
        blurRadius: 1.5,
        bgColor: Color.fromARGB(255, 251, 250, 255),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/pocketmoney/request_money.png',
              height: 80, // 이미지의 높이
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
            Text(
              isParent ? '$childName' : '',
              style: TextStyle(
                color: const Color.fromARGB(255, 54, 54, 54),
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              isParent ? '이/가' : '용돈을 조를까요?',
              style: TextStyle(
                color: const Color.fromARGB(255, 54, 54, 54),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
    
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '10월 용돈 조른 횟수 : ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 54, 54, 54),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '$responseData',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 54, 54, 54),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '번',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 54, 54, 54),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget emptyBox() {
  return Container(
    width: 300,
    height: 150,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 251, 250, 255),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
        child: Text(
      '로딩 중...',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    )),
  );
}
