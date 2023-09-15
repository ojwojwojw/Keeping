import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_detail_page/mission_detail_page.dart';

// 미션박스 클래스
class MissionBox extends StatefulWidget {
  final Map<String, dynamic> mission;
  MissionBox({required this.mission});
  @override
  State<MissionBox> createState() => _MissionBoxState();
}

// 미션박스 스테이트 클래스
class _MissionBoxState extends State<MissionBox> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MissionDetailPage(mission: widget.mission)));
      },
      child: Material(
        child: missionBox(widget.mission),
      ),
    );
  }
}

// 미션박스 하나를 보여주는 위젯
Widget missionBox(Map<String, dynamic> mission) {
  return Container(
      margin: EdgeInsets.all(20),
      width: 500,
      height: 100,
      color: Colors.blue,
      child: (Row(
        children: [
          Text(mission["id"].toString()),
          Text(mission["todo"]),
          Text(mission["money"].toString()),
          Text(mission["deadline"]),
          Text(mission["completed"]),
        ],
      )));
}
