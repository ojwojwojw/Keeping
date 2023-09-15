import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/widgets/header.dart';

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
      body: Column(
        children: [
          MyHeader(
            text: '페이지 2',
            elementColor: Colors.black,
            icon: Icon(Icons.arrow_circle_up),
            // path: MissionPage(),
          ),
          Container(
              width: 500,
              height: 100,
              color: Colors.blue,
              child: Text(widget.mission["id"].toString())),
          Container(
              margin: EdgeInsets.all(5),
              width: 500,
              height: 100,
              color: Colors.blue,
              child: Text(widget.mission["todo"])),
          Container(
              margin: EdgeInsets.all(5),
              width: 500,
              height: 100,
              color: Colors.blue,
              child: Text(widget.mission["money"].toString())),
          Container(
              margin: EdgeInsets.all(5),
              width: 500,
              height: 100,
              color: Colors.blue,
              child: Text(widget.mission["deadline"])),
          Container(
              margin: EdgeInsets.all(5),
              width: 500,
              height: 100,
              color: Colors.blue,
              child: Text(widget.mission["completed"])),
        ],
      ),
    );
  }
}
