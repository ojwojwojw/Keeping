import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/widgets/mission_box.dart';
import 'widgets/filtering_bar.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/mission_create_page/mission_create.dart';

// import '../../util/axios_test.dart';
// import 'package:keeping/util/camera_test2.dart';
// import 'package:keeping/util/ocr_test.dart';
// import 'package:keeping/util/ocr_test2.dart';
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
    "completed": "YET"
  },
  {
    "id": 25,
    "todo": "안마하기",
    "money": 2000,
    "type": "PARENT",
    "deadline": "23.09.09",
    "completed": "YET"
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
        appBar: MyHeader(text: '미션페이지!', elementColor: Colors.black),
        body: SizedBox(
            child: Column(
          children: [
            CreateMissonBox(),
            FilteringBar(),
            missionBoxs(),
            //이하 테스트 요소들///
            // axiosButton(context),
            // cameraButton(context),
            // ocrButton(context),
            // ocrButtonML(context),
            prividerBtn(context),
            arrayProviderBtn(context),
          ],
        )));
  }
}

//미션 박스들을 ListView로 출력하는 위젯//
Widget missionBoxs() {
  return Expanded(
      child: ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return MissionBox(mission: mission);
          }));
}

// 미션을 생성페이지로 이동하는 박스//
class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (MissionCreatePage1()),
          ),
        );
      },
      child: Container(
          margin: EdgeInsets.all(20),
          width: 400,
          height: 200,
          color: Colors.blue,
          child: (Center(child: Text('미션생성하기')))),
    );
  }
}








// /////////////////Test//////////////////////

// // Camera 테스트로 이동하는 버튼
// Widget cameraButton(BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CameraTest(),
//         ),
//       );
//     },
//     child: const Text('cameraTest?'),
//   );
// }

// // ocr test로 이동하는 버튼
// Widget ocrButton(BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OcrTest(),
//         ),
//       );
//     },
//     child: const Text('ocrTest?'),
//   );
// }

// // 구글 ML kit를 이용한 ocr test로 이동하는 버튼
// Widget ocrButtonML(BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MainScreen(),
//         ),
//       );
//     },
//     child: const Text('ocrTest using ML_kit'),
//   );
// }

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
