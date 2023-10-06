import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:keeping/screens/diary_page/diary_page.dart';
import 'dart:convert';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:http/http.dart' as http;

final _baseUrl = dotenv.env['BASE_URL'];

//오늘의 질문 페이지 (자녀)
class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Map<String, dynamic>> data = [];
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA086EE),
      appBar: MyHeader(
        text: '',
        bgColor: Color(0xFFA086EE),
        elementColor: Colors.white,
        // backPath: ChildMainPage(),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else {
              data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
              return Stack(children: [
                Positioned(
                  top: 60, // top 위치 조절
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center, // 좌우로 가운데 정렬
                    child: Image.asset(
                      'assets/image/question/micandfaces.png',
                      height: 350,
                    ),
                  ),
                ),
                Positioned(
                  top: 15, // top 위치 조절
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center, // 좌우로 가운데 정렬
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '오늘의 질문에\n답해볼까요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 52, 52, 52),
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Column(children: [
                    //

                    SizedBox(
                      height: 15,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end, //하단에 정렬
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (data.length >= 1) {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ChildDiaryDetailPage(
                              //       item: data[0], index: 0),
                              // ));
                              noEffectTransition(
                                  context,
                                  ChildDiaryDetailPage(
                                      item: data[0], index: 0));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('알림'),
                                  content:
                                      Text('오늘의 질문이 없습니다. 페이지로 이동할 수 없습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.15),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '  Q.',
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      data != null && data.isNotEmpty
                                          ? Text(
                                              data[0]["content"],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )
                                          : Text(
                                              "오늘의 질문이 없습니다.",
                                              textAlign: TextAlign.center,
                                            ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _ansBtn(),
                                        _diaryBtn(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 16,
                    ),
                  ]),
                ),
              ]);
            }
          }),
      bottomNavigationBar: BottomNav(),
    );
  }

  Widget _ansBtn() {
    return Container(
      child: InkWell(
        onTap: () {
          if (data != null &&
              data.isNotEmpty &&
              data[0]["content"] != null &&
              data[0]["id"] != null) {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => QeustionAnswerPage(
            //     questionDate: formattedDate,
            //     questionText: data[0]["content"]!,
            //     questionId: data[0]["id"]!,
            //   ),
            // ));

            noEffectTransition(
                context,
                QeustionAnswerPage(
                  questionDate: formattedDate,
                  questionText: data[0]["content"]!,
                  questionId: data[0]["id"]!,
                ));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('알림'),
                content: Text('오늘의 질문이 없습니다.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        },
        child: Column(
          children: [
            Image.asset(
              'assets/image/question/answer.png',
              height: 100.0,
              fit: BoxFit.cover,
            ),
            Text(
              '답하기',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diaryBtn() {
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => ChildDiaryPage()));

        noEffectTransition(context, ChildDiaryPage());
      },
      child: Column(
        children: [
          Image.asset(
            'assets/image/question/folder.png',
            height: 100.0,
          ),
          Text(
            '보관함',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }

  //비동기 요청
  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      // GET 요청 보내기
      final response = await http.get(
        Uri.parse("$_baseUrl/question-service/api/$memberKey/questions/today"),
        headers: headers,
      );
      print('try를 하나요?');
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      print(jsonResponse);

      // List<Map<String, dynamic>> responseData = json.decode(utf8.decode(response.bodyBytes));
      // print("왜 디코딩이 안되냐? $responseData");
      print(jsonResponse['resultBody']);
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && jsonResponse['resultBody'] is List) {
        return List<Map<String, dynamic>>.from(jsonResponse['resultBody']);
      } else {
        return []; // 빈 리스트 반환
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 빈 리스트 반환
    }
  }
}

//오늘의 질문 페이지 (부모)
class ParentQuestionPage extends StatefulWidget {
  const ParentQuestionPage({super.key});

  @override
  State<ParentQuestionPage> createState() => _ParentQuestionPageState();
}

class _ParentQuestionPageState extends State<ParentQuestionPage> {
  List<Map<String, dynamic>> data = [];
  bool? _parent;

  late String? selectedMemberKey;
  late UserInfoProvider userProvider;
  late ChildInfoProvider childInfoProvider;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    childInfoProvider = Provider.of<ChildInfoProvider>(context, listen: false);
    selectedMemberKey = childInfoProvider.memberKey;
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _parent = context.read<UserInfoProvider>().parent;
  }

  //질문 데이터를 가져오는 비동기 요청
  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      // GET 요청 보내기
      final response = await http.get(
        Uri.parse("$_baseUrl/question-service/api/$memberKey/questions/today"),
        headers: headers,
      );
      print('부모 오늘의 질문 데이터');

      // 요청이 성공했을 때 처리

      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && jsonResponse['resultBody'] is List) {
        print(1);
        print("jsonResponse!!!!!!!!!!!!:$jsonResponse");
        // 멤버키를 기반으로 필터링 수행
        var filteredData =
            List<Map<String, dynamic>>.from(jsonResponse['resultBody'])
                .where((item) => item['memberKey'] == selectedMemberKey)
                .toList();
        print("filteredData!!!!!!!!!!!!!! : $filteredData");
        return filteredData;
      } else {
        return []; // 빈 객체 반환
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 빈 리스트 반환
    }
  }

  //페이지 빌드하는 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA086EE),
      appBar: MyHeader(
        text: '',
        bgColor: Color(0xFFA086EE),
        elementColor: Colors.white,
        // backPath: _parent != null && _parent! ? ParentMainPage() : ChildMainPage(),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else {
              data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
              return Stack(children: [
                Positioned(
                  top: 60, // top 위치 조절
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center, // 좌우로 가운데 정렬
                    child: Image.asset(
                      'assets/image/question/micandfaces.png',
                      height: 350,
                    ),
                  ),
                ),
                Positioned(
                  top: 15, // top 위치 조절
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center, // 좌우로 가운데 정렬
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '오늘의 질문에\n답해볼까요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 52, 52, 52),
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Column(children: [
                    //

                    SizedBox(
                      height: 15,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end, //하단에 정렬
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (data.length >= 1) {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ParentDiaryDetailPage(
                              //       item: data[0], index: 0),
                              // ));
                              noEffectTransition(
                                  context,
                                  ParentDiaryDetailPage(
                                      item: data[0], index: 0));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('알림'),
                                  content:
                                      Text('오늘의 질문이 없습니다. 페이지로 이동할 수 없습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.15),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '  Q.',
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 10), // 간격 조정
                                    data != null && data.isNotEmpty
                                        ? Text(
                                            data[0]["content"],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            "오늘의 질문이 없습니다.",
                                            textAlign: TextAlign.center,
                                          ),
                                  ]),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _ansBtn(),
                                        _diaryBtn(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 16,
                    ),
                  ]),
                ),
              ]);
            }
          }),
      bottomNavigationBar: BottomNav(),
    );
  }

  Widget _ansBtn() {
    return Container(
      child: InkWell(
        onTap: () {
          if (data != null &&
              data.isNotEmpty &&
              data[0]["content"] != null &&
              data[0]["id"] != null) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ParentQeustionAnswerPage(
                questionDate: formattedDate,
                questionText: data[0]["content"]!,
                questionId: data[0]["id"]!,
              ),
            ));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('알림'),
                content: Text('오늘의 질문이 없습니다.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        },
        child: Column(
          children: [
            Image.asset(
              'assets/image/question/answer.png',
              height: 100.0,
            ),
            Text(
              '답하기',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diaryBtn() {
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => ParentDiaryPage()));

        noEffectTransition(context, ParentDiaryPage());
      },
      child: Column(
        children: [
          Image.asset(
            'assets/image/question/folder.png',
            height: 100.0,
          ),
          Text(
            '보관함 ',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

//자식 질문 보내는 페이지 (자식은 질문을 보내지 못한다.)
class QuestionSendPage extends StatefulWidget {
  const QuestionSendPage({super.key});

  @override
  State<QuestionSendPage> createState() => _QuestionSendPageState();
}

class _QuestionSendPageState extends State<QuestionSendPage> {
  String comment = '';
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  String parentMemberKey = '';

  //부모키 가져오기//
  Future<void> _getParentMemberKey() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.get(
          Uri.parse("$_baseUrl/member-service/auth/api/$memberKey/parent"),
          headers: headers);
      Map<String, dynamic> jsonResponse = json.decode(response.toString());
      parentMemberKey = jsonResponse['resultBody'];
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendQuestionData() async {
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;

    final data = {"childMemberKey": memberKey, "content": comment};

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/question-service/api/$memberKey"),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['resultStatus']['successCode'] == 409) {
          _showErrorMessage(responseData['resultStatus']['resultMessage']);
        } else if (response.statusCode == 400) {
          _showErrorMessage('해당 날짜에 이미 질문이 존재합니다 (400).');
        } else {
          print('사용자 개인질문 생성 데이터 전송 성공!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletedPage(
                        text: "질문생성 완료!",
                        button: ConfirmBtn(
                          action: ParentQuestionPage(),
                        ),
                      )));
        }
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
      // DioException에서 응답 상태 코드 확인
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    _getParentMemberKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
        text: '질문 보내기(자녀)',
      ),
      body: Column(
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
          ///////////
          Padding(
            padding: EdgeInsets.only(left: 0.0), // 왼쪽 패딩만 설정
            child: Container(
              padding: EdgeInsets.all(10.0), // 내부 패딩
              decoration: BoxDecoration(
                color: Colors.deepPurple[100], // 연보라색 배경
                borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
              ),
              child: Text(
                "내일의 질문 생성하기",
                style: TextStyle(
                  color: Colors.purple, // 보라색 글씨
                  fontSize: 16.0, // 글씨 크기
                ),
              ),
            ),
          ),
          //////////// 예쁜 보라색 상자
          SizedBox(
            height: 15,
          ),

          Image.asset(
            'assets/image/c_face.png',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          renderTextFormField(
              label: '질문내용',
              hintText: '질문 내용을 입력하세요',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '질문보내기',
        action: _sendQuestionData,
        isDisabled: false,
      ),
    );
  }
}

//부모 질문 보내는 페이지
class ParentQuestionSendPage extends StatefulWidget {
  const ParentQuestionSendPage({super.key});

  @override
  State<ParentQuestionSendPage> createState() => _ParentQuestionSendPageState();
}

class _ParentQuestionSendPageState extends State<ParentQuestionSendPage> {
  String selectedMemberKey = '';
  String comment = "";
  late UserInfoProvider userProvider;
  List<Map<String, dynamic>> childrenList = [];

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    childrenList = userProvider.childrenList;
    if (childrenList.isNotEmpty) {
      selectedMemberKey = childrenList.first['memberKey'] ?? '';
    }
  }

  Future<void> _sendQuestionData() async {
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;

    var data = {"childMemberKey": selectedMemberKey, "content": comment};

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
          Uri.parse("$_baseUrl/question-service/api/$memberKey"),
          headers: headers,
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['resultStatus']['successCode'] == 409) {
          _showErrorMessage(responseData['resultStatus']['resultMessage']);
        } else if (response.statusCode == 400) {
          _showErrorMessage('해당 날짜에 이미 질문이 존재합니다 (400).');
        } else {
          print('사용자 개인질문 생성 데이터 전송 성공!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletedPage(
                        text: "질문생성 완료!",
                        button: ConfirmBtn(
                          action: ParentQuestionPage(),
                        ),
                      )));
        }
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
      // DioException에서 응답 상태 코드 확인
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 보내기',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            width: 340,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '누구에게 질문을 보낼까요?',
                  style: labelStyle(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),

          /// 자녀를 고르는 드랍다운
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0), // dropdown arrow와 padding 조절
              decoration: roundedBoxWithShadowStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  // underline 제거
                  child: DropdownButton<String>(
                    isExpanded: true, // 텍스트와 dropdown arrow 간에 공간을 최대로 활용
                    value:
                        selectedMemberKey.isNotEmpty ? selectedMemberKey : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMemberKey = newValue ?? '';
                      });
                    },
                    items: childrenList.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> child) {
                      return DropdownMenuItem<String>(
                        value: child["memberKey"].toString(),
                        child: Row(
                          children: [
                            roundedAssetImg(
                              imgPath: 'assets/image/profile/child1.png',
                              size: 50.0,
                            ),
                            SizedBox(width: 10.0), // 이미지와 텍스트 사이의 간격
                            Text(child["name"].toString(),
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          renderBoxFormField(
              label: '질문 내용을 입력하세요.',
              onChange: (val) {
                setState(() {
                  comment = val;
                });
              },
              maxLines: 4),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '질문보내기',
        action: _sendQuestionData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

//자식 질문에 답하는 페이지
class QeustionAnswerPage extends StatefulWidget {
  final String? questionDate;
  final String? questionText;
  final int? questionId;
  const QeustionAnswerPage(
      {Key? key,
      required this.questionText,
      required this.questionId,
      required this.questionDate})
      : super(key: key);

  @override
  State<QeustionAnswerPage> createState() => _QeustionAnswerPageState();
}

class _QeustionAnswerPageState extends State<QeustionAnswerPage> {
  String comment = '';

  Future<void> _sendMissionData() async {
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent;

    var data = {
      "isParent": userType,
      "questionId": widget.questionId,
      "answer": comment
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
          Uri.parse("$_baseUrl/question-service/api/$memberKey/answer"),
          headers: headers,
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        print('질문 답변 데이터 전송 성공!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedPage(
                      text: "답변 작성 완료!",
                      button: ConfirmBtn(
                        action: ChildDiaryPage(),
                      ),
                    )));
      } else {
        print('질문 답변 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
      print("$_baseUrl/question-service/api/$memberKey/answer");
    }
  }

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 답하기',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom / 2),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              //////////////////////////

              ///

              SizedBox(
                height: 15,
              ),

              Image.asset(
                'assets/image/question/answer.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),

              ///
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, bottom: 8, top: 24),
                    child: Text(widget.questionDate != null
                        ? formattedYMDDate(DateTime.parse(widget.questionDate!))
                        : '기본 날짜'),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: 340,
                      child: Text(
                        'Q. ${widget.questionText.toString()}', //기억
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // 글씨를 굵게
                          fontSize: 20.0, // 글씨 크기를 14포인트로 설정
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              renderBoxFormField(
                  label: '',
                  hintText: '답변을 달아볼까요?',
                  onChange: (value) {
                    setState(() {
                      comment = value;
                    });
                  },
                  maxLines: 5),
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '등록하기',
        action: _sendMissionData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

//부모 질문에 답하는 페이지
class ParentQeustionAnswerPage extends StatefulWidget {
  final String? questionDate;
  final String? questionText;
  final int? questionId;
  const ParentQeustionAnswerPage(
      {super.key,
      required this.questionText,
      required this.questionId,
      required this.questionDate});

  @override
  State<ParentQeustionAnswerPage> createState() =>
      _ParentQeustionAnswerPageState();
}

class _ParentQeustionAnswerPageState extends State<ParentQeustionAnswerPage> {
  String comment = '';

  Future<void> _sendMissionData() async {
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent;

    var data = {
      "isParent": userType,
      "questionId": widget.questionId,
      "answer": comment
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
          Uri.parse("$_baseUrl/question-service/api/$memberKey/answer"),
          headers: headers,
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        print('질문 답변 데이터 전송 성공!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedPage(
                      text: "답변 작성 완료!",
                      button: ConfirmBtn(
                        action: ParentDiaryPage(),
                      ),
                    )));
      } else {
        print('질문 답변 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 답하기',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom / 2),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              //////////////////////////

              ///

              SizedBox(
                height: 15,
              ),

              Image.asset(
                'assets/image/question/answer.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),

              ///
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, bottom: 8, top: 24),
                    child: Text(widget.questionDate != null
                        ? formattedYMDDate(DateTime.parse(widget.questionDate!))
                        : '기본 날짜'),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 380,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Q. ${widget.questionText.toString()}', //기억
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // 글씨를 굵게
                          fontSize: 20.0, // 글씨 크기를 14포인트로 설정
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              renderBoxFormField(
                  label: '',
                  hintText: '답변을 달아볼까요?',
                  onChange: (value) {
                    setState(() {
                      comment = value;
                    });
                  },
                  maxLines: 5),
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '등록하기',
        action: _sendMissionData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
