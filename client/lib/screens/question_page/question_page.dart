import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';

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
        text: '질문 보내기',
      ),
      body: Column(
        children: [
          Text('받는사람'),
          Container(
            height: 50,
            width: 400,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white, // 배경색 설정
              border: Border.all(color: Color(0xFF8320E7)), // 테두리 설정
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '엄마',
                style: TextStyle(
                  fontSize: 20, // 텍스트 크기 설정
                  color: Colors.black, // 텍스트 색상 설정
                ),
              ),
            ),
          ),
          renderTextFormField(label: '질문내용'),
        ],
      ),
    );
  }
}
