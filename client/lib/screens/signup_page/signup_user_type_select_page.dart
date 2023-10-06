import 'package:flutter/material.dart';
import 'package:keeping/screens/signup_page/widgets/select_type_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'signup_child_page.dart';
import 'signup_parent_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 이 부분을 추가
          children: [
            MyHeader(
              text: '유형 선택',
              elementColor: Colors.black,
            ),
            SizedBox(height: 130,),
            Row(
              children:[
                SizedBox(width: 30,),
                selectText(),
              ]
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                SizedBox(width: 24,),
                SelectTypeBtn(path: SignUpParentPage(), name: '부모', text: '우리 아이 경제 교육!\n키핑으로 시작해요!', emoji: 'assets/image/profile/parent2_noBg.png'),
                SizedBox(width: 8,),

                SelectTypeBtn(path: SignUpChildPage(), name: '자녀', text: '어린이는 자녀로\n가입해주세요!', emoji: 'assets/image/profile/child2_noBg.png'),
                SizedBox(width: 24,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Text selectText() {
  String display = '회원가입 유형을\n선택해주세요.';
  TextStyle style = TextStyle(
    color: Colors.grey[800],
    fontSize: 25,
    fontWeight: FontWeight.bold
  );
  return Text(
    display,
    style: style,
  );
}


void _navigateToSignUpChildPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpParentPage()),
  );
}

void _navigateToSignUpParentPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpChildPage()),
  );
}
