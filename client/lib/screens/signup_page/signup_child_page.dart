import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpChildPage extends StatefulWidget {
  const SignUpChildPage({Key? key}) : super(key: key);

  @override
  _SignUpChildPageState createState() => _SignUpChildPageState();
}

class _SignUpChildPageState extends State<SignUpChildPage> {
  String idDupRes = ''; // 소스코드 결과 출력
  TextEditingController _userId = TextEditingController();
  TextEditingController _userPw = TextEditingController();
  TextEditingController _userPwCk = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _userBirth = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _parentPhoneNumber = TextEditingController();

  final _signupKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userId.dispose();
    _userPw.dispose();
    _userPwCk.dispose();
    _userName.dispose();
    _userBirth.dispose();
    _userPhoneNumber.dispose();
    _parentPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _signupKey,
          child: Column(
            children: [
              MyHeader(
                text: '부모가 회원 가입 중',
                elementColor: Colors.black,
                icon: Icon(Icons.arrow_circle_up),
                path: SignUpChildPage(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    userIdField(),
                    ElevatedButton(
                      onPressed: () async {
                        print('중복 체크 중');
                        // final response = await httpGet(
                        //     'https://api.example.com/member-service/id/$_userId');
                        // if (response != null) {
                        //   setState(() {
                        //     idDupRes = response.toString();
                        //   });
                        // } else {
                        //   setState(() {
                        //     idDupRes = '중복';
                        //   });
                        // }
                      },
                      child: Text('닉네임 중복 체크'),
                    ),
                    Text(idDupRes),
                    userPwField(),
                    userPwCkField(),
                    usernameField(),
                    userBirthField(),
                    parentPhoneNumberField(),
                    userPhoneNumberField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '회원가입부모',
        action: () {
          signUp();
        },
      ),
    );
  }

  Widget userIdField() {
    return BuildTextFormField(
      controller: _userId,
      labelText: '아이디',
      hintText: '아이디를 입력해주세요',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '아이디는 5글자 이상이 되어야 합니다.';
        } else if (value.length > 20) {
          return '아이디는 20글자 이하가 되어야 합니다.';
        } else if (!value.contains(RegExp(r'[a-zA-Z]'))) {
          return '아이디에는 영어가 1자 이상 포함되어야 합니다.';
        }
        return null;
      },
    );
  }

  Widget userPwField() {
    return BuildTextFormField(
      controller: _userPw,
      labelText: '비밀번호',
      hintText: '비밀번호를 입력해주세요',
      obscureText: true,
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
    );
  }

  Widget userPwCkField() {
    return BuildTextFormField(
      controller: _userPwCk,
      labelText: '비밀번호확인',
      hintText: '비밀번호를 한 번 더 입력해주세요.',
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '비밀번호는 5자 이상이 되어야 합니다';
        } else if (value.length > 25) {
          return '비밀번호는 25자 이하가 되어야 합니다.';
        } else if (value != _userPw.text) {
          return '비밀번호와 일치하지 않습니다.';
        }
        return null;
      },
    );
  }

  Widget usernameField() {
    return BuildTextFormField(
      controller: _userName,
      labelText: '이름',
      hintText: '이름을 입력해주세요.',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget userBirthField() {
    return BuildTextFormField(
      controller: _userBirth,
      labelText: '생년월일',
      hintText: 'YYYY-MM-DD',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget parentPhoneNumberField() {
    return BuildTextFormField(
      controller: _parentPhoneNumber,
      labelText: '부모님 휴대폰 번호',
      hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget userPhoneNumberField() {
    return BuildTextFormField(
      controller: _userPhoneNumber,
      labelText: '휴대폰 번호',
      hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Future<dynamic> httpGet(String url) async {
    try {
      var response = await http.get(
        Uri.parse(url),
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

  void signUp() {
    print('회원가입 함수까지 옵니다.');
    if (_signupKey.currentState!.validate()) {
      print('유효성 검사 통과');
    }
    String userId = _userId.text;
    String userPw = _userPw.text;
    String userPwCk = _userPwCk.text;
    String userName = _userName.text;
    String userBirth = _userBirth.text;
    String userPhoneNumber = _userPhoneNumber.text;
    // 여기서 회원가입 로직을 수행하세요.
  }
}
