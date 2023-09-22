import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/util/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';

import 'package:dio/dio.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
Dio dio = Dio();
final _loginKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginResult = '로그인 안 된 상태';
  String loginId = '';
  String loginPw = '';

  void handleUserId(data) {
    setState(() {
      loginId = data;
    });
  }

  void handleUserPw(data) {
    setState(() {
      loginPw = data;
    });
  }

  handleLogin(result) {
    setState(() {
      loginResult = result;
    });
  }

  @override
  //페이지를 초기에 접속하면 input 받는 컨트롤러 초기화
  void initState() {
    super.initState();
    _userId = TextEditingController();
    _userPw = TextEditingController();
  }

  // 페이지가 파기될 때 컨트롤러를 해제

  @override
  void dispose() {
    _userId.dispose();
    _userPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyHeader(
                text: '로그인',
                elementColor: Colors.black,
                icon: Icon(Icons.arrow_circle_up),
                path: LoginPage(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 20,
                    ),
                    renderTextFormField(
                      label: '아이디',
                      onSaved: (val) async {
                        String userId = val;
                        handleUserId(userId);
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                      controller: _userId,
                    ),
                    Container(
                      height: 20,
                    ),
                    renderTextFormField(
                      label: '비밀번호',
                      onSaved: (val) async {
                        String userPw = val;
                        handleUserPw(userPw);
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                      controller: _userPw,
                      isPassword: true,
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(loginResult),
                  ],
                ),
              ),

              //로그인 버튼
              ConfirmBtn(
                text: '로그인',
                action: () {
                  login(context, handleLogin);
                },
              ),
              Container(
                height: 20,
              ),
              //회원가입 버튼
              ConfirmBtn(
                text: '회원가입',
                action: SignUpPage(),
                textColor: const Color(0xFF8320E7),
                bgColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context, Function handleLogin) async {
    // 아이디와 비밀번호 값을 가져옴
    final data = {
      'loginId': loginId,
      'loginPw': loginPw,
    };
    print(data);
    print('수정한 곳');
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/login',
        data: data,
      );
      final jsonResponse = jsonDecode(response.toString());
      print(jsonResponse);
      if (response.data.resultStatus.successCode == 0) {
        // 로그인 성공
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        handleLogin('아이디 및 비밀번호를 확인해주세요.');
      }
    } catch (err) {
      handleLogin('아이디 및 비밀번호를 확인해주세요.');
      print(err);
    }
  }
}

// Future<void> login(BuildContext context, Function handleLogin) async {
//   String loginId = _userId.text;
//   String loginPw = _userPw.text;
//   final data = {
//     'loginId': loginId,
//     'loginPw': loginPw,
//   };
//   print(data);
//   try {
//     var response = await dio.post(
//       'http://j9c207.p.ssafy.io:8000/member-service/login',
//       data: data,
//     );
//     final jsonResponse = jsonDecode(response.toString());
//     print(jsonResponse);
//     if (response.data.resultStatus.successCode == 0) {
//       print(response.data.resultStatus.resultMessage);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MainPage(),
//         ),
//       );
//     } else {
//       handleLogin('아이디 및 비밀번호를 확인해주세요.');
//     }
//   } catch (err) {
//     handleLogin('아이디 및 비밀번호를 확인해주세요.');
//     print(err);
//   }
// }

// Widget userIdField() {
//   return BuildTextFormField(
//     controller: _userId,
//     labelText: '아이디',
//     hintText: '아이디를 입력해주세요',
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return '필수 항목입니다';
//       }
//       return null;
//     },
//   );
// }

// Widget userIdField() {
//   return renderTextFormField(
//     label: '아이디',
//     onSaved: (val) async {
//       // 아이디 필드 값 저장
//       String userId = val; // val은 입력 필드의 현재 값입니다.
//       print('아이디 저장: $userId');
//       handleUserId(val);
//     },
//     validator: (val) {
//       if (val.length < 1) {
//         return '아이디를 입력해주세요';
//       }
//       return null;
//     },
//     controller: _userId,
//   );
// }

// Widget userPwField() {
//   return renderTextFormField(
//     label: '비밀번호',
//     onSaved: (val) async {
//       String userPw = val;
//       // 비밀번호 필드 값 저장
//     },
//     validator: (val) {
//       if (val.length < 1) {
//         return '비밀번호를 입력해주세요';
//       }
//       return null;
//     },
//     controller: _userPw,
//     isPassword: true,
//   );
// }