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
import 'package:keeping/screens/diary_page/diary_page.dart';

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
        appBar: MyHeader(text: '자식질문', bgColor: Color(0xFF8320E7)),
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
                    Text(
                      '오늘의 질문에 답해보세요',
                      style: TextStyle(
                        fontSize: 24, // 텍스트 크기 설정
                        color: Colors.white, // 텍스트 색상 설정
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChildDiaryDetailPage(
                                  item: data[0],
                                )));
                      },
                      child: Container(
                        width: 350,
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
                        child: Column(children: [
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
                        ]),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QuestionSendPage()));
                        },
                        child: Text('오늘의 질문 생성하기')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChildDiaryPage()));
                        },
                        child: Text('일기 페이지')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QeustionAnswerPage(
                                    questionText: data[0]["content"],
                                    questionId: data[0]["id"],
                                  )));
                        },
                        child: Text('오늘의 질문 대답하기'))
                  ]),
                );
              }
            }));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF8320E7),
        appBar: MyHeader(text: '부모질문', bgColor: Color(0xFF8320E7)),
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
                    Text(
                      '오늘의 질문에 답해보세요',
                      style: TextStyle(
                        fontSize: 24, // 텍스트 크기 설정
                        color: Colors.white, // 텍스트 색상 설정
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChildDiaryDetailPage(
                                  item: data[0],
                                )));
                      },
                      child: Container(
                        width: 350,
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
                        child: Column(children: [
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
                        ]),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ParentQuestionSendPage()));
                        },
                        child: Text('오늘의 질문 생성하기')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ParentDiaryPage()));
                        },
                        child: Text('일기 페이지')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ParentQeustionAnswerPage(
                                    questionText: data[0]["content"],
                                    questionId: data[0]["id"],
                                  )));
                        },
                        child: Text('오늘의 질문 대답하기'))
                  ]),
                );
              }
            }));
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
        print('response관찰');
        print(response);
        // 멤버키를 기반으로 필터링 수행
        var filteredData =
            List<Map<String, dynamic>>.from(response.data['resultBody'])
                .where((item) => item['memberKey'] == memberKey)
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
        print('사용자 개인질문 생성 데이터 전송 성공!');
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ParentQuestionPage()));
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
      }
    } catch (e) {
      print('Error: $e');
      print(data);
    }
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
        text: '질문 보내기(자녀)',
      ),
      body: Column(
        children: [
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
        print('사용자 개인질문 생성 데이터 전송 성공!');
        print(data);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ParentQuestionPage()));
      } else {
        print('사용자 개인질문 생성 데이터 전송 실패.');
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
        text: '질문 보내기(부모)',
      ),
      body: Column(
        children: [
          Text('받는사람'),

          /// 자녀를 고르는 드랍다운
          DropdownButton<String>(
            value: selectedMemberKey.isNotEmpty ? selectedMemberKey : null,
            onChanged: (String? newValue) {
              setState(() {
                selectedMemberKey = newValue ?? '';
              });
            },
            items: childrenList
                .map<DropdownMenuItem<String>>((Map<String, dynamic> child) {
              return DropdownMenuItem<String>(
                value: child["memberKey"].toString(),
                child: Text(child["name"].toString()),
              );
            }).toList(),
          ),

          ///
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
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

/////////////////////////
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
      ),
      body: Column(
        children: [
          Text(
            widget.questionText.toString(),
            style: TextStyle(fontSize: 20),
          ),
          renderTextFormField(
              label: '',
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
      ),
      body: Column(
        children: [
          Text(widget.questionText.toString()),
          renderTextFormField(
              label: '',
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
