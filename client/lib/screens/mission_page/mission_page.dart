import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/widgets/mission_box.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/mission_create_page/child_mission_create.dart';

import 'package:keeping/util/camera_test2.dart';
import 'package:keeping/util/ocr_test.dart';

import 'package:keeping/provider/counter_test.dart';
import 'package:keeping/provider/array_test.dart';

//전역변수들
final List<Map<String, dynamic>> missions = [
  {
    "id": 23,
    "todo": "설거지 하기",
    "money": 1500,
    "type": "PARENT",
    "deadline": "23.09.07",
    "completed": "YET"
  },
  {
    "id": 24,
    "todo": "두부 사오기",
    "money": 3500,
    "type": "PARENT",
    "deadline": "23.09.08",
    "completed": "COMPLETE"
  },
  {
    "id": 25,
    "todo": "안마하기",
    "money": 2000,
    "type": "PARENT",
    "deadline": "23.09.09",
    "completed": "LOADING"
  },
  {
    "id": 26,
    "todo": "설거지 하기",
    "money": 1500,
    "type": "PARENT",
    "deadline": "23.09.07",
    "completed": "YET"
  },
  {
    "id": 27,
    "todo": "두부 사오기",
    "money": 3500,
    "type": "PARENT",
    "deadline": "23.09.08",
    "completed": "YET"
  },
  {
    "id": 28,
    "todo": "안마하기",
    "money": 2000,
    "type": "PARENT",
    "deadline": "23.09.09",
    "completed": "YET"
  },
  {
    "id": 29,
    "todo": "설거지 하기",
    "money": 1500,
    "type": "PARENT",
    "deadline": "23.09.07",
    "completed": "YET"
  },
  {
    "id": 30,
    "todo": "두부 사오기",
    "money": 3500,
    "type": "PARENT",
    "deadline": "23.09.08",
    "completed": "YET"
  },
  {
    "id": 31,
    "todo": "안마하기",
    "money": 2000,
    "type": "PARENT",
    "deadline": "23.09.09",
    "completed": "YET"
  },
];

// 미션페이지 클래스
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissonPageState();
}

//미션페이지 스테이트 클래스
class _MissonPageState extends State<MissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyHeader(text: '용돈 미션', elementColor: Colors.black),
        body: SizedBox(
            child: Column(
          children: [
            CreateMissonBox(),
            SizedBox(
              height: 10,
            ),
            FilteringBar(),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      // return (Text('test'));
                      return Column(children: [
                        Text('미션명 들어갈 곳'),
                        MissionBox(mission: mission)
                      ]);
                    })),
            //이하 테스트 요소들///
            // cameraButton(context),
            // ocrButton(context),
            // prividerBtn(context),
            // arrayProviderBtn(context),
          ],
        )));
  }
}

//미션 박스들을 ListView로 출력하는 위젯//
// Widget missionBoxs() {
//   return
// }

// 미션을 생성페이지로 이동하는 박스//
class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(350.0, 150.0)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF8320E7)),
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (MissionCreatePage1()),
          ),
        );
      },
      child:
          (Center(child: Text('새로운 미션 만들기', style: TextStyle(fontSize: 20)))),
    );
  }
}

// /////////////////Test//////////////////////

// Camera 테스트로 이동하는 버튼
Widget cameraButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraTest(),
        ),
      );
    },
    child: const Text('cameraTest?'),
  );
}

// ocr test로 이동하는 버튼
Widget ocrButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OcrTest(),
        ),
      );
    },
    child: const Text('ocrTest?'),
  );
}

// 프로바이더(카운터) 테스트로 이동할 버튼 //
Widget prividerBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CounterTest(),
        ),
      );
    },
    child: const Text('provider(counter) test'),
  );
}

// 프로바이더(어레이) 테스트로 이동할 버튼 //
Widget arrayProviderBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArrayTest(),
        ),
      );
    },
    child: const Text('provider(array) test'),
  );
}

//필터링 바//
class FilteringBar extends StatelessWidget {
  const FilteringBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350,
        height: 20,
        color: Colors.purple,
        child: (Column(children: [
          Text('필터링 바', style: TextStyle(color: Colors.white, fontSize: 10)),
        ])));
  }
}
