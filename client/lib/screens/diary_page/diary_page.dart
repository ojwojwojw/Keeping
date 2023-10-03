import 'package:flutter/material.dart';
import 'package:keeping/widgets/my_icons.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:dio/dio.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/provider/child_info_provider.dart';

final _baseUrl = dotenv.env['BASE_URL'];

// 자식 일기 페이지 //
class ChildDiaryPage extends StatefulWidget {
  const ChildDiaryPage({super.key});

  @override
  State<ChildDiaryPage> createState() => _ChildDiaryPageState();
}

class _ChildDiaryPageState extends State<ChildDiaryPage> {
  List<Map<String, dynamic>> data = [];

  //일기 보관함 데이터를 가져오는 비동기 요청
  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/question-service/api/$memberKey/questions",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            response.data['resultBody']['questions']);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 빈 리스트 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 220, 255),
      appBar: MyHeader(
        text: '추억 저장소',
        bgColor: Color.fromARGB(255, 255, 255, 255),
        elementColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 410,
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset('assets/image/diary/key.png'), // 이미지 경로를 여기에 설정하세요.
                  ),
                  SizedBox(height: 10,),

                  ///일기 데이터 띄울 곳
                  _diaryData(data),

                  Expanded(child: SizedBox()), // 빈 공간을 채우기 위한 Expanded 위젯
                  Align(
                    alignment: Alignment.bottomRight, // 오른쪽 하단 정렬
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // 버튼과 화면 경계 사이의 여백 조절
                      child: _todayQuestionBtn(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(diary: true,),
    );
  }


  // 일기 데이터를 띄울 위젯
  Widget _diaryData(data) {
    return (Expanded(
        child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final item = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: InkWell(
            onTap: () {
              // 컨테이너를 탭했을 때 실행할 동작 정의

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChildDiaryDetailPage(
                      index: index + 1,
                      item: item), // DetailPage는 새로운 페이지의 위젯입니다.
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0), // 여백 추가
              margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
              decoration: BoxDecoration(
                color: Colors.white, // 하얀색 배경
                borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 만들기
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text('#' + (index + 1).toString()),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item["content"],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // 긴 텍스트 자르고 ...으로 표시
                          maxLines: 1, // 최대 1줄까지 표시
                        ),
                      ),
                      SizedBox(
                        width: 30, child:Icon(MyIcons.arrowForward, size: 20, color: Colors.grey,),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0), // 텍스트 사이에 간격 추가
                  Text(
                    (item["createdDate"] is String
                        ? item["createdDate"].substring(0, 10) + "일 생성"
                        : ""),
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )));
  }

// 일기 생성 버튼
  Widget _diaryCreateBtn() {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionSendPage(),
          ),
        );
      },
      child: Image.asset('assets/image/make_quest.png'),
    );
  }

