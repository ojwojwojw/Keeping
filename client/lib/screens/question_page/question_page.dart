import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:dio/dio.dart';
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

final _baseUrl = dotenv.env['BASE_URL'];

//오늘의 질문 페이지 (자녀)
class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Map<String, dynamic>> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '자식질문',
        bgColor: Color(0xFF8320E7),
        elementColor: Colors.white,
        backPath: ChildMainPage(),
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
              return Center(
                child: Column(children: [
                  Container(
                    height: 10,
                    width: 410,
                    color: Color(0xFFD9D9D9).withOpacity(0.5),
                    child: SizedBox(),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    '오늘의 질문에 답해보세요',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (data.length >= 1) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChildDiaryDetailPage(
                            item: data[0],
                            index: 0
                          ),
                        ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('알림'),
                            content: Text('오늘의 질문이 없습니다. 페이지로 이동할 수 없습니다.'),
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
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                        crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
                        children: [
                          Text(
                            DateFormat('yyyy년 MM월 dd일').format(DateTime.now()) +
                                "의 질문",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          data != null && data.isNotEmpty
                              ? Text(
                                  "Q." + data[0]["content"],
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text("오늘의 질문이 없습니다. "),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QuestionSendPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('내일의 질문 생성하기'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChildDiaryPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('일기 페이지'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        if (data != null &&
                            data.isNotEmpty &&
                            data[0]["content"] != null &&
                            data[0]["id"] != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QeustionAnswerPage(
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('오늘의 질문 대답하기'),
                    ),
                  ),
                ]),
              );
            }
          }),
      bottomNavigationBar: BottomNav(),
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/question-service/api/$memberKey/questions/today",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      print('try를 하나요?');
      print(response.data['resultBody']);
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && response.data['resultBody'] is List) {
        return List<Map<String, dynamic>>.from(response.data['resultBody']);
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

  late String? selectedMemberKey;
  late Dio dio;
  late UserInfoProvider userProvider;
  late ChildInfoProvider childInfoProvider;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    childInfoProvider = Provider.of<ChildInfoProvider>(context, listen: false);
    selectedMemberKey = childInfoProvider.memberKey;
  }

  //질문 데이터를 가져오는 비동기 요청
  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/question-service/api/$memberKey/questions/today",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      print('부모 오늘의 질문 데이터');
      print(response.data['resultBody']);
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && response.data['resultBody'] is List) {
        print(response);
        // 멤버키를 기반으로 필터링 수행
        var filteredData =
            List<Map<String, dynamic>>.from(response.data['resultBody'])
                .where((item) => item['memberKey'] == selectedMemberKey)
                .toList();
        print(filteredData);
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
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '부모질문',
        bgColor: Color(0xFF8320E7),
        backPath: ParentMainPage(),
        elementColor: Colors.white,
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
              return Center(
                child: Column(children: [
                  Container(
                    height: 10,
                    width: 410,
                    color: Color(0xFFD9D9D9).withOpacity(0.5),
                    child: SizedBox(),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    '오늘의 질문에 답해보세요',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (data.length >= 1) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ParentDiaryDetailPage(
                            // 여기는 부모 페이지를 나타내는 클래스로 변경해야 합니다.
                            item: data[0],
                            index: 0
                          ),
                        ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('알림'),
                            content: Text('오늘의 질문이 없습니다. 페이지로 이동할 수 없습니다.'),
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
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('yyyy년 MM월 dd일').format(DateTime.now()) +
                                "의 질문",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          data != null && data.isNotEmpty
                              ? Text(
                                  "Q." + data[0]["content"],
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text("오늘의 질문이 없습니다. "),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ParentQuestionSendPage()));
                      },
                      child: Text('내일의 질문 생성하기'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ParentDiaryPage()));
                      },
                      child: Text('일기 페이지'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        if (data != null &&
                            data.isNotEmpty &&
                            data[0]["content"] != null &&
                            data[0]["id"] != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ParentQeustionAnswerPage(
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
                      child: Text('오늘의 질문 대답하기'),
                    ),
                  ),
                ]),
              );
            }
          }),
      bottomNavigationBar: BottomNav(),
    );
  }
}

