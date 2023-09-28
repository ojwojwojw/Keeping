import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/number_keyboard.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/provider/mission_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _baseUrl = dotenv.env['BASE_URL'];

//미션 생성페이지 1
class MissionCreatePage1 extends StatefulWidget {
  const MissionCreatePage1({Key? key}) : super(key: key);

  @override
  State<MissionCreatePage1> createState() => _MissionCreatePage1State();
}

class _MissionCreatePage1State extends State<MissionCreatePage1> {
  // final _createKey = GlobalKey<FormState>();
  String? missionTitle;
  String? missionDueDate;
  TextEditingController _missionTitle = TextEditingController();
  bool _isButtonDisabled = true; // 버튼 활성화 여부
  bool _isTitleChecked = false; //  미션 제목 입력 여부
  bool _isDateChecked = false; //미션 마감 날짜 선택 여부
  DateTime dateValue = DateTime.now();

  TextEditingController _controller1 = TextEditingController();

  //버튼 활성화 관련
  handleCreateDisable() {
    if (_isTitleChecked && _isDateChecked) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
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
        _isDateChecked = true; // 날짜가 선택되면 _isDateChecked를 true로 설정
        handleCreateDisable(); // 버튼 활성화 상태 업데이트
        missionDueDate = picked.toString().substring(0, 10);
      });
    }
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
                  _isTitleChecked = value != null && value.isNotEmpty;
                  handleCreateDisable(); // 버튼 활성화 상태 업데이트
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
            '선택한 날짜: ${dateValue.toLocal().toString().substring(0, 10)}', // 선택한 날짜를 렌더링
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
        isDisabled: !_isTitleChecked || !_isDateChecked,
      ),
    );
  }

  Future<void> saveAndMove(context, todo, endDate) {
    // 프로바이더 데이터 업데이트
    print('!!!');
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
          // 2. 프로바이더 데이터 업데이트
          Provider.of<MissionInfoProvider>(context, listen: false)
              .saveMoneyData(amount);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MissionCreatePage3()),
          );
        },
        isDisabled: amount.isEmpty, // 금액이 없을 경우 버튼 비활성화
      ),
    );
  }
}

//////////////////////////////
//미션 생성페이지 3

class MissionCreatePage3 extends StatefulWidget {
  @override
  _MissionCreatePage3State createState() => _MissionCreatePage3State();
}

class _MissionCreatePage3State extends State<MissionCreatePage3> {
  TextEditingController _commentController = TextEditingController();
  Future<String?>? memberKeyFuture;

  @override
  void initState() {
    super.initState();
    memberKeyFuture = _fetchMemberKey();
  }

  Future<String?> _fetchMemberKey() async {
    var provider = Provider.of<UserInfoProvider>(context, listen: false);
    return provider.memberKey;
  }

  Future<String?> _fetchAccessToken() async {
    var provider = Provider.of<UserInfoProvider>(context, listen: false);
    return provider.accessToken;
  }

  _sendMissionData(String? memberKey) async {
    if (memberKey == null) {
      print('Member key is null');
      return;
    }

    String? accessToken = await _fetchAccessToken();
    if (accessToken == null) {
      print('Access token is null');
      return;
    }

    var missionProvider =
        Provider.of<MissionInfoProvider>(context, listen: false);
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    String userType = userProvider.parent ? "PARENT" : "CHILD";
    var dio = Dio();

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    var data = {
      "type": userType,
      "to": "", //부모는 무조건 한명이라 멤버키 불필요
      "todo": missionProvider.missionTitle,
      "money": int.parse(missionProvider.amount ?? '0'),
      "cheeringMessage": "", //부모의 응원메시지 불필요
      "childRequestComment": _commentController.text, // 입력폼에서 직접 받아야 한다
      "startDate": DateTime.now().toString().substring(0, 10),
      "endDate": missionProvider.missionDueDate
    };
    print(memberKey);
    print(data);
    print("$_baseUrl/mission-service/api/$memberKey");
    var response =
        await dio.post("$_baseUrl/mission-service/api/$memberKey", data: data);

    if (response.statusCode == 200) {
      print('Mission data sent successfully!');
    } else {
      print('Failed to send mission data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Mission Page 3"),
      ),
      body: FutureBuilder<String?>(
        future: memberKeyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching member key'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Mission Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              renderTextFormField(
                  label: '부모님에게 요청 메세지를 보내봐요',
                  controller: _commentController,
                  onChange: (value) {
                    Provider.of<MissionInfoProvider>(context, listen: false)
                        .childRequestComment = value;
                  }),

              // TextFormField(
              //   controller: _commentController,
              //   decoration: InputDecoration(labelText: 'childRequestComment'),
              //   onChanged: (value) {
              //     Provider.of<MissionInfoProvider>(context, listen: false)
              //         .childRequestComment = value;
              //   },
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _sendMissionData(snapshot.data),
                child: Text('Send Mission Data'),
              )
            ],
          );
        },
      ),
    );
  }
}
