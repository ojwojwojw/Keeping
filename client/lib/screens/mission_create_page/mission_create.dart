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
            style: TextStyle(color: Colors.white),
          ),

          // 입력 폼
          renderTextFormField(
              label: '미션 제목 입력',
              onChange: (value) {
                setState(() {
                  missionTitle = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '필수 항목입니다';
                } else if (value.length < 1) {
                  return '제목은 1자 이상이 되어야 합니다.';
                } else if (value.length > 30) {
                  return '제목은 30자 이하가 되어야 합니다.';
                }

                return null;
              },
              controller: _missionTitle),

          SizedBox(
            height: 100,
          ),

          // 선택한 날짜 렌더링
          Text(
            "선택한 날짜: $missionDueDate", // 선택한 날짜를 렌더링
            style: TextStyle(color: Colors.white),
          ),

          //달력 들어갈곳
          Text('미션 마감일을 정해줘요.', style: TextStyle(color: Colors.white)),
          ElevatedButton(onPressed: datePicker, child: Text('누르면 달력나와요')),

          // 다음 페이지로 가는 버튼
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
          Container(
            width: 300,
            height: 300,
            child: Image.asset('./assets/image/temp_image.jpg'),
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
  TextEditingController _commentController = TextEditingController();
  late Dio dio;
  late MissionInfoProvider missionProvider;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  String parentMemberKey = '';

  //부모키 가져오기//
  Future<void> _getParentMemberKey() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    print(accessToken);
    print(memberKey);
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
    var dio = Dio();

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
      "childRequestComment": _commentController.text,
      "startDate": DateTime.now().toString().substring(0, 10),
      "endDate": missionProvider.missionDueDate
    };

    try {
      final response = await dio.post(
          "$_baseUrl/mission-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      if (response.statusCode == 200) {
        print('Mission data sent successfully!');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MissionPage()));
      } else {
        print('Failed to send mission data.');
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
          _renderTextFormField(
              label: '부모님께 메세지를 보내봐요',
              controller: _commentController,
              onChange: (value) {
                setState(() {
                  _commentController.text = value;
                });
              }),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendMissionData,
            child: Text('Send Mission Data'),
          ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: "다음",
        isDisabled: _commentController.text.isEmpty,
        action: () {
          _sendMissionData();
        },
      ),
    );
  }

  Widget _renderTextFormField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        decoration: InputDecoration(
          labelText: label,
        ),
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
  TextEditingController _commentController = TextEditingController();
  late Dio dio;
  late MissionInfoProvider missionProvider;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  String selectedMemberKey = '';

  @override
  void initState() {
    super.initState();
    dio = Dio();
    missionProvider = Provider.of<MissionInfoProvider>(context, listen: false);
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    childrenList = userProvider.childrenList;
    if (childrenList.isNotEmpty) {
      selectedMemberKey = childrenList.first['memberKey'] ?? '';
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
      "cheeringMessage": _commentController.text, //부모의 응원메시지 필요
      "childRequestComment": "",
      "startDate": DateTime.now().toString().substring(0, 10),
      "endDate": missionProvider.missionDueDate
    };

    try {
      final response = await dio.post(
          "$_baseUrl/mission-service/api/$memberKey",
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
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
          ///
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
          _renderTextFormField(
              label: '아이에게 응원메세지를 보내봐요',
              controller: _commentController,
              onChange: (value) {
                setState(() {
                  _commentController.text = value;
                });
              }),
          SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _sendMissionData,
          //   child: Text('Send Mission Data'),
          // ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 등록 하기",
        action: () {
          _sendMissionData();
        },
        isDisabled: _commentController.text.isEmpty,
      ),
    );
  }

  Widget _renderTextFormField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
