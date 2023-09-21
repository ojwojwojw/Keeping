import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';

TextEditingController _controller1 = TextEditingController();

//미션 생성페이지 1
class MissionCreatePage1 extends StatefulWidget {
  const MissionCreatePage1({Key? key}) : super(key: key);

  @override
  State<MissionCreatePage1> createState() => _MissionCreatePage1State();
}

class _MissionCreatePage1State extends State<MissionCreatePage1> {
  final _formKey = GlobalKey<FormState>();
  String? missionTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '미션생성'),
      body: Column(children: [
        SizedBox(
          height: 50,
        ),

        Text('아이에게 어떤 미션을 줘볼까요?'),

        // 입력 폼
        Form(
            child: Column(children: [
          TextFormField(
            decoration: InputDecoration(labelText: '미션제목을 입력해주세요'),
            validator: (value) {
              if (value?.isEmpty ?? false) {
                return '미션 제목을 입력해주세요.....';
              }
              return null;
            },
            onSaved: (String? value) {
              missionTitle = value;
            },
          )
        ])),

        SizedBox(
          height: 100,
        ),

        //달력 들어갈곳
        Text('미션 마감일을 정해줘요.'),
        ElevatedButton(onPressed: datePicker, child: Text('누르면 달력나와요')),

        // 다음 페이지로 가는 버튼
      ]),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: MissionCreatePage2(),
        isDisabled: false,
      ),
    );
  }

  DateTime dateValue = DateTime.now();
//데이트 피커
  Future datePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: new DateTime(2000),
        initialDate: new DateTime.now(),
        lastDate: new DateTime(2030));
    if (picked != null) setState(() => dateValue = picked);
  }
}

/////////////////////////////////////
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
        body: Column(children: [
          Text('성공하면 얼마를 줄까요?'),
        ]));
  }
}

//////////////////////////////
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
