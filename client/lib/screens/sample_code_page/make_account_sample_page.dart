import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

// 임시 통신 주소 로그인 키
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1OTQ3NTc3fQ.DCRGwyr_pSBSuyJA-21G8giFcozG9GVlD03fC9J6asU';

TextEditingController _phoneNumber = TextEditingController();
TextEditingController _phoneVerification = TextEditingController();

// 번호 인증 페이지
class MakeAccountSamplePage extends StatefulWidget {
  MakeAccountSamplePage({super.key});

  @override
  _MakeAccountSamplePageState createState() => _MakeAccountSamplePageState();
}

class _MakeAccountSamplePageState extends State<MakeAccountSamplePage> {
  String result = '인증X';
  String verificationResult = '확인X';
  String makeAccountResult = '개설X';

  Widget authenticationBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
          'https://14c6-121-178-98-20.ngrok-free.app/bank-service/account/phone-check/yoonyeji',
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
          'https://14c6-121-178-98-20.ngrok-free.app/bank-service/account/phone-auth/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          {'code': '237362'}
        );  // 3분 30초 지나면 다시 인증받아서 값 넣기
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
          'https://14c6-121-178-98-20.ngrok-free.app/bank-service/account/yoonyeji',
          {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          {'authPassword': '123456'}
        );  // 3분 30초 지나면 전화번호 인증부터 다시
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
      appBar: MyHeader(text: '계좌 만들기 '),
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