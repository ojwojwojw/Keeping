import 'package:flutter/material.dart';
import 'package:keeping/util/build_text_form_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

TextEditingController _curUserPW = TextEditingController();
TextEditingController _editUserPw = TextEditingController();
TextEditingController _editUserPwCk = TextEditingController();
final _editPwKey = GlobalKey<FormState>();

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({super.key});

  @override
  State<PasswordEditPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<PasswordEditPage> {
  @override
  void initState() {
    super.initState();
    _curUserPW = TextEditingController();
    _editUserPw = TextEditingController();
    _editUserPwCk = TextEditingController();
  }

  @override
  void dispose() {
    _curUserPW.dispose();
    _editUserPw.dispose();
    _editUserPwCk.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _editPwKey,
          child: Column(
            children: [
              MyHeader(text: '비밀번호 변경', elementColor: Colors.black),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [renderPwdText()],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '비밀번호 수정',
        action: (BuildContext context) {
          if (_editPwKey.currentState!.validate()) {
            editPwd();
          }
        },
      ),
    );
  }
}

Widget renderPwdText() {
  return Column(
    children: [
      BuildTextFormField(
        controller: _curUserPW,
        labelText: '기존 비밀번호',
        hintText: '기존 비밀번호를 입력해주세요.',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
        obscureText: true,
      ),
      BuildTextFormField(
        controller: _editUserPw,
        labelText: '비밀번호',
        hintText: '수정할 비밀번호를 입력해주세요.',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          } else if (value.length < 5) {
            return '비밀번호는 5자 이상이 되어야 합니다';
          } else if (value.length > 25) {
            return '비밀번호는 25자 이하가 되어야 합니다.';
          }
          return null;
        },
        obscureText: true,
      ),
      BuildTextFormField(
        controller: _editUserPwCk,
        labelText: '비밀번호확인',
        hintText: '수정할 비밀번호를 한 번 더 입력해주세요.',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          } else if (value.length < 5) {
            return '비밀번호는 5자 이상이 되어야 합니다';
          } else if (value.length > 25) {
            return '비밀번호는 25자 이하가 되어야 합니다.';
          } else if (value != _editUserPw.text) {
            return '비밀번호와 일치하지 않습니다.';
          }
          return null;
        },
        obscureText: true,
      )
    ],
  );
}

void editPwd() {
  print('비밀번호 로직 실행 중');
}
