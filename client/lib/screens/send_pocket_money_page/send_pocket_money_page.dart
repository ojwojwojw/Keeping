import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

class SendPocketMoneyPage extends StatefulWidget {
  const SendPocketMoneyPage({super.key});

  @override
  State<SendPocketMoneyPage> createState() => _SendPocketMoneyPageState();
}

class _SendPocketMoneyPageState extends State<SendPocketMoneyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 보내기',
      ),
      body: Container(),
      bottomNavigationBar: BottomBtn(text: '확인'),
    );
  }
}
