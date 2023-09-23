import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';

class MissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> mission;
  const MissionDetailPage({required this.mission});

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '페이지 2',
        elementColor: Colors.black,
        icon: Icon(Icons.arrow_circle_up),
        // path: MissionPage(),
      ),
      body: Column(
        children: [
          Row(children: [
            Text(widget.mission["todo"] + '|'),
            Text(widget.mission["money"].toString() + '|'),
            Text(widget.mission["deadline"] + '|'),
            Text(widget.mission["completed"] + '|')
          ]),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '미션완료 승인하기',
        action: MissionPage(),
        isDisabled: false,
      ),
    );
  }
}
