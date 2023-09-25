import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';

//미션 생성페이지 1
class MissionCreatePage1 extends StatefulWidget {
  const MissionCreatePage1({super.key});

  @override
  State<MissionCreatePage1> createState() => _MissionCreatePage1State();
}

class _MissionCreatePage1State extends State<MissionCreatePage1> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyHeader(text: '미션생성1'),
        body: Column(children: [
          Text('아이에게 어떤 미션을 줘볼까요?'),
          ConfirmBtn(action: MissionCreatePage2())
        ]));
  }
}

//미션 생성페이지 2
class MissionCreatePage2 extends StatefulWidget {
  const MissionCreatePage2({super.key});

  @override
  State<MissionCreatePage2> createState() => _MissionCreatePage2State();
}

class _MissionCreatePage2State extends State<MissionCreatePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyHeader(text: '미션생성2'),
        body: Column(children: [ConfirmBtn(action: MissionCreatePage3())]));
  }
}

//미션 생성페이지 3
class MissionCreatePage3 extends StatefulWidget {
  const MissionCreatePage3({super.key});

  @override
  State<MissionCreatePage3> createState() => _MissionCreatePage3State();
}

class _MissionCreatePage3State extends State<MissionCreatePage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyHeader(text: '미션생성3'),
        body: Column(children: [
          // ConfirmBtn(action: )
        ]));
  }
}
