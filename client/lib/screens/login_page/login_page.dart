import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
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
  String _loginResult = '로그인 안 된 상태';
  String _loginId = '';
  String _loginPw = '';

  void handleUserId(data) {
    setState(() {
      _loginId = data;
    });
  }

  void handleUserPw(data) {
    setState(() {
      _loginPw = data;
    });
  }

  handleLogin(result) {
    setState(() {
      _loginResult = result;
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
                      onChange: (val) {
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
                      onChange: (val) {
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
                    Text(_loginResult),
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

  Future<void> login(context, Function handleLogin) async {
    final data = {
      'loginId': _loginId,
      'loginPw': _loginPw,
    };
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/login',
        data: data,
      );
      if (response.statusCode == 200) {
        print('로그인에 성공했어요!');
        handleLogin('로그인 성공');
        final userData = json.decode(response.data.toString());
        context.read<UserInfoProvider>().login(userData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        print('로그인에 실패!');
        handleLogin('아이디 및 비밀번호를 확인해주세요.');
      }
    } catch (err) {
      print(err);
      handleLogin('아이디 및 비밀번호를 확인해주세요.');
    }
  }
}
