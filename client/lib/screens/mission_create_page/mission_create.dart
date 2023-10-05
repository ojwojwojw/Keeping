import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/number_keyboard.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/provider/mission_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:http/http.dart' as http;

final _baseUrl = dotenv.env['BASE_URL'];

//미션 생성페이지 1
class MissionCreatePage1 extends StatefulWidget {
  const MissionCreatePage1({Key? key}) : super(key: key);

  @override
  State<MissionCreatePage1> createState() => _MissionCreatePage1State();
}

class _MissionCreatePage1State extends State<MissionCreatePage1> {
  // final _createKey = GlobalKey<FormState>();
  TextEditingController _missionTitle = TextEditingController();
  String missionTitle = "";
  String missionDueDate = "";
  DateTime dateValue = DateTime.now();
  bool isParent = false;

  @override
  void initState() {
    super.initState();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isParent = userProvider.parent;
  }

  //데이트 피커
  Future datePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: new DateTime(2000),
        initialDate: new DateTime.now(),
        lastDate: new DateTime(2030));

    if (picked != null) {
      setState(() {
        dateValue = picked;
        missionDueDate = picked.toString().substring(0, 10);
      });
    }
  }

  //입력폼의 데이터를 프로바이더로 전송
  Future<void> saveAndMove(context, todo, endDate) {
    // 프로바이더 데이터 업데이트
    print(todo);
    print(endDate);
    Provider.of<MissionInfoProvider>(context, listen: false)
        .saveTodoData(todo: todo, endDate: endDate);

    // MissionCreatePage2 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MissionCreatePage2()),
    );
    return Future.value();
  }

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '미션생성',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    isParent ? '아이에게 어떤 미션을 줄까요?' : '부모님에게 미션을 요청해볼까요?',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Image.asset('assets/image/mission/what_mission.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      // 좌우 여백 24
                      decoration: roundedBoxWithShadowStyle(),
                      child: renderTextFormFieldNonUnderLine(
                          hintText: '미션 제목을 입력해주세요.',
                          onChange: (value) {
                            setState(() {
                              missionTitle = value;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Text(
                  '미션 마감일을 정해주세요!',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: InkWell(
                    onTap: datePicker,
                    child: Container(
                      width: double.infinity,
                      decoration: roundedBoxWithShadowStyle(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: missionDueDate != ""
                            ? Text(
                                missionDueDate,
                              )
                            : Text(
                                '누르면 달력이 나와요!',
                                style: TextStyle(color: Color(0xff757575)),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '다음',
        action: () {
          saveAndMove(context, missionTitle, missionDueDate); // 함수 호출
        },
        isDisabled: missionTitle.isEmpty || missionDueDate.isEmpty,
      ),
    );
  }
}

//미션 생성페이지 2
class MissionCreatePage2 extends StatefulWidget {
  const MissionCreatePage2({super.key});

  @override
  State<MissionCreatePage2> createState() => _MissionCreatePage2State();
}

class _MissionCreatePage2State extends State<MissionCreatePage2> {
  String amount = '';
  bool isParent = false;

  //숫자패드 관련
  onNumberPress(val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount + val;
    });
  }

  onBackspacePress() {
    if (amount.isEmpty) {
      return;
    } else {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 프로바이더로부터 유저타입을 가져오기
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isParent = userProvider.parent;
  }

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '미션 생성',
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    Text(
                      '성공하면 얼마를 줄까요?',
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Image.asset(
                        'assets/image/mission/how_much.png',
                        width: 120.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          amount.toString(),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '원',
                          style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // 숫자패드
              NumberKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
              ),
            ]),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {
          // 프로바이더 데이터 업데이트
          Provider.of<MissionInfoProvider>(context, listen: false)
              .saveMoneyData(amount);

          if (isParent) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ParentMissionCreatePage3()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MissionCreatePage3()));
          }
        },
        isDisabled: amount.isEmpty, // 금액이 없을 경우 버튼 비활성화
      ),
    );
  }
}

//미션 생성페이지 3 (자녀)
class MissionCreatePage3 extends StatefulWidget {
  MissionCreatePage3({super.key});

  @override
  State<MissionCreatePage3> createState() => _MissionCreatePage3State();
}

class _MissionCreatePage3State extends State<MissionCreatePage3> {
  String comment = '';
  late Dio dio;
  late MissionInfoProvider missionProvider;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  String parentMemberKey = '';

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

