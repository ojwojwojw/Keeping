import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();

final _editPwKey = GlobalKey<FormState>();

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({super.key});

  @override
  State<PasswordEditPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<PasswordEditPage> {
  bool isButtonDisabled = true;
  TextEditingController _curUserPW = TextEditingController();
  TextEditingController _editUserPw = TextEditingController();
  TextEditingController _editUserPwCk = TextEditingController();

  @override
  void initState() {
    super.initState();

    // _curUserPW에 대한 리스너 등록
    _curUserPW.addListener(handleEditDisable);

    // _editUserPw에 대한 리스너 등록
    _editUserPw.addListener(handleEditDisable);

    // _editUserPwCk에 대한 리스너 등록
    _editUserPwCk.addListener(handleEditDisable);
  }

  @override
  void dispose() {
    _curUserPW.dispose();
    _editUserPw.dispose();
    _editUserPwCk.dispose();
    super.dispose();
  }

  handleEditDisable() {
    if (_editPwKey.currentState != null &&
        _editPwKey.currentState!.validate()) {
      // 유효성 검사 통과
      setState(() {
        isButtonDisabled = false;
      });
    } else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '비밀번호 변경', elementColor: Colors.black),
      body: SingleChildScrollView(
        child: Form(
          key: _editPwKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    renderTextFormField(
                      label: '기존 비밀번호',
                      hintText: '기존 비밀번호를 입력해주세요.',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                      isPassword: true,
                      controller: _curUserPW,
                      onChange: handleEditDisable(),
                    ),
                    renderTextFormField(
                      label: '비밀번호',
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
                      onChange: handleEditDisable(),
                      isPassword: true,
                      controller: _editUserPw,
                    ),
                    renderTextFormField(
                      label: '비밀번호확인',
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
                      onChange: handleEditDisable(),
                      isPassword: true,
                      controller: _editUserPwCk,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '비밀번호 수정',
        isDisabled: isButtonDisabled,
        action: () {
          editPwd();
        },
      ),
    );
  }

  void editPwd() async {
    final data = {
      'type': 'PARENT',
      'newLoginPw': _editUserPw.text,
      'oldLoginPw': _curUserPW.text,
    };

    try {
      var response = await dio
          .patch('/member-service/auth/api/member/{memberKey}', data: data);
      print(response);
    } catch (e) {
      print('Error: $e');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PasswordEditPage(),
  ));
}
