import 'package:flutter/material.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';
import 'package:keeping/screens/sample_code_page/utils/utils.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
final _loginKey = GlobalKey<FormState>();

class LoginSamplePage extends StatefulWidget {
  const LoginSamplePage({Key? key}) : super(key: key);

  @override
  _LoginSamplePageState createState() => _LoginSamplePageState();
}

class _LoginSamplePageState extends State<LoginSamplePage> {
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
                path: LoginSamplePage(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    userIdField(),
                    userPwField(),
                  ],
                ),
              ),

              //로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  print('로그인');
                  final response = await httpPost(
                    '/member-service/login',
                    null,
                    {'loginId': userId, 'loginPw': userPw},
                  );
                  if (response != null) {
                    setState(() {
                      loginResult = response.toString();
                    });
                  } else {
                    setState(() {
                      loginResult = '로그인 실패';
                    });
                  }
                },
                child: Text('로그인'),
                style: authenticationBtnStyle(),
              ),
              Text(loginResult),
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
      fixedSize: MaterialStateProperty.all<Size>(Size(90, 40)));
}
