import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';

//오늘의 질문 페이지
class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(text: '', bgColor: Color(0xFF8320E7)),
      body: Center(
        child: Column(children: [
          Text(
            '오늘의 질문에 답해보세요',
            style: TextStyle(
              fontSize: 24, // 텍스트 크기 설정
              color: Colors.white, // 텍스트 색상 설정
            ),
          ),
          Container(
            width: 350,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white, // 배경색 설정
              border: Border.all(color: Colors.white, width: 2.0), // 테두리 설정
              borderRadius: BorderRadius.circular(10.0), // 테두리의 둥글기 설정
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // 그림자 색상 설정
                  spreadRadius: 5, // 그림자 크기 설정
                  blurRadius: 7, // 그림자 흐림 정도 설정
                  offset: Offset(0, 3), // 그림자의 위치 설정
                ),
              ],
            ),
            child: Column(children: [Text('날짜 데이터 나올곳'), Text('질문 내용 나올 곳 ')]),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionSendPage()));
              },
              child: Text('질문 생성하기')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QeustionAnswerPage()));
              },
              child: Text('질문 대답하기'))
        ]),
      ),
    );
  }
}

//질문 보내는 페이지
class QuestionSendPage extends StatefulWidget {
  const QuestionSendPage({super.key});

  @override
  State<QuestionSendPage> createState() => _QuestionSendPageState();
}

class _QuestionSendPageState extends State<QuestionSendPage> {
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
          renderTextFormField(label: '질문내용', hintText: '질문 내용을 입력하세요'),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '질문보내기',
        action: QuestionPage(),
        isDisabled: false,
      ),
    );
  }
}

//질문에 답하는 페이지
class QeustionAnswerPage extends StatefulWidget {
  const QeustionAnswerPage({super.key});

  @override
  State<QeustionAnswerPage> createState() => _QeustionAnswerPageState();
}

class _QeustionAnswerPageState extends State<QeustionAnswerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 답하기',
      ),
      body: Column(
        children: [
          Text('날짜 들어갈 곳'),
          Text('질문 내용 들어갈 곳'),
          renderTextFormField(label: '', hintText: '질문에 대해 어떻게 생각하시나요?'),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '등록하기',
        action: QuestionPage(),
        isDisabled: false,
      ),
    );
  }
}
