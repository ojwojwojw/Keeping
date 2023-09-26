import 'package:flutter/material.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:dio/dio.dart';
import 'package:keeping/screens/question_page/question_page.dart';

class ChildDiaryPage extends StatefulWidget {
  ChildDiaryPage({super.key});

  List<Map<String, dynamic>> data = [
    {
      "id": 0,
      "content": "만원이 있다면 뭘 하고 싶나요?",
      "parentAnswer": "test_f801c7f4f8fa",
      "childAnswer": "test_def51ba140c7",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 1,
      "content": "내가 성공할 수 있는 사업이 있다면",
      "parentAnswer": "test_f801c7f4f8fa",
      "childAnswer": "test_def51ba140c7",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 2,
      "content": "대출에 대해서 어떻게 생각하세요?",
      "parentAnswer": "test_f801c7f4f8fa",
      "childAnswer": "test_def51ba140c7",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 3,
      "content": "적금은 얼마나 드는게 좋을까요? ",
      "parentAnswer": "test_f801c7f4f8fa",
      "childAnswer": "test_def51ba140c7",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 4,
      "content": "은행하면 가장 먼저 떠오르는 것은?",
      "parentAnswer": "test_f801c7f4f8fa",
      "childAnswer": "test_def51ba140c7",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
  ];

  @override
  State<ChildDiaryPage> createState() => _ChildDiaryPageState();
}

class _ChildDiaryPageState extends State<ChildDiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리',
        bgColor: Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            ///일기 데이터 띄울 곳
            Expanded(
                child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.data[index];
                return InkWell(
                  onTap: () {
                    // 컨테이너를 탭했을 때 실행할 동작 정의

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChildDiaryDetailPage(), // DetailPage는 새로운 페이지의 위젯입니다.
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0), // 여백 추가
                    margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
                    decoration: BoxDecoration(
                      color: Colors.white, // 하얀색 배경
                      borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 만들기
                    ),
                    child: Column(
                      children: [
                        Text('#' + (index + 1).toString()),
                        Text(
                          item["content"],
                          style: TextStyle(
                            fontSize: 18.0, // 텍스트 크기 변경
                            fontWeight: FontWeight.bold, // 텍스트 굵게 만들기
                          ),
                        ),
                        SizedBox(height: 16.0), // 텍스트 사이에 간격 추가
                        Text(
                          item["createdDate"],
                          style: TextStyle(
                            fontSize: 8.0, // 텍스트 크기 변경
                            color: Colors.grey, // 텍스트 색상 변경
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF6B20D7), // 짙은 보라색 배경
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (QuestionSendPage()),
                  ),
                );
              },
              child: (Center(
                  child: Text('새로운 미션 만들기', style: TextStyle(fontSize: 20)))),
            )

            ///일기 데이터 띄울 곳
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    // Dio 객체 생성
    final dio = Dio();

    try {
      // GET 요청 보내기
      final response = await dio.get(
        'http://j9c207.p.ssafy.io:8000/mission-service/api/{member_key}',
      );

      // 요청이 성공했을 때 처리
      if (response.statusCode == 200) {
        final responseData = List<Map<String, dynamic>>.from(response.data);
        print('Response data: $responseData');
        setState(() {
          // widget.data = responseData;// 백이랑 연결 시
          widget.data = responseData;
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

//자녀 일기 상세 조회 페이지 //
class ChildDiaryDetailPage extends StatefulWidget {
  const ChildDiaryDetailPage({super.key});

  @override
  State<ChildDiaryDetailPage> createState() => _ChildDiaryDetailPageState();
}

class _ChildDiaryDetailPageState extends State<ChildDiaryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
