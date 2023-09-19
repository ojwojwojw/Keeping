import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';

class AfterUserLinkPage extends StatefulWidget {
  const AfterUserLinkPage({super.key});

  @override
  State<AfterUserLinkPage> createState() => _AfterUserLinkPageState();
}

class _AfterUserLinkPageState extends State<AfterUserLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyHeader(text: '연결하기', elementColor: Colors.black),
        MainDescriptionText('상대방의 연결을 기다리는 중입니다!'),
        watingOpponent(),
        Text('HH:MM:SS'),
        ConfirmBtn(text: '상대방에게 알려주기', action: noticeToUser),
        doNotice()
      ]),
    ));
  }
}

watingOpponent() {
  return Container(
    margin: EdgeInsets.all(16),
    child: Text(
      '연결까지 남은 시간',
      style: TextStyle(color: const Color(0xFF8320E7), fontSize: 20),
    ),
  );
}

doNotice() {
  return Container(
    margin: EdgeInsets.only(top: 25.0),
    child: Text(
      '남은 시간 안에 상대방도 연결을 완료해야 \n 계정 연결이 완료됩니다. \n 연결 신청한 사실을 상대방에게 알려주세요!',
      textAlign: TextAlign.center, // 가운데 정렬 설정
    ),
  );
}

noticeToUser(BuildContext context) {
  print('알려주는 중');
}
