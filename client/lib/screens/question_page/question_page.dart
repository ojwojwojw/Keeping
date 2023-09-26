import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문페이지',
      ),
      body: Column(
        children: [Text('질문페이지 내용')],
      ),
    );
  }
}
