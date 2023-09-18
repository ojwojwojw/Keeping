import 'package:flutter/material.dart';
import 'package:keeping/screens/sample_code_page/sample_code_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import '../page1/page1.dart';
import '../page2/page2.dart';
import '../page3/page3.dart';
import '../mission_page/mission_page.dart';
import '../signup_page/signup_user_type_select_page.dart';
import '../login_page/login_page.dart';
import '../user_link_page/before_user_link_page.dart';
import '../my_page/my_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
          child: Column(
        children: [
          ConfirmBtn(
            text: '샘플코드',
            action: SampleCodePage(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MissionPage()));
            },
            child: const Text('미션페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(), // 회원가입 페이지로 이동
                ),
              );
            },
            child: const Text('회원가입'), // 회원가입 버튼 추가
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(), // 회원가입 페이지로 이동
                ),
              );
            },
            child: const Text('로그인'), // 로그인 페이지 이동 버튼 추가
          ),
        ],
      )),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MissionPage()));
            },
            child: const Text('미션페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(), // 회원가입 페이지로 이동
                ),
              );
            },
            child: const Text('회원가입'), // 회원가입 버튼 추가
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(), // 회원가입 페이지로 이동
                ),
              );
            },
            child: const Text('로그인'), // 로그인 페이지 이동 버튼 추가
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BeforeUserLinkPage(),
                ),
              );
            },
            child: const Text('유저 연결 페이지'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyPage(),
                ),
              );
            },
            child: Text('마이페이지'),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Page1()));
            },
            child: const Text('Page1!!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Page2()));
            },
            child: const Text('Page2!!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Page3()));
            },
            child: const Text('Page3!!'),
          )
        ],
      )),
    );
  }
}
