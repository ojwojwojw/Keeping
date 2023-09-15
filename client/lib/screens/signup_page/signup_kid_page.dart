import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/signup_page/widgets/signup_nickname_dupli.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
TextEditingController _userPwCk = TextEditingController();
TextEditingController _userName = TextEditingController();
TextEditingController _userBirth = TextEditingController();
TextEditingController _userPhoneNumber = TextEditingController();
TextEditingController _parentPhoneNumber = TextEditingController();
final _signupKey = GlobalKey<FormState>();

class SignUpKidPage extends StatefulWidget {
  const SignUpKidPage({Key? key}) : super(key: key);

  @override
  _SignUpKidPageState createState() => _SignUpKidPageState();
}

class _SignUpKidPageState extends State<SignUpKidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _signupKey,
          child: Column(
            children: [
              MyHeader(
                text: '자녀가 회원 가입 중',
                elementColor: Colors.black,
                icon: Icon(Icons.arrow_circle_up),
                path: SignUpKidPage(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [renderSignupText()],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '회원가입자녀',
        action: (BuildContext context) {
          //유효성 검사 전부 통과하면 회원가입
          if (_signupKey.currentState!.validate()) {
            signUp();
          }
        },
      ),
    );
  }
}

// 아래에서 호출한 요소들로 필드 만들기
Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  bool obscureText = false, // input 받을 때 가릴지 안 가릴지
  required String? Function(String?) validator, // 추가: 유효성 검사 함수
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(labelText: labelText, hintText: hintText),
        validator: validator,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
      ),
      SizedBox(
        height: 16.0,
      )
    ],
  );
}

// 회원가입에 필요한 요소들 호출
Widget renderSignupText() {
  return Column(
    children: [
      _buildTextField(
          controller: _userId,
          labelText: '아이디',
          hintText: '아이디를 입력해주세요',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          }),
      NicknameDuplicateButton(
        onPressed: () {
          checkNicknameDup(_userId.text);
        },
      ),
      _buildTextField(
          controller: _userPw,
          labelText: '비밀번호',
          hintText: '비밀번호를 입력해주세요.',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          }),
      _buildTextField(
          controller: _userPwCk,
          labelText: '비밀번호확인',
          hintText: '비밀번호를 한 번 더 입력해주세요.',
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          }),
      _buildTextField(
        controller: _userName,
        labelText: '이름',
        hintText: '이름을 입력해주세요.',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
      ),
      _buildTextField(
        controller: _userBirth,
        labelText: '생년월일',
        hintText: 'YYMMDD',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
      ),
      _buildTextField(
        controller: _userPhoneNumber,
        labelText: '휴대폰 번호',
        hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
      ),
      _buildTextField(
          controller: _parentPhoneNumber,
          labelText: '부모님 휴대폰 번호',
          hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다';
            }
            return null;
          }),
    ],
  );
}

//닉네임 중복 체크
void checkNicknameDup(String userId) {
  print('$userId 닉네임 중복 체크합시다!');
}

// 버튼을 누르면 실행되는 signup
void signUp() {
  print('회원가입 함수까지 옵니다.');
  String userId = _userId.text;
  String userPw = _userPw.text;
  String userPwCk = _userPwCk.text;
  String userName = _userName.text;
  String userBirth = _userBirth.text;
  String userPhoneNumber = _userPhoneNumber.text;
  String parentPhoneNumber = _parentPhoneNumber.text;
}
