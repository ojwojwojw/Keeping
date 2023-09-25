import 'package:flutter/material.dart';
import 'package:keeping/screens/sample_code_page/login_sample_page.dart';
import 'package:keeping/screens/sample_code_page/make_account_sample_page.dart';
import 'package:keeping/screens/sample_code_page/make_piggy_sample_page.dart';
import 'package:keeping/screens/sample_code_page/signup_sample_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';

class SampleCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ConfirmBtn(
            text: '회원가입',
            action: SignupSamplePage(),
          ),
          SizedBox(
            height: 20,
          ),
          ConfirmBtn(
            text: '로그인',
            action: LoginSamplePage(),
          ),
          SizedBox(
            height: 20,
          ),
          ConfirmBtn(
            text: '계좌 만들기',
            // action: MakeAccountSamplePage(),
          ),
          SizedBox(
            height: 20,
          ),
          ConfirmBtn(
            text: ' 저금통 만들기',
            action: MakePiggySamplePage(),
          ),
        ],
      ),
    );
  }
}
