import 'package:flutter/material.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:dio/dio.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _baseUrl = dotenv.env['BASE_URL'];

// 자식 일기 페이지 //
class ChildDiaryPage extends StatefulWidget {
  const ChildDiaryPage({super.key});

  @override
  State<ChildDiaryPage> createState() => _ChildDiaryPageState();
}

class _ChildDiaryPageState extends State<ChildDiaryPage> {
  List<Map<String, dynamic>> data = [
    {
      "id": 0,
      "content": "만원이 있다면 뭘 하고 싶나요?",
      "parentAnswer": "부모대답1",
      "childAnswer": "자식대답1",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 1,
      "content": "내가 성공할 수 있는 사업이 있다면",
      "parentAnswer": "부모대답2",
      "childAnswer": "자식대답2",
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
    {
      "id": 0,
      "content": "만원이 있다면 뭘 하고 싶나요?",
      "parentAnswer": "부모대답1",
      "childAnswer": "자식대답1",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 1,
      "content": "내가 성공할 수 있는 사업이 있다면",
      "parentAnswer": "부모대답2",
      "childAnswer": "자식대답2",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리(자녀)',
        bgColor: Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            ///일기 데이터 띄울 곳
            _diaryData(data),
            //일기 생성버튼
            _diaryCreateBtn(),
            //오늘의 질문 보기 버튼
            _todayQuestionBtn()
          ],
        ),
      ),
    );
  }

  // 일기 데이터를 띄울 위젯
  Widget _diaryData(data) {
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
                builder: (context) => ChildDiaryDetailPage(
                    item: item), // DetailPage는 새로운 페이지의 위젯입니다.
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
    )));
  }

  // 일기 생성 버튼
  Widget _diaryCreateBtn() {
    return (ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF8320E7), // 짙은 보라색 배경
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (QuestionSendPage()),
          ),
        );
      },
      child:
          (Center(child: Text('새로운 질문 만들기', style: TextStyle(fontSize: 20)))),
    ));
  }

  //오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return (ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF8320E7), // 짙은 보라색 배경
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (QuestionPage()),
          ),
        );
      },
      child: (Center(child: Text('오늘의 질문', style: TextStyle(fontSize: 20)))),
    ));
  }

  //전체 일기 데이터를 얻어올 비동기 요청
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

//자녀 일기 상세 조회 페이지 //

class ChildDiaryDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const ChildDiaryDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ChildDiaryDetailPage> createState() => _ChildDiaryDetailPageState();
}

class _ChildDiaryDetailPageState extends State<ChildDiaryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "일기상세조회(자녀)"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // 좌측 상단 버튼을 눌렀을 때 실행할 동작 정의
                // 예를 들어 새로운 일기 작성 페이지로 이동할 수 있습니다.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QeustionAnswerPage()));
              },
              child: Text("작성"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "일기 내용",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["content"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "부모 응답",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["parentAnswer"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "자녀 응답",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["childAnswer"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "생성 날짜: ${widget.item["createdDate"]}",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  "생성 여부: ${widget.item["isCreated"] ? "true" : "false"}",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//부모 일기 페이지
class ParentDiaryPage extends StatefulWidget {
  const ParentDiaryPage({super.key});

  @override
  State<ParentDiaryPage> createState() => _ParentDiaryPageState();
}

class _ParentDiaryPageState extends State<ParentDiaryPage> {
  List<Map<String, dynamic>> data = [
    {
      "id": 0,
      "content": "만원이 있다면 뭘 하고 싶나요?",
      "parentAnswer": "부모대답1",
      "childAnswer": "자식대답1",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 1,
      "content": "내가 성공할 수 있는 사업이 있다면",
      "parentAnswer": "부모대답2",
      "childAnswer": "자식대답2",
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
    {
      "id": 0,
      "content": "만원이 있다면 뭘 하고 싶나요?",
      "parentAnswer": "부모대답1",
      "childAnswer": "자식대답1",
      "isCreated": false,
      "createdDate": "2023-02-17 08:15:33",
      "comments": null
    },
    {
      "id": 1,
      "content": "내가 성공할 수 있는 사업이 있다면",
      "parentAnswer": "부모대답2",
      "childAnswer": "자식대답2",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리(부모)',
        bgColor: Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            ///일기 데이터 띄울 곳
            _diaryData(data),
            //일기 생성버튼
            _diaryCreateBtn(),
            //오늘의 질문 보기 버튼
            _todayQuestionBtn()
          ],
        ),
      ),
    );
  }

  // 일기 데이터를 띄울 위젯
  Widget _diaryData(data) {
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
                builder: (context) => ParentDiaryDetailPage(
                    item: item), // DetailPage는 새로운 페이지의 위젯입니다.
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
    )));
  }

  // 일기 생성 버튼
  Widget _diaryCreateBtn() {
    return (ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF8320E7), // 짙은 보라색 배경
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (ParentQuestionSendPage()),
          ),
        );
      },
      child:
          (Center(child: Text('새로운 질문 만들기', style: TextStyle(fontSize: 20)))),
    ));
  }

  //오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return (ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF8320E7), // 짙은 보라색 배경
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (ParentQuestionPage()),
          ),
        );
      },
      child: (Center(child: Text('오늘의 질문', style: TextStyle(fontSize: 20)))),
    ));
  }

  //전체 일기 데이터를 얻어올 비동기 요청
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

//부모 일기 상세조회 페이지 //

class ParentDiaryDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const ParentDiaryDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ParentDiaryDetailPage> createState() => _ParentDiaryDetailPageState();
}

class _ParentDiaryDetailPageState extends State<ParentDiaryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "일기상세조회(부모)"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // 좌측 상단 버튼을 눌렀을 때 실행할 동작 정의
                // 예를 들어 새로운 일기 작성 페이지로 이동할 수 있습니다.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QeustionAnswerPage()));
              },
              child: Text("작성"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "일기 내용",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["content"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "부모 응답",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["parentAnswer"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "자녀 응답",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.item["childAnswer"],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 24.0),
                Text(
                  "생성 날짜: ${widget.item["createdDate"]}",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  "생성 여부: ${widget.item["isCreated"] ? "true" : "false"}",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
