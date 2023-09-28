import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
// import 'package:keeping/screens/mission_page/widgets/mission_box.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/mission_create_page/mission_create.dart';

// import 'package:keeping/util/camera_test2.dart';
// import 'package:keeping/util/ocr_test.dart';

// import 'package:keeping/provider/counter_test.dart';
// import 'package:keeping/provider/array_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

final _baseUrl = dotenv.env['BASE_URL'];

// 미션페이지 //
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissonPageState();
}

class _MissonPageState extends State<MissionPage> {
  List<Map<String, dynamic>> data = [
    {
      "childKey": "595d952c-16ed-408e-ba63-ef988d624fa5",
      "id": 3,
      "type": "PARENT",
      "todo": "학교생활잘마치기",
      "money": 2000,
      "cheeringMessage": "오늘도화이팅!",
      "childComment": null,
      "startDate": "2023-09-25",
      "endDate": "2023-09-30",
      "completed": "YET",
      "createdDate": "2023-09-27T05:18:22.797014"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 미션', elementColor: Colors.black),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            return Center(
              child: Column(
                children: [
                  CreateMissonBox(),
                  SizedBox(
                    height: 10,
                  ),
                  FilteringBar(),
                  missionData(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //미션 데이터를 리스트뷰로 랜더링 하는 위젯
  Widget missionData(data) {
    return (Expanded(
        child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final item = data[index];
        return InkWell(
          onTap: () {
            // 컨테이너를 탭했을 때 실행할 동작 정의

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MissionDetailPage(
                    item: item), // DetailPage는 새로운 페이지의 위젯입니다.
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
            decoration: BoxDecoration(
              color: item["completed"] == "CREATE_WAIT"
                  ? Color.fromRGBO(255, 170, 170, 1) // 연한 초록색, 채도 255
                  : Color.fromRGBO(170, 255, 170, 1), // 더 진한 초록색, 채도 255
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Text('#' + (index + 1).toString()),
                Text(
                  item["todo"],
                  style: TextStyle(
                    fontSize: 18.0, // 텍스트 크기 변경
                    fontWeight: FontWeight.bold, // 텍스트 굵게 만들기
                  ),
                ),
                SizedBox(height: 16.0), // 텍스트 사이에 간격 추가
                Text(
                  item["startDate"],
                  style: TextStyle(
                    fontSize: 8.0, // 텍스트 크기 변경
                    color: Colors.black, // 텍스트 색상 변경
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )));
  }
  //미션 데이터를 최초로 가져오는 비동기 요청

  Future<void> getData() async {
    // Dio 객체 생성
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;

    final dio = Dio();

    try {
      // GET 요청 보내기
      final response = await dio.get(
        "$_baseUrl/mission-service/api/$memberKey",
      );

      // 요청이 성공했을 때 처리
      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(response.data);
        print('Response data: $responseData');
        setState(() {
          data = responseData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
    }
  }
}

// 새로운 미션 생성 버튼//
class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(400.0, 150.0)),
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

//미션 상세조회 페이지//
class MissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const MissionDetailPage({super.key, required this.item});

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "미션상세조회"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "미션 이름:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["todo"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "금액:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["money"].toString(),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "응원 메시지:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["cheeringMessage"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "아이의 응답:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //// 자식의 메세지가 null이면 랜더링을 못한다
                widget.item["childComment"] != null
                    ? Text(
                        widget.item["childComment"],
                        style: TextStyle(fontSize: 16.0),
                      )
                    : SizedBox(),
                /////
                SizedBox(height: 10.0),
                Text(
                  "시작일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["startDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "종료일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["endDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "상태:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["completed"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "생성일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["createdDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//필터링 바//
class FilteringBar extends StatelessWidget {
  const FilteringBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 20,
        color: Colors.purple,
        child: (Column(children: [
          Text('필터링 바', style: TextStyle(color: Colors.white, fontSize: 10)),
        ])));
  }
}

// /////////////////Test//////////////////////

// Camera 테스트로 이동하는 버튼
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

// // 프로바이더(카운터) 테스트로 이동할 버튼 //
// Widget prividerBtn(BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CounterTest(),
//         ),
//       );
//     },
//     child: const Text('provider(counter) test'),
//   );
// }

// // 프로바이더(어레이) 테스트로 이동할 버튼 //
// Widget arrayProviderBtn(BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ArrayTest(),
//         ),
//       );
//     },
//     child: const Text('provider(array) test'),
//   );
// }
