import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
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

  //다음 페이지로 가는 버튼에 넣어줄 동작들
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '미션생성',
        elementColor: Colors.white,
      ),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 50,
          ),

          Text(
            '아이에게 어떤 미션을 줘볼까요?',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 24), // 좌우 여백 24
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 검정색으로 변경
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: renderTextFormField(
                label: '미션 제목 입력',
                hintText: '내용을 입력해주세요.',
                onChange: (value) {
                  setState(() {
                    missionTitle = value;
                  });
                }),
          ),

          SizedBox(
            height: 100,
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 24), // 좌우 여백 24
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 검정색으로 변경
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity, // 가로폭 최대로 설정
                  color: Colors.grey,
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16), // 패딩 조절
                  child: Text(
                    '미션 마감일을 정해줘요.',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  "선택한 날짜: $missionDueDate",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: datePicker,
                  child: Text('날짜를 선택해주세요.'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          // ... 나머지 부분
        ]),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {
          saveAndMove(context, missionTitle, missionDueDate); // 함수 호출
        },
        isDisabled: missionTitle.isEmpty || missionDueDate.isEmpty,
      ),
    );
  }
}

/////////////////////////////////////
//미션 생성페이지 2
class MissionCreatePage2 extends StatefulWidget {
  const MissionCreatePage2({super.key});

  @override
  State<MissionCreatePage2> createState() => _MissionCreatePage2State();
}

class _MissionCreatePage2State extends State<MissionCreatePage2> {
  String amount = '';
  bool isParent = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '미션생성2'),
      body: Center(
        child: Column(children: [
          Text('성공하면 얼마를 줄까요?'),

          // 예시 이미지 파일
          Icon(
            Icons.money_outlined,
            color: Colors.yellow,
            size: 240.0,
            semanticLabel: 'test',
          ),

          // 숫자패드
          Text(amount),
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

//////////////////////////////
//미션 생성페이지 3 (자녀)

class MissionCreatePage3 extends StatefulWidget {
  @override
  _MissionCreatePage3State createState() => _MissionCreatePage3State();
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

    try {
      final response = await dio.post(
          "$_baseUrl/mission-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('미션생성 데이터 전송 성공!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "미션생성 완료!",
                      targetPage: MissionPage(),
                    )));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '미션생성3(자녀)'),
      body: Column(
        children: [
          renderTextFormField(
              label: '부모님께 메세지를 보내봐요',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              }),
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

/////////////////////////////
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

  //Post 요청//
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

    try {
      final response = await dio.post(
          "$_baseUrl/mission-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "미션생성 완료!",
                      targetPage: ParentMissionPage(),
                    )));
      }
      print(response);
    } catch (e) {
      print('Error: $e');
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '미션생성3(부모)'),
      body: Column(
        children: [
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
              label: '아이에게 응원메세지를 보내봐요',
              onChange: (value) {
                setState(() {
                  comment = value;
                });
              }),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 등록 하기",
        action: () {
          _sendMissionData();
        },
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