//자식 질문 보내는 페이지
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
  late Dio dio;

  //부모키 가져오기//
  Future<void> _getParentMemberKey() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    try {
      var response = await dio.get(
          "$_baseUrl/member-service/auth/api/$memberKey/parent",
          options: Options(headers: {"Authorization": "Bearer  $accessToken"}));
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

    var data = {"childMemberKey": memberKey, "content": comment};

    try {
      final response = await dio.post(
          "$_baseUrl/question-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        if (response.data['resultStatus']['successCode'] == 409) {
          _showErrorMessage(response.data['resultStatus']['resultMessage']);
        } else {
          print('사용자 개인질문 생성 데이터 전송 성공!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletedAndGoPage(
                        text: "질문생성 완료!",
                        targetPage: ParentQuestionPage(),
                      )));
        }
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
      // DioException에서 응답 상태 코드 확인
      if (e is DioError && e.response?.statusCode == 400) {
        _showErrorMessage('해당 날짜에 이미 질문이 존재합니다 (400).');
      }
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
    dio = Dio();
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
  late Dio dio;
  late UserInfoProvider userProvider;
  List<Map<String, dynamic>> childrenList = [];

  @override
  void initState() {
    super.initState();
    dio = Dio();
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

    try {
      final response = await dio.post(
          "$_baseUrl/question-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        if (response.data['resultStatus']['successCode'] == 409) {
          _showErrorMessage(response.data['resultStatus']['resultMessage']);
        } else {
          print('사용자 개인질문 생성 데이터 전송 성공!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletedAndGoPage(
                        text: "질문생성 완료!",
                        targetPage: ParentQuestionPage(),
                      )));
        }
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
      // DioException에서 응답 상태 코드 확인
      if (e is DioError && e.response?.statusCode == 400) {
        _showErrorMessage('해당 날짜에 이미 질문이 존재합니다 (400).');
      }
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
        text: '질문 보내기(부모)',
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
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

          ////////
          Padding(
            padding: EdgeInsets.only(left: 0.0), // 왼쪽 패딩만 설정
            child: Container(
              padding: EdgeInsets.all(10.0), // 내부 패딩
              decoration: BoxDecoration(
                color: Colors.deepPurple[100], // 연보라색 배경
                borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
              ),
              child: Text(
                "질문 보내기",
                style: TextStyle(
                  color: Colors.purple, // 보라색 글씨
                  fontSize: 16.0, // 글씨 크기
                ),
              ),
            ),
          ),
          ////// 이쁜 보라색 박스
          Image.asset(
            'assets/image/m_face.png',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),

          SizedBox(
            height: 15,
          ),

          Text('어느 자녀에게 보낼까요?'),

          /// 자녀를 고르는 드랍다운
          Container(
            width: 380,
            height: 60,
            padding: EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 5.0), // dropdown arrow와 padding 조절
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: DropdownButtonHideUnderline(
              // underline 제거
              child: DropdownButton<String>(
                isExpanded: true, // 텍스트와 dropdown arrow 간에 공간을 최대로 활용
                value: selectedMemberKey.isNotEmpty ? selectedMemberKey : null,
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
                        Image.asset(
                          'assets/image/n_face.png',
                          width: 100.0,
                          height: 100.0,
                        ),
                        SizedBox(width: 10.0), // 이미지와 텍스트 사이의 간격
                        Text(child["name"].toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          ///
          renderTextFormFieldNonLabel(
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
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

//자식 질문에 답하는 페이지
class QeustionAnswerPage extends StatefulWidget {
  final String? questionText;
  final int? questionId;
  const QeustionAnswerPage(
      {Key? key, required this.questionText, required this.questionId})
      : super(key: key);

  @override
  State<QeustionAnswerPage> createState() => _QeustionAnswerPageState();
}

class _QeustionAnswerPageState extends State<QeustionAnswerPage> {
  String comment = '';

  Future<void> _sendMissionData() async {
    var dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent;

    var data = {
      "isParent": userType,
      "questionId": widget.questionId,
      "answer": comment
    };

    try {
      final response = await dio.post(
          "$_baseUrl/question-service/api/$memberKey/answer",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('질문 답변 데이터 전송 성공!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "답변 작성 완료!",
                      targetPage: ChildDiaryPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 답하기(자녀)',
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          //////////////////////////
          Padding(
            padding: EdgeInsets.only(left: 0.0), // 왼쪽 패딩만 설정
            child: Container(
              padding: EdgeInsets.all(10.0), // 내부 패딩
              decoration: BoxDecoration(
                color: Colors.deepPurple[100], // 연보라색 배경
                borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
              ),
              child: Text(
                "질문 답하기",
                style: TextStyle(
                  color: Colors.purple, // 보라색 글씨
                  fontSize: 16.0, // 글씨 크기
                ),
              ),
            ),
          ),
          ///////////////////
          ///

          SizedBox(
            height: 15,
          ),

          Image.asset(
            'assets/image/c_face.png',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),

          ///

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Row의 내용을 가운데 정렬
            children: [
              Text(
                widget.questionText.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글씨를 굵게
                  fontSize: 14.0, // 글씨 크기를 14포인트로 설정
                ),
              ),
            ],
          ),

          renderTextFormFieldNonLabel(
              hintText: '질문에 대해 어떻게 생각하시나요?',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '등록하기',
        action: _sendMissionData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

//부모 질문에 답하는 페이지
class ParentQeustionAnswerPage extends StatefulWidget {
  final String? questionText;
  final int? questionId;
  const ParentQeustionAnswerPage(
      {super.key, required this.questionText, required this.questionId});

  @override
  State<ParentQeustionAnswerPage> createState() =>
      _ParentQeustionAnswerPageState();
}

class _ParentQeustionAnswerPageState extends State<ParentQeustionAnswerPage> {
  String comment = '';

  Future<void> _sendMissionData() async {
    var dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent;

    var data = {
      "isParent": userType,
      "questionId": widget.questionId,
      "answer": comment
    };

    try {
      final response = await dio.post(
          "$_baseUrl/question-service/api/$memberKey/answer",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('질문 답변 데이터 전송 성공!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "답변 작성 완료!",
                      targetPage: ParentDiaryPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '질문 답하기(부모)',
        bgColor: Color(0xFF6E2FD5),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          //////////////////////////
          Padding(
            padding: EdgeInsets.only(left: 0.0), // 왼쪽 패딩만 설정
            child: Container(
              padding: EdgeInsets.all(10.0), // 내부 패딩
              decoration: BoxDecoration(
                color: Colors.deepPurple[100], // 연보라색 배경
                borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
              ),
              child: Text(
                "질문 답하기",
                style: TextStyle(
                  color: Colors.purple, // 보라색 글씨
                  fontSize: 16.0, // 글씨 크기
                ),
              ),
            ),
          ),
          ///////////////////
          ///

          SizedBox(
            height: 15,
          ),

          Image.asset(
            'assets/image/m_face.png',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),

          ///

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Row의 내용을 가운데 정렬
            children: [
              Text(
                widget.questionText.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글씨를 굵게
                  fontSize: 14.0, // 글씨 크기를 14포인트로 설정
                ),
              ),
            ],
          ),

          renderTextFormFieldNonLabel(
              hintText: '질문에 대해 어떻게 생각하시나요?',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '등록하기',
        action: _sendMissionData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