  //미션 생성 데이터 보내기//
  Future<void> _sendMissionData() async {
    var missionProvider =
        Provider.of<MissionInfoProvider>(context, listen: false);
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    var data = {
      "type": userType,
      "to": parentMemberKey,
      "todo": missionProvider.missionTitle,
      "money": int.parse(missionProvider.amount ?? '0'),
      "cheeringMessage": "",
      "childRequestComment": comment,
      "startDate": DateTime.now().toString().substring(0, 10),
      "endDate": missionProvider.missionDueDate
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      print(data);
      final response = await http.post(
          Uri.parse("$_baseUrl/mission-service/api/$memberKey"),
          headers: headers,
          body: json.encode(data));

      if (response.statusCode == 200) {
        print('미션생성 데이터 전송 성공!');
        print(data);

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션생성 완료!",
        //               button: ConfirmBtn(
        //                 action: MissionPage(),
        //               ),
        //             )));  //페이지터짐관련

        noEffectReplacementTransition(context, MissionPage());

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(
        //               text: '미션 생성완료!',
        //               targetPage: MissionPage(),
        //             )));
      } else {
        print('미션생성 데이터 전송 실패.');
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
    missionProvider = Provider.of<MissionInfoProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    _getParentMemberKey();
  }

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '미션 생성',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            '부모님께 보낼 메시지를 적어봐요!',
            style: TextStyle(fontSize: 20),
          ),
          renderBoxFormField(
              noLabel: true,
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              })
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: "다음",
        isDisabled: comment.isEmpty,
        action: () {
          _sendMissionData();
        },
      ),
    );
  }
}

//미션 생성페이지 3 (부모)
class ParentMissionCreatePage3 extends StatefulWidget {
  @override
  _ParentMissionCreatePage3State createState() =>
      _ParentMissionCreatePage3State();
}

class _ParentMissionCreatePage3State extends State<ParentMissionCreatePage3> {
  String comment = "";
  late Dio dio;
  late MissionInfoProvider missionProvider;
  late UserInfoProvider userProvider;
  late ChildInfoProvider childInfoProvider;
  late List<Map<String, dynamic>> childrenList;
  String selectedMemberKey = '';

  // 데이터를 보낼 아이의 멤버키를 불러오는 로직//
  @override
  void initState() {
    super.initState();
    dio = Dio();
    missionProvider = Provider.of<MissionInfoProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    childInfoProvider = Provider.of<ChildInfoProvider>(context, listen: false);
    childrenList = userProvider.childrenList;
    if (childrenList.isNotEmpty) {
      selectedMemberKey = childInfoProvider.memberKey ?? '';
    }
  }

  //데이터 보내기//
  Future<void> _sendMissionData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";
    var data = {
      "type": userType,
      "to": selectedMemberKey, //자식의 멤버키 필요
      "todo": missionProvider.missionTitle,
      "money": int.parse(missionProvider.amount ?? '0'),
      "cheeringMessage": comment, //부모의 응원메시지 필요
      "childRequestComment": "",
      "startDate": DateTime.now().toString().substring(0, 10),
      "endDate": missionProvider.missionDueDate
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
          Uri.parse("$_baseUrl/mission-service/api/$memberKey"),
          headers: headers,
          body: json.encode);
      if (response.statusCode == 200) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션생성 완료!",
        //               button: ConfirmBtn(
        //                 action: ParentMissionPage(),
        //               ),
        //             ))); //페이지터짐관련

        noEffectReplacementTransition(context, ParentMissionPage());

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(
        //               text: '미션 생성완료!',
        //               targetPage: ParentMissionPage(),
        //             )));
      }
      print(response);
    } catch (e) {
      print('Error: $e');
      print(data);
    }
  }

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '미션생성',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),

          //예쁜 드롭다운
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  '누구에게 미션을 줄까요?',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: roundedBoxWithShadowStyle(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButtonHideUnderline(
                      // 아래쪽의 기본 테두리를 숨깁니다.
                      child: DropdownButton<String>(
                        value: selectedMemberKey.isNotEmpty
                            ? selectedMemberKey
                            : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMemberKey = newValue ?? '';
                          });
                        },
                        dropdownColor: Colors.white, // 배경색
                        iconEnabledColor: Colors.purple, // 아이콘 색상
                        style: TextStyle(color: Colors.black), // 선택된 항목의 텍스트 색상
                        items: childrenList.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> child) {
                          return DropdownMenuItem<String>(
                            value: child["memberKey"].toString(),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/image/n_face.png',
                                  width: 50,
                                ), // 이미지 경로를 지정해야 합니다.
                                SizedBox(
                                  width: 10,
                                ), // 이미지와 텍스트 사이의 간격
                                Text(
                                  child["name"].toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          renderBoxFormField(
              label: '',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              },
              hintText: '아이에게 응원 메시지를 보내주세요!',
              maxLines: 5),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: "만들기",
        action: () {
          _sendMissionData();
        },
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