//오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionPage(),
          ),
        );
      },
      child: Container(
        width: 70, // 버튼의 너비
        height: 70, // 버튼의 높이
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 동그란 모양
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // 그림자 색상
              offset: Offset(0, 1), // 그림자 위치 (가로: 0, 세로: 2)
              blurRadius: 2, // 그림자 흐림 정도
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 가운데 정렬
            children: [
              Image.asset(
                'assets/image/question/micandfaces.png',
                width: 40, // 이미지의 너비
                height: 40, // 이미지의 높이
              ),
              Text(
                '오늘의 질문',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//자녀 일기 상세 조회 페이지 //

class ChildDiaryDetailPage extends StatefulWidget {
  final int index;
  final Map<String, dynamic> item;
  const ChildDiaryDetailPage(
      {Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  State<ChildDiaryDetailPage> createState() => _ChildDiaryDetailPageState();
}

class _ChildDiaryDetailPageState extends State<ChildDiaryDetailPage> {
  Map<String, dynamic> data = {};

  //비동기 데이터 요청
  Future<Map<String, dynamic>> getData() async {
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      final response = await dio.get(
        "$_baseUrl/question-service/api/$memberKey/questions/${widget.item["id"]}",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return response.data['resultBody']['question'];
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "일기상세조회(자녀)",
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? {}; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 410,
                  color: Color(0xFF9271C8),
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 좌측 상단 버튼을 눌렀을 때 실행할 동작 정의
                      Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QeustionAnswerPage(
                                  questionDate: data["createdDate"].toString().substring(0,10),
                                  questionText: data["content"],
                                  questionId: data["id"],
                                ),
                              ),
                            );
                          },
                          child: Image.asset('assets/image/edit_square.png',
                              width: 40.0, height: 40.0),
                        ),
                        ////////
                        Padding(
                          padding: EdgeInsets.only(left: 55.0), // 왼쪽 패딩만 설정
                          child: Container(
                            padding: EdgeInsets.all(10.0), // 내부 패딩
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[100], // 연보라색 배경
                              borderRadius:
                                  BorderRadius.circular(10.0), // 둥근 테두리
                            ),
                            child: Text(
                              "엄마와 나의 질문일기",
                              style: TextStyle(
                                color: Colors.purple, // 보라색 글씨
                                fontSize: 16.0, // 글씨 크기
                              ),
                            ),
                          ),
                        )
                      ]),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Row의 내용을 가운데 정렬
                        children: [
                          Column(children: [
                            SizedBox(
                              height: 8,
                            ),
                            Image.asset(
                              'assets/image/c_face.png',
                              width: 51.0,
                              height: 51.0,
                              fit: BoxFit.cover,
                            )
                          ]),
                          Image.asset(
                            'assets/image/m_face.png',
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                          )
                        ],
                      ),

                      SizedBox(
                        height: 60,
                      ),

                      Text(
                        data["content"],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "생성 날짜: ${data["createdDate"].toString().substring(0, 10)}",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey[500],
                        ),
                      ),

                      Text(
                        "${widget.index}번째 질문",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 16.0),

                      SizedBox(height: 16.0),

                      Text(
                        "부모 대답",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.0),

                      Row(
                        children: [
                          Text(
                            data["parentAnswer"] ?? "아직 부모의 대답이 없습니다.",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.0),
                      Text(
                        "자녀 대답",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),

                      Row(
                        children: [
                          Text(
                            data["childAnswer"] ?? "아직 자녀의 대답이 없습니다.",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 145,
                      ),
                      //댓글페이지로 가는버튼 //
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryCommentPage(
                                    questionId: data["id"],
                                    index: widget.index),
                              ),
                            );
                          },
                          child: Image.asset('assets/image/sms.png',
                              width: 40.0, height: 40.0),
                        ),
                      ]),
                      // Text(
                      //   "생성 여부: ${data["isCreated"] == null ? "정보 없음" : (data["isCreated"] ? "true" : "false")}",
                      //   style: TextStyle(fontSize: 18.0),
                      // )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

//부모 일기 페이지(이동할래용)
class ParentDiaryPage extends StatefulWidget { 
  const ParentDiaryPage({super.key});

  @override
  State<ParentDiaryPage> createState() => _ParentDiaryPageState();
}

class _ParentDiaryPageState extends State<ParentDiaryPage> {
  List<Map<String, dynamic>> data = [];
  late String? selectedMemberKey;
  late ChildInfoProvider childInfoProvider;

  @override
  void initState() {
    super.initState();
    childInfoProvider = Provider.of<ChildInfoProvider>(context, listen: false);
    selectedMemberKey = childInfoProvider.memberKey;
  }

