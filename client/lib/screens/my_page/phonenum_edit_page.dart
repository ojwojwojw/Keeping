import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:keeping/widgets/render_field.dart';

Dio dio = Dio();

final _editPhoneKey = GlobalKey<FormState>();

class PhonenumEditPage extends StatefulWidget {
  const PhonenumEditPage({super.key});

  @override
  State<PhonenumEditPage> createState() => _PhonenumEditPageState();
}

class _PhonenumEditPageState extends State<PhonenumEditPage> {
  bool isButtonDisabled = true;
  TextEditingController _curUserPw = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _curUserPw.addListener(handleEditDisable);
    _phoneNumber.addListener(handleEditDisable);
    _curUserPw.addListener(handleEditDisable);
    _phoneNumber.addListener(handleEditDisable);
  }

  @override
  void dispose() {
    // `_curUserPw` 컨트롤러를 `editPhoneNumber()` 메서드 호출 이후에 해제합니다.
    _curUserPw.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  handleEditDisable() {
    if (_editPhoneKey.currentState != null &&
        _editPhoneKey.currentState!.validate()) {
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
      appBar: MyHeader(text: '휴대폰 번호 변경', elementColor: Colors.black),
      body: SingleChildScrollView(
        child: Form(
          key: _editPhoneKey,
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
                      controller: _curUserPw,
                      onChange: handleEditDisable(),
                    ),
                    renderPhoneNumberFormField(
                      label: '휴대폰',
                      hintText: '휴대폰 번호를 입력해주세요.',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                      controller: _phoneNumber,
                      onChange: handleEditDisable(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '휴대폰 번호 수정',
        isDisabled: isButtonDisabled,
        action: () {
          editPhoneNumber();
        },
      ),
    );
  }

  void editPhoneNumber() async {
    final data = {
      'phone': _phoneNumber.text,
      'loginPw': _curUserPw.text,
    };

    // `_curUserPw` 컨트롤러는 이미 해제되었으므로 `handleEditDisable()` 메서드를 호출할 필요가 없습니다.
    print(data);
    print('휴대폰 번호 수정');
  }
}
