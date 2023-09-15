import 'package:flutter/material.dart';
import 'package:keeping/util/build_text_form_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  String curUserPw = _curUserPW.text;
  String edituserPw = _editUserPw.text;
  String editUserPwCk = _editUserPwCk.text;
  String result = '';

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
                  children: [
                    curUserPwField(),
                    editUserPwField(),
                    editUserPwCkField(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '비밀번호 수정',
        action: () {
          editPwd();
        },
      ),
    );
  }

  // 비밀번호 수정 로직이 들어갑니다.
  void editPwd() {
    if (_editPwKey.currentState!.validate()) {
      print('유효성 검사 통과');
    }
  }
}

Widget curUserPwField() {
  return BuildTextFormField(
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
  );
}

Widget editUserPwField() {
  return BuildTextFormField(
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
  );
}

Widget editUserPwCkField() {
  return BuildTextFormField(
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
  );
}

ButtonStyle authenticationBtnStyle() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )),
      fixedSize: MaterialStateProperty.all<Size>(Size(120, 40)));
}
