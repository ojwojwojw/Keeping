import 'package:flutter/material.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
final _loginKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginResult = '로그인 안 된 상태';
  String userId = _userId.text;
  String userPw = _userPw.text;

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

  handleLogin(result) {
    setState(() {
      loginResult = result;
    });
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
                  children: [userIdField(), userPwField(), Text(loginResult)],
                ),
              ),

              //로그인 버튼
              ConfirmBtn(
                text: '로그인',
                action: () {
                  login(context, handleLogin);
                },
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
}

Future<void> login(BuildContext context, Function handleLogin) async {
  String userId = _userId.text;
  String userPw = _userPw.text;
  final response = await httpPost(
    '/member-service/login',
    null,
    {'loginId': userId, 'loginPw': userPw},
  );
  if (response != null) {
    handleLogin('성공');
  } else {
    handleLogin('실패');
  }
  print('로그인 시도');
}

Widget userIdField() {
  return BuildTextFormField(
    controller: _userId,
    labelText: '아이디',
    hintText: '아이디를 입력해주세요',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '필수 항목입니다';
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
      }
      return null;
    },
  );
}

Future<dynamic> httpPost(
    String url, Map<String, String>? headers, Map<String, dynamic> body) async {
  try {
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
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
