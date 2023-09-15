import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'widgets/select_kid_btn.dart';
import 'widgets/select_parent_btn.dart';
import 'signup_kid_page.dart';
import 'signup_parent_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(
            text: '유형 선택',
            elementColor: Colors.black,
            icon: Icon(Icons.arrow_circle_up),
            path: SignUpPage(),
          ),
          selectText(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬 추가
            children: [typeKidBtn(context), typeParentBtn(context)],
          ),
        ],
      ),
    );
  }
}

Text selectText() {
  String display = '회원가입 유형을 선택해주세요.';
  TextStyle style = TextStyle(
    color: Colors.grey,
    fontSize: 30.0,
  );
  return Text(
    display,
    style: style,
  );
}

Widget typeParentBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () => _navigateToSignUpParentPage(context),
    child: SelectParentBtn(),
  );
}

Widget typeKidBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () => _navigateToSignUpKidPage(context),
    child: SelectKidBtn(),
  );
}

void _navigateToSignUpKidPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpKidPage()),
  );
}

void _navigateToSignUpParentPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpParentPage()),
  );
}