  //일기 보관함 데이터를 가져오는 비동기 요청
  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/question-service/api/$memberKey/questions",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200) {
        // return List<Map<String, dynamic>>.from(
        //     response.data['resultBody']['questions']);
        // 멤버키를 기반으로 필터링 수행
        var filteredData = List<Map<String, dynamic>>.from(
                response.data['resultBody']['questions'])
            .where((item) => item['childMemberKey'] == selectedMemberKey)
            .toList();
        return filteredData;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 빈 리스트 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 220, 255),
      appBar: MyHeader(
        text: '추억 저장소',
        bgColor: Color.fromARGB(255, 255, 255, 255),
        elementColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 410,
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Image.asset('assets/image/diary/key.png'), // 이미지 경로를 여기에 설정하세요.
                  ),
                  SizedBox(height: 10,),

                  ///일기 데이터 띄울 곳
                  _diaryData(data),
                  Row(
                    children: [
                      Expanded(
                        child: _diaryCreateBtn(),
                      ),
                      Expanded(
                        child: _todayQuestionBtn(),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(diary: true),
    );
  }

  // 일기 데이터를 띄울 위젯
  Widget _diaryData(data) {
    return (Expanded(
        child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final item = data[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: InkWell(
            onTap: () {
              // 컨테이너를 탭했을 때 실행할 동작 정의

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParentDiaryDetailPage(
                      item: item,
                      index: index + 1), // DetailPage는 새로운 페이지의 위젯입니다.
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0), // 여백 추가
              margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
              decoration: BoxDecoration(
                color: Colors.white, // 하얀색 배경
                borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 만들기
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text('#' + (index + 1).toString()),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item["content"],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // 긴 텍스트 자르고 ...으로 표시
                          maxLines: 1, // 최대 1줄까지 표시
                        ),
                      ),
                      SizedBox(
                        width: 30, child:Icon(MyIcons.arrowForward, size: 20, color: Colors.grey,),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0), // 텍스트 사이에 간격 추가
                  Text(
                    (item["createdDate"] is String
                        ? item["createdDate"].substring(0, 10) + "일 생성"
                        : ""),
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )));
  }

  // 일기 생성 버튼
  Widget _diaryCreateBtn() {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentQuestionSendPage(),
          ),
        );
      },
      child: Container(
        width: 70, // 버튼의 너비
        height: 70, // 버튼의 높이
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 동그란 모양
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // 그림자 색상
              offset: Offset(0, 1), // 그림자 위치 (가로: 0, 세로: 2)
              blurRadius: 2, // 그림자 흐림 정도
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 가운데 정렬
            children: [
              Image.asset(
                'assets/image/diary/rocket.png',
                width: 40, // 이미지의 너비
                height: 40, // 이미지의 높이
              ),
              Text(
                '질문 보내기',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

//오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionPage(),
          ),
        );
      },
      child: Container(
        width: 70, // 버튼의 너비
        height: 70, // 버튼의 높이
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 동그란 모양
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // 그림자 색상
              offset: Offset(0, 1), // 그림자 위치 (가로: 0, 세로: 2)
              blurRadius: 2, // 그림자 흐림 정도
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 가운데 정렬
            children: [
              Image.asset(
                'assets/image/question/micandfaces.png',
                width: 40, // 이미지의 너비
                height: 40, // 이미지의 높이
              ),
              Text(
                '오늘의 질문',
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//부모 일기 상세조회 페이지 //
class ParentDiaryDetailPage extends StatefulWidget {
  final int index;
  final Map<String, dynamic> item;
  const ParentDiaryDetailPage(
      {Key? key, required this.item, required this.index})
      : super(key: key); 

  @override
  State<ParentDiaryDetailPage> createState() => _ParentDiaryDetailPageState();
}

class _ParentDiaryDetailPageState extends State<ParentDiaryDetailPage> {
  Map<String, dynamic> data = {};

  //비동기 데이터 요청
  Future<Map<String, dynamic>> getData() async {
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      final response = await dio.get(
        "$_baseUrl/question-service/api/$memberKey/questions/${widget.item["id"]}",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return response.data['resultBody']['question'];
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "일기상세조회(부모)",
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? {}; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 410,
                  color: Color(0xFF9271C8),
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 좌측 상단 버튼을 눌렀을 때 실행할 동작 정의
                      Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentQeustionAnswerPage(
                                  questionDate: data['createdDate'].toString().substring(0,10),
                                  questionText: data["content"],
                                  questionId: data["id"],
                                ),
                              ),
                            );
                          },
                          child: Image.asset('assets/image/edit_square.png',
                              width: 40.0, height: 40.0),
                        ),
                        ////////
                        Padding(
                          padding: EdgeInsets.only(left: 55.0), // 왼쪽 패딩만 설정
                          child: Container(
                            padding: EdgeInsets.all(10.0), // 내부 패딩
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[100], // 연보라색 배경
                              borderRadius:
                                  BorderRadius.circular(10.0), // 둥근 테두리
                            ),
                            child: Text(
                              "아이와 나의 질문일기",
                              style: TextStyle(
                                color: Colors.purple, // 보라색 글씨
                                fontSize: 16.0, // 글씨 크기
                              ),
                            ),
                          ),
                        )
                        ////// 이쁜 보라색 박스
                      ]),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Row의 내용을 가운데 정렬
                        children: [
                          Column(children: [
                            SizedBox(
                              height: 8,
                            ),
                            Image.asset(
                              'assets/image/c_face.png',
                              width: 51.0,
                              height: 51.0,
                              fit: BoxFit.cover,
                            )
                          ]),
                          Image.asset(
                            'assets/image/m_face.png',
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                          )
                        ],
                      ),

                      SizedBox(
                        height: 60,
                      ),

                      Text(
                        data["content"],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "${widget.index}번째 질문",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey[500],
                        ),
                      ),

                      Text(
                        "생성 날짜: ${data["createdDate"].toString().substring(0, 10)}",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey[500],
                        ),
                      ),

                      SizedBox(height: 24.0),
                      Text(
                        "부모 대답",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.0),

                      Row(
                        children: [
                          Text(
                            data["parentAnswer"] ?? "아직 부모의 대답이 없습니다.",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.0),

                      Text(
                        "아이 대답",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.0),
                      Text(
                        data["childAnswer"] ?? "아직 자녀의 대답이 없습니다",
                        style: TextStyle(fontSize: 18.0),
                      ),

                      SizedBox(height: 145.0),

                      //댓글페이지로 가는버튼 //
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryCommentPage(
                                  questionId: data["id"],
                                  index: widget.index,
                                ),
                              ),
                            );
                          },
                          child: Image.asset('assets/image/sms.png',
                              width: 40.0, height: 40.0),
                        ),
                      ]),
                      // Text(
                      //   "생성 여부: ${data["isCreated"] == null ? "정보 없음" : (data["isCreated"] ? "true" : "false")}",
                      //   style: TextStyle(fontSize: 18.0),
                      // )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

//일기 댓글 페이지 // //자식부모 유저 둘다 사용 가능하게 로직 짜기!
class DiaryCommentPage extends StatefulWidget {
  final questionId;
  final index;
  const DiaryCommentPage(
      {super.key, required this.questionId, required this.index});

  //질문 아이디 받아오기

  @override
  State<DiaryCommentPage> createState() => _DiaryCommentPageState();
}

class _DiaryCommentPageState extends State<DiaryCommentPage> {
  @override
  Widget build(BuildContext context) {
    late Map<String, dynamic> data;
    String? memberKey; //로그인한 유저의 멤버키

    //몇분전인지 출력하는 함수//
    String timeAgo(String timeString) {
      DateTime givenTime = DateTime.parse(timeString).toUtc();
      DateTime currentTime = DateTime.now().toUtc();
      Duration difference = currentTime.difference(givenTime);

      int differenceInMinutes = difference.inMinutes - 540;

      if (differenceInMinutes < 60) {
        return "$differenceInMinutes분 전";
      } else if (differenceInMinutes < 24 * 60) {
        return "${differenceInMinutes ~/ 60}시간 전";
      } else {
        return "${differenceInMinutes ~/ (24 * 60)}일 전";
      }
    }

    TextEditingController _commentController = TextEditingController();
    //댓글 작성하는 함수
    _submitComment() async {
      // 로그인한 유저의 멤버키 및 액세스 토큰 가져오기
      var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
      var memberKey = userProvider.memberKey;
      var accessToken = userProvider.accessToken;

      // Dio 객체 생성
      final dio = Dio();

      // 요청 본문
      final requestBody = {
        "questionId": widget.questionId, // 알맞은 질문 ID를 사용하세요.
        "content": _commentController.text, // 사용자가 입력한 댓글 내용
      };

      try {
        final response = await dio.post(
          "$_baseUrl/question-service/api/$memberKey/comment",
          data: requestBody,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        if (response.statusCode == 200) {
          print("댓글 작성 성공");
          _commentController.clear();
          // 댓글 목록을 업데이트하려면 setState를 호출합니다.
          setState(() {});
        } else {
          print("댓글 작성 실패: ${response.data}");
        }
      } catch (error) {
        print("댓글 작성 중 오류 발생: $error");
      }
    }

    _deleteComment(int commentId) async {
      // 로그인한 유저의 멤버키 및 액세스 토큰 가져오기
      var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
      var memberKey = userProvider.memberKey;
      var accessToken = userProvider.accessToken;

      // Dio 객체 생성
      final dio = Dio();

      try {
        final response = await dio.delete(
          "$_baseUrl/question-service/api/$memberKey/comment/$commentId",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        if (response.statusCode == 200) {
          print("댓글 삭제 성공");
          // 댓글 목록을 업데이트하려면 setState를 호출합니다.
          setState(() {});
        } else {
          print("댓글 삭제 실패: ${response.data}");
        }
      } catch (error) {
        print("댓글 삭제 중 오류 발생: $error");
      }
    }

    //댓글 데이터 비동기 요청
    Future<Map<String, dynamic>> getData() async {
      // Dio 객체 생성
      final dio = Dio();
      var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
      memberKey = userProvider.memberKey; // 현재 로그인한 유저의 멤버키
      var accessToken = userProvider.accessToken;

      try {
        // GET 요청 보내기
        final response = await dio.get(
            "$_baseUrl/question-service/api/$memberKey/questions/${widget.questionId}",
            options:
                Options(headers: {'Authorization': 'Bearer $accessToken'}));
        // 요청이 성공했을 때 처리
        if (response.statusCode == 200) {
          print('댓글정보 요청 성공 200');
          print(response.data['resultBody']['comments']);

          var commentsData = response.data['resultBody']['comments'];
          var questionData = response.data['resultBody']['question'];
          return {
            'comments': commentsData != null
                ? List<Map<String, dynamic>>.from(commentsData)
                : [],
            'question': questionData != null
                ? questionData // 직접적인 Map으로 반환합니다.
                : {}
          };
        } else {
          throw Exception('Failed to fetch data');
        }
      } catch (error) {
        // 요청이 실패했을 때 처리
        print('Error: $error');
        return {}; // 빈 리스트 반환
      }
    }

    //퓨터빌더의 결과로 리턴 하는 페이지//
    return Scaffold(
      appBar: MyHeader(
        text: "일기댓글",
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else {
            data = snapshot.data ?? {};

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      width: 410,
                      color: Color(0xFF9271C8),
                      child: SizedBox(),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    // Question data
                    Text(
                      "#" + widget.index.toString() + "번째 질문",
                      style: TextStyle(fontSize: 25, color: Colors.grey[400]),
                    ),

                    Text(
                      data['question']['content'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    //댓글 데이터//
                    ListView.builder(
                        shrinkWrap:
                            true, // ListView를 Column 내부에서 사용하기 위해 필요합니다.
                        physics:
                            NeverScrollableScrollPhysics(), // ListView 내부 스크롤을 비활성화합니다.
                        itemCount:
                            data['comments']?.length ?? 0, // 댓글 리스트의 길이를 사용합니다.
                        itemBuilder: (context, index) {
                          var comment = data['comments'][index];
                          bool isCurrentUserComment =
                              comment['memberKey'] == memberKey;

                          // 공통으로 사용할 날짜 위젯
                          var dateWidget = Text(
                            "${timeAgo(comment['createdDate'])}",
                            style: TextStyle(
                                color: isCurrentUserComment
                                    ? Color.fromARGB(255, 136, 136, 136)
                                    : const Color.fromARGB(255, 128, 128, 128)),
                          );

                          // 댓글 텍스트 위젯
                          var commentWidget = Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isCurrentUserComment
                                  ? Color(0xFF6E2FD5)
                                  : Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              comment['content'],
                              style: TextStyle(
                                color: isCurrentUserComment
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );

                          return Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onLongPress: () {
                                  if (isCurrentUserComment) {
                                    // 꾸욱 누르면 삭제 확인 모달 표시
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('댓글 삭제'),
                                        content: Text('댓글을 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('확인'),
                                            onPressed: () {
                                              _deleteComment(comment[
                                                  'commentId']); // 댓글 삭제 함수 호출
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: isCurrentUserComment
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (isCurrentUserComment)
                                      dateWidget, // 왼쪽 정렬일 때 날짜를 먼저 표시
                                    SizedBox(width: 8),
                                    commentWidget,
                                    if (!isCurrentUserComment)
                                      dateWidget, // 오른쪽 정렬일 때 날짜를 나중에 표시
                                  ],
                                ),
                              ),
                            ],
                          );
                        })

                    ///
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: '댓글을 작성하세요...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _submitComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
