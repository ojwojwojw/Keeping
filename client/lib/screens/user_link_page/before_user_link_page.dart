import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';

TextEditingController _oppCode = TextEditingController();

class BeforeUserLinkPage extends StatefulWidget {
  const BeforeUserLinkPage({super.key});

  @override
  State<BeforeUserLinkPage> createState() => _UserLinkPageState();
}

class _UserLinkPageState extends State<BeforeUserLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyHeader(text: '연결하기', elementColor: Colors.black),
        MainDescriptionText('서로의 코드를 입력해주세요!'),
        Text('내 코드'),
        Text('api로 받아올 코드'),
        Text('상대방 코드'),
        opponentNumber(),
        ConfirmBtn(text: '연결하기', action: linkUser)
      ]),
    ));
  }
}

//상대방 코드를 넣어주는 필드
opponentNumber() {
  return Container(
    margin: EdgeInsets.fromLTRB(40, 20, 40, 20), // 좌우 마진 설정
    child: TextField(
      controller: _oppCode,
      decoration: InputDecoration(
        hintText: '전달받은 코드 입력',
      ),
    ),
  );
}

void linkUser(BuildContext context) {
  print('유저 연결... $_oppCode');
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const AfterUserLinkPage()));
}
