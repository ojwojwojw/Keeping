import 'package:flutter/material.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
final _loginKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  children: [renderLoginText()],
                ),
              ),

              //로그인 버튼
              ConfirmBtn(
                text: '로그인',
                action: login,
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

// 초기 로그인 텍스트 렌더링
Widget renderLoginText() {
  return Column(
    children: [
      BuildTextFormField(
          controller: _userId,
          labelText: '아이디',
          hintText: '아이디를 입력해 주세요.',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          }),
      BuildTextFormField(
          controller: _userPw,
          labelText: '비밀번호',
          hintText: '비밀번호를 입력해 주세요.',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          })
    ],
  );
}

void login(BuildContext context) {
  String userId = _userId.text;
  String userPwd = _userPw.text;
  print('로그인 시도');
}

//로그인, 회원가입과 같이 유효성 검사가 필요한 곳에 사용하세요. form과 함께 사용하면 됩니다.
Widget BuildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required String? Function(String?) validator, // 유효성 검사시 이용
  bool obscureText = false, // 비밀번호와 같이 가려져야 하는 필드의 경우 true로 설정
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(labelText: labelText, hintText: hintText),
      ),
      SizedBox(
        height: 16.0,
      )
    ],
  );
}
