import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/screens/signup_page/widgets/signup_nickname_dupli.dart';
import 'package:keeping/util/build_text_form_field.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
TextEditingController _userPwCk = TextEditingController();
TextEditingController _userName = TextEditingController();
TextEditingController _userBirth = TextEditingController();
TextEditingController _userPhoneNumber = TextEditingController();
TextEditingController _parentPhoneNumber = TextEditingController();
// 폼의 상태 관리
final _signupKey = GlobalKey<FormState>();

class SignUpChildPage extends StatefulWidget {
  const SignUpChildPage({Key? key}) : super(key: key);

  @override
  _SignUpChildPageState createState() => _SignUpChildPageState();
}

class _SignUpChildPageState extends State<SignUpChildPage> {
  @override
  //페이지를 초기에 접속하면 input 받는 컨트롤러 초기화
  void initState() {
    super.initState();
    _userId = TextEditingController();
    _userPw = TextEditingController();
    _userPwCk = TextEditingController();
    _userName = TextEditingController();
    _userBirth = TextEditingController();
    _userPhoneNumber = TextEditingController();
    _parentPhoneNumber = TextEditingController();
  }
  // 페이지가 파기될 때 컨트롤러를 해제

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
                path: SignUpChildPage(),
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

// 회원가입에 필요한 요소들 호출
Widget renderSignupText() {
  return Column(
    children: [
      BuildTextFormField(
        controller: _userId,
        labelText: '아이디',
        hintText: '아이디를 입력해주세요.',
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
      ),
      NicknameDuplicateButton(
        onPressed: () {
          checkNicknameDup(_userId.text);
        },
      ),
      BuildTextFormField(
        controller: _userPw,
        labelText: '비밀번호',
        hintText: '비밀번호를 입력해주세요.',
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
      ),
      BuildTextFormField(
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
      ),
      BuildTextFormField(
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
      BuildTextFormField(
        controller: _userBirth,
        labelText: '생년월일',
        hintText: 'YYYY-MM-DD',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
      ),
      BuildTextFormField(
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
      BuildTextFormField(
        controller: _parentPhoneNumber,
        labelText: '부모님 휴대폰 번호',
        hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '필수 항목입니다';
          }
          return null;
        },
      ),
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
  print(userId);
}

@override
void dispose() {
  _userId.dispose();
  _userPw.dispose();
  _userPwCk.dispose();
  _userName.dispose();
  _userBirth.dispose();
  _userPhoneNumber.dispose();
}
