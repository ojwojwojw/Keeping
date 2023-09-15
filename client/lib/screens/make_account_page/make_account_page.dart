import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

// 임시 통신 주소 로그인 키
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

// 계좌 만들기 첫 페이지
class MakeAccountPage extends StatelessWidget {
  MakeAccountPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '계좌 만들기'),
      body: Container(),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {goNext(context, TermsAndConditionsPage());},
      ),
    );
  }
}

// 애니메이션 효과 없이 다음 페이지로 이동하는 함수
void goNext(BuildContext context, Widget path) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        return path; //변경 필요
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    )
  );
}

// 약관 내용 있는 페이지
class TermsAndConditionsPage extends StatelessWidget {
  TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '계좌 만들기'),
      body: Container(
        child: Text('약관동의'),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {goNext(context, PhoneVerificationPage());},
      ),
    );
  }
}

TextEditingController _phoneNumber = TextEditingController();
TextEditingController _phoneVerification = TextEditingController();
final _loginKey = GlobalKey<FormState>();

// 번호 인증 페이지
class PhoneVerificationPage extends StatefulWidget {
  PhoneVerificationPage({super.key});

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  String result = '인증X';
  String verificationResult = '확인X';
  String makeAccountResult = '개설X';

  Widget authenticationBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
          'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/account/phone-check/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          {'phone': '010-7240-1318'}
        );
        if (response != null) {
          setState(() {
            result = response.toString();
          });
        } else {
          setState(() {
            result = '인증 실패';
          });
        }
      },
      style: authenticationBtnStyle(),
      child: Text('인증번호'),
    );
  }

  Widget verificationBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
          'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/account/phone-auth/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          {'code': '237362'}
        );  // 3분 30초
        if (response != null) {
          setState(() {
            verificationResult = response.toString();
          });
        } else {
          setState(() {
            verificationResult = '인증 실패';
          });
        }
      },
      style: authenticationBtnStyle(),
      child: Text('인증번호'),
    );
  }

  Widget makeAccountBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
          'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/account/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          {'authPassword': '123456'}
        );  // 3분 30초
        if (response != null) {
          setState(() {
            makeAccountResult = response.toString();
          });
        } else {
          setState(() {
            makeAccountResult = '개설 실패';
          });
        }
      },
      style: authenticationBtnStyle(),
      child: Text('개설하기'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '계좌 만들기'),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: renderPhoneNumberText()),
                      authenticationBtn(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(result),
                  Row(
                    children: [
                      Expanded(child: renderPhoneVerificationText()),
                      verificationBtn(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(verificationResult),
                  makeAccountBtn(),
                  Text(makeAccountResult)
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {},
      ),
    );
  }
}

Widget renderPhoneNumberText() {
  return BuildTextFormField(
    controller: _phoneNumber,
    labelText: '전화 번호',
    hintText: '전화 번호를 입력해 주세요.',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '전화 번호를 입력해 주세요.';
      }
      return null;
    }
  );
}
Widget renderPhoneVerificationText() {
  return BuildTextFormField(
    controller: _phoneVerification,
    labelText: '인증 번호',
    hintText: '인증 번호를 입력해 주세요.',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '인증 번호를 입력해 주세요.';
      }
      return null;
    }
  );
}

Widget BuildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required String? Function(String?) validator,
  bool obscureText = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText
        ),
      ),
      SizedBox(height: 16,)
    ],
  );
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
      Size(90, 40)
    )
  );
}

Future<dynamic> httpPost(String url, Map<String, String>? headers, Map<String, dynamic> body) async {
  try {
    var response = await http.post
      (Uri.parse(url), headers: headers, body: json.encode(body)
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print('HTTP Request Failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during HTTP request: $e');
    return null;
  }
}