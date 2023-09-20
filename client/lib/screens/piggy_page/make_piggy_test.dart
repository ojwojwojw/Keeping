import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/util/http_method.dart';
import 'package:keeping/widgets/header.dart';

// 임시 통신 주소 로그인 키
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

class MakePiggyTest extends StatefulWidget {
  MakePiggyTest({super.key});

  @override
  _MakePiggyTestState createState() => _MakePiggyTestState();
}

class _MakePiggyTestState extends State<MakePiggyTest> {
  String result = '생성X';

  Widget makePiggyBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
          'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/piggy/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data'
          },
          {
            "content": "아디다스 삼바 내꺼야",
            "goalMoney": 140000,
            "authPassword": "123456",
            // "uploadImage": adidas.png
          }
        );
        if (response != null) {
          setState(() {
            result = response.toString();
          });
        } else {
          setState(() {
            result = '생성 실패';
          });
        }
      },
      style: authenticationBtnStyle(),
      child: Text('저금통 만들기'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '저금통 만들기'),
      body: makePiggyBtn(),
    );
  }
}

ButtonStyle authenticationBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      Size(180, 40)
    )
  );
}