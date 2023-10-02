import 'package:flutter/material.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:dio/dio.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/widgets/bottom_nav.dart';

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
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리(자녀)',
        bgColor: Color(0xFF8320E7),
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
            data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: 410,
                    color: Color(0xFFD9D9D9).withOpacity(0.5),
                    child: SizedBox(),
                  ),

                  ///일기 데이터 띄울 곳
                  _diaryData(data),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //일기 생성버튼
                      _diaryCreateBtn(),
                      SizedBox(
                        width: 5,
                      ),
                      //오늘의 질문 보기 버튼
                      _todayQuestionBtn(),
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
      bottomNavigationBar: BottomNav(),
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
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: InkWell(
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
              padding: EdgeInsets.all(8.0), // 여백 추가
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
      child: Image.asset('assets/image/make_quest.png'), // 이미지 경로를 여기에 설정하세요.
    );
  }

//오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionPage(),
          ),
        );
      },
      child: Image.asset('assets/image/today_quest.png'), // 이미지 경로를 여기에 설정하세요.
    );
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
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리(부모)',
        bgColor: Color(0xFF8320E7),
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
            data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: 410,
                    color: Color(0xFFD9D9D9).withOpacity(0.5),
                    child: SizedBox(),
                  ),

                  ///일기 데이터 띄울 곳
                  _diaryData(data),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //일기 생성버튼
                      _diaryCreateBtn(),
                      SizedBox(
                        width: 5,
                      ),
                      //오늘의 질문 보기 버튼
                      _todayQuestionBtn(),
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
      bottomNavigationBar: BottomNav(),
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
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: InkWell(
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
              padding: EdgeInsets.all(8), // 여백 추가
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
            builder: (context) => ParentQuestionSendPage(),
          ),
        );
      },
      child: Image.asset('assets/image/make_quest.png'), // 이미지 경로를 여기에 설정하세요.
    );
  }

//오늘의 질문 보기 버튼
  Widget _todayQuestionBtn() {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentQuestionPage(),
          ),
        );
      },
      child: Image.asset('assets/image/today_quest.png'), // 이미지 경로를 여기에 설정하세요.
    );
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

                      SizedBox(height: 16.0),
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
    );
  }
}

//일기 댓글 페이지 // //자식부모 유저 둘다 사용 가능하게 로직 짜기!
class ParentDiaryCommentPage extends StatefulWidget {
  const ParentDiaryCommentPage({super.key});

  @override
  State<ParentDiaryCommentPage> createState() => _ParentDiaryCommentPageState();
}

class _ParentDiaryCommentPageState extends State<ParentDiaryCommentPage> {
  @override
  Widget build(BuildContext context) {
    late List<Map<String, dynamic>> data;

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
            options:
                Options(headers: {'Authorization': 'Bearer $accessToken'}));
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

    return Scaffold(
      appBar: MyHeader(text: "일기댓글(부모)"),
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
                children: [],
              ),
            );
          }
        },
      ),
    );
  }
}
