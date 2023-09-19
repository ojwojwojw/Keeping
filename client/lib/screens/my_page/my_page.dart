import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/my_page/select_theme_page.dart';
import 'package:keeping/screens/my_page/password_edit_page.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';
import 'package:keeping/screens/my_page/child_management_page.dart';

import 'package:keeping/widgets/bottom_modal.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '마이페이지', elementColor: Colors.black),
          selectThemeBtn(context),
          passwordEditBtn(context),
          phonenumEditBtn(context),
          childManageBtn(context),
          logoutBtn(context)
        ],
      ),
    );
  }
}

Widget selectThemeBtn(BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectThemePage()));
      },
      child: Text('테마 변경'));
}

Widget passwordEditBtn(BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PasswordEditPage()));
      },
      child: Text('비밀번호 변경'));
}

Widget phonenumEditBtn(BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PhonenumEditPage()));
      },
      child: Text('휴대폰 번호 변경'));
}

Widget childManageBtn(BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChildManagementPage()));
      },
      child: Text('자녀 관리'));
}

Widget logoutBtn(BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        pressLogoutBtn(context);
      },
      child: Text('로그아웃'));
}

void pressLogoutBtn(BuildContext context) {
  print('로그아웃 중');
  bottomModal(
    context: context,
    title: '로그아웃',
    content: logoutDescription(),
    button: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
      ],
    ),
  );
}

Widget logoutDescription() {
  return Text('정말 로그아웃 하시겠어요?');
}
