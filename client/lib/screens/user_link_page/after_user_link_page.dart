import 'dart:async';
import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_link.dart';

class AfterUserLinkPage extends StatefulWidget {
  const AfterUserLinkPage({super.key});

  @override
  State<AfterUserLinkPage> createState() => _AfterUserLinkPageState();
}

class _AfterUserLinkPageState extends State<AfterUserLinkPage> {
  int? _remainingTime; // 초기 남은 시간을 null로 설정
  late Timer _timer; // 타이머 변수
  String? _myCode;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // didChangeDependencies에서 _remainingTime 초기화
    _remainingTime =
        Provider.of<UserLinkProvider>(context, listen: false).expire;
    _myCode = Provider.of<UserLinkProvider>(context, listen: false).myCode;
    _startTimer(); // 타이머 시작
  }

  @override
  void dispose() {
    _timer.cancel(); // 페이지가 dispose될 때 타이머를 취소합니다.
    super.dispose();
  }

  // 타이머 시작 메서드
  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      // 1초마다 실행되는 코드
      if (_remainingTime! > 0) {
        setState(() {
          _remainingTime = _remainingTime! - 1;
        });
      } else {
        timer.cancel(); // 남은 시간이 0 이하로 떨어지면 타이머를 취소합니다.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '연결하기', elementColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainDescriptionText('상대방의 연결을 기다리는 중입니다!'),
            Column(
              children: [
                watingOpponent(),
                timer(),
                if (_myCode != null) myCodeWidget(),
                ConfirmBtn(
                  text: '상대방에게 알려주기',
                  action: noticeToUser,
                ),
                doNotice(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myCodeWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        '내 연결 코드 $_myCode',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timer() {
    if (_remainingTime == null) {
      // _remainingTime이 null인 경우 처리
      return CircularProgressIndicator();
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
        child: Text(
          formatSecondsToHHMMSS(_remainingTime!),
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8320E7)),
        ),
      );
    }
  }
}

String formatSecondsToHHMMSS(int seconds) {
  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$remainingSeconds';
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
      style: TextStyle(color: Colors.grey[700]),
    ),
  );
}

noticeToUser(BuildContext context) {
  print('알려주는 중');
}
