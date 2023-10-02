import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';

import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/mission_create_page/mission_create.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/widgets/completed_page.dart';

final _baseUrl = dotenv.env['BASE_URL'];

// 자식 미션페이지 //
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissonPageState();
}

class _MissonPageState extends State<MissionPage> {
  List<Map<String, dynamic>> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션 (자녀)',
        elementColor: Colors.black,
        backPath: ChildMainPage(),
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
                  CreateMissonBox(),
                  SizedBox(
                    height: 10,
                  ),
                  FilteringBar(),
                  missionData(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //미션 데이터를 리스트뷰로 랜더링 하는 위젯
  Widget missionData(data) {
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
                builder: (context) => MissionDetailPage(
                    item: item), // DetailPage는 새로운 페이지의 위젯입니다.
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
            decoration: BoxDecoration(
              color: (item["completed"] == "CREATE_WAIT")
                  ? Color.fromRGBO(255, 170, 170, 1)
                  : (item["completed"] == "YET")
                      ? Color.fromRGBO(255, 255, 170, 1)
                      : (item["completed"] == "FINISH_WAIT")
                          ? Color.fromRGBO(170, 255, 255, 1)
                          : Color.fromRGBO(170, 255, 170, 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Text('#' + (index + 1).toString()),
                Text(
                  item["todo"],
                  style: TextStyle(
                    fontSize: 18.0, // 텍스트 크기 변경
                    fontWeight: FontWeight.bold, // 텍스트 굵게 만들기
                  ),
                ),
                SizedBox(height: 16.0), // 텍스트 사이에 간격 추가
                Text(
                  item["startDate"],
                  style: TextStyle(
                    fontSize: 8.0, // 텍스트 크기 변경
                    color: Colors.black, // 텍스트 색상 변경
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )));
  }
  //미션 데이터를 최초로 가져오는 비동기 요청

  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/mission-service/api/$memberKey/$memberKey",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && response.data['resultBody'] is List) {
        return List<Map<String, dynamic>>.from(response.data['resultBody']);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 빈 리스트 반환
    }
  }
}

////////////////
////////////////
//부모 미션 페이지
class ParentMissionPage extends StatefulWidget {
  const ParentMissionPage({Key? key}) : super(key: key);

  @override
  State<ParentMissionPage> createState() => _ParentMissonPageState();
}

class _ParentMissonPageState extends State<ParentMissionPage> {
  List<Map<String, dynamic>> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션(부모)',
        elementColor: Colors.black,
        backPath: ParentMainPage(),
      ),
      body: FutureBuilder(
        // 비동기 데이터를 기다리고 UI를 구성
        future: getParentData(),
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
                  CreateMissonBox(),
                  SizedBox(
                    height: 10,
                  ),
                  FilteringBar(),
                  parentMissionData(data),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //미션 데이터를 리스트뷰로 랜더링 하는 위젯
  Widget parentMissionData(data) {
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
                builder: (context) => ParentMissionDetailPage(
                    item: item), // DetailPage는 새로운 페이지의 위젯입니다.
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 2.0), // 위 아래 여백 추가
            decoration: BoxDecoration(
              color: (item["completed"] == "CREATE_WAIT")
                  ? Color.fromRGBO(255, 170, 170, 1)
                  : (item["completed"] == "YET")
                      ? Color.fromRGBO(255, 255, 170, 1)
                      : (item["completed"] == "FINISH_WAIT")
                          ? Color.fromRGBO(170, 255, 255, 1)
                          : Color.fromRGBO(170, 255, 170, 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('#' + (index + 1).toString()),
                    Text(item["completed"] == "CREATE_WAIT"
                        ? "생성 대기"
                        : item["completed"] == "YET"
                            ? "미완료"
                            : item["completed"] == "FINISH_WAIT"
                                ? "완료 대기"
                                : item["completed"] == "FINISH"
                                    ? "완료"
                                    : "알 수 없는 상태"),
                  ],
                ),

                Text(
                  item["todo"],
                  style: TextStyle(
                    fontSize: 18.0, // 텍스트 크기 변경
                    fontWeight: FontWeight.bold, // 텍스트 굵게 만들기
                  ),
                ),
                SizedBox(height: 16.0), // 텍스트 사이에 간격 추가
                Text(
                  item["startDate"],
                  style: TextStyle(
                    fontSize: 8.0, // 텍스트 크기 변경
                    color: Colors.black, // 텍스트 색상 변경
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )));
  }
  //미션 데이터를 최초로 가져오는 비동기 요청

  Future<List<Map<String, dynamic>>> getParentData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var childInfoProvider =
        Provider.of<ChildInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var childMemberKey = childInfoProvider.memberKey;
    var accessToken = userProvider.accessToken;
    print('디버깅?!?');
    print(memberKey);
    print(accessToken);

    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/mission-service/api/$memberKey/$childMemberKey",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && response.data['resultBody'] is List) {
        return List<Map<String, dynamic>>.from(response.data['resultBody']);
      } else {
        return []; // 안전한 값 반환
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      return []; // 안전한 값 반환
    }
  }
}

// 새로운 미션 생성 버튼//
class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(400.0, 150.0)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF8320E7)),
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (MissionCreatePage1()),
          ),
        );
      },
      child:
          (Center(child: Text('새로운 미션 만들기', style: TextStyle(fontSize: 20)))),
    );
  }
}

//////////////////////
//자녀 미션 상세조회 페이지//
class MissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const MissionDetailPage({super.key, required this.item});

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  late bool isParent = userProvider.parent;
//하단 버튼 랜더링과 동작 로직 관련

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isParent = userProvider.parent;
  }

  String getBottomButtonText(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return "미션 생성 승인";
      case "YET":
        return "미션 완료 요청 ";
      case "FINISH_WAIT":
        return "미션 완료 승인";
      case "FINISH":
        return "완료된 미션입니다.";
      default:
        return "NULL";
    }
  }

  void handleButtonClick(String status) {
    switch (status) {
      case "CREATE_WAIT":
        // 미션 생성 승인 로직
        break;
      case "YET":
        // 미션 진행 확인 로직
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MissionCompleteRequestPage(
                      missionId: widget.item["id"],
                    ))); //미션 id 넘겨주는곳
        break;
      case "FINISH_WAIT":
        // 미션 완료 승인 로직
        break;
      case "FINISH":
        // 미션 확인 로직
        break;
      default:
        // 기본 로직
        break;
    }
  }
  ////

  ///CREATED_WAIT 상태인 미션을 YET으로 바꾸기
  Future<void> missionApprove() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    try {
      var response = await dio.get(
          "$_baseUrl/mission-service/api/$memberKey/complete",
          options: Options(headers: {"Authorization": "Bearer  $accessToken"}));
      print(response);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "미션상세조회"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 250, 1.0), // 연보라색
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    // 상태를 한글로 직접 변환하는 로직
                    {
                          "CREATE_WAIT": "생성 대기중",
                          "YET": "미완료",
                          "FINISH_WAIT": "완료 대기중",
                          "FINISH": "완료",
                        }[widget.item["completed"]] ??
                        "알 수 없는 상태",
                    style:
                        TextStyle(fontSize: 16.0, color: Colors.purple), // 보라색
                  ),
                ),
                Text(
                  widget.item["todo"],
                  style: TextStyle(fontSize: 20.0), // 폰트 크기를 20.0으로 변경
                ),
                Text(
                  widget.item["money"].toString() + '원',
                  style: TextStyle(
                    fontSize: 24.0, // 폰트 크기를 24.0으로 변경 (todo보다 큰 크기)
                    color: Colors.purple, // 글씨를 보라색으로 변경
                  ),
                ),
                SizedBox(height: 10.0),
                Text("아이의 프로필 이미지"),
                SizedBox(
                  height: 200,
                ),
                Text(
                  widget.item["cheeringMessage"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                //// 자식의 메세지가 null이면 랜더링을 못한다
                widget.item["childComment"] != null
                    ? Text(
                        widget.item["childComment"],
                        style: TextStyle(fontSize: 16.0),
                      )
                    : SizedBox(),
                /////
                SizedBox(height: 10.0),
                Text(
                  "시작일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["startDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "종료일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["endDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),

                Text(
                  widget.item["completed"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "생성일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["createdDate"].toString().substring(0, 10),
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: getBottomButtonText(widget.item["completed"]),
        action: () => handleButtonClick(widget.item["completed"]),
        isDisabled: () {
          String status = widget.item["completed"];

          if (status == "CREATE_WAIT" && !isParent) {
            return true; // 자녀는 비활성화
          } else if (status == "YET" && isParent) {
            return true; // 부모는 비활성화
          } else if (status == "FINISH_WAIT" && !isParent) {
            return true; // 자녀는 비활성화
          } else if (status == "FINISH" && isParent) {
            return true; // 부모는 비활성화
          }

          return false; // 기본값은 활성화
        }(),
      ),
    );
  }
}

/////////////////////
///////////////////
//부모 미션 상세 조회 페이지
class ParentMissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const ParentMissionDetailPage({super.key, required this.item});

  @override
  State<ParentMissionDetailPage> createState() =>
      _ParentMissionDetailPageState();
}

class _ParentMissionDetailPageState extends State<ParentMissionDetailPage> {
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;
  late bool isParent = userProvider.parent;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isParent = userProvider.parent;
  }

  //하단 버튼 랜더링과 동작 로직 관련
  String getBottomButtonText(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return "미션 생성 승인";
      case "YET":
        return "미션 완료 요청";
      case "FINISH_WAIT":
        return "미션 완료 승인";
      case "FINISH":
        return "완료된 미션입니다.";
      default:
        return "미션 승인하기";
    }
  }

  void handleButtonClick(String status) {
    switch (status) {
      case "CREATE_WAIT":
        // 미션 생성 승인 로직
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MissionApprovePage(
                      missionId: widget.item["id"],
                    ))); //미션 id 넘겨주는곳
        break;
      case "YET":
        // 미션 진행 확인 로직
        break;
      case "FINISH_WAIT":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MissionCompletePage(
                      missionId: widget.item["id"],
                    ))); //미션 id 넘겨주는곳
        // 미션 완료 승인 로직
        break;
      case "FINISH":
        // 미션 확인 로직
        break;
      default:
        // 기본 로직
        break;
    }
  }
  ////

  ///
  @override
  void didChangeDependencies() {
    dio = Dio();
    super.didChangeDependencies();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "미션상세조회(부모)"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 250, 1.0), // 연보라색
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    // 상태를 한글로 직접 변환하는 로직
                    {
                          "CREATE_WAIT": "생성 대기중",
                          "YET": "미완료",
                          "FINISH_WAIT": "완료 대기중",
                          "FINISH": "완료",
                        }[widget.item["completed"]] ??
                        "알 수 없는 상태",
                    style:
                        TextStyle(fontSize: 16.0, color: Colors.purple), // 보라색
                  ),
                ),
                Text(
                  widget.item["todo"],
                  style: TextStyle(fontSize: 20.0), // 폰트 크기를 20.0으로 변경
                ),
                Text(
                  widget.item["money"].toString() + '원',
                  style: TextStyle(
                    fontSize: 24.0, // 폰트 크기를 24.0으로 변경 (todo보다 큰 크기)
                    color: Colors.purple, // 글씨를 보라색으로 변경
                  ),
                ),
                SizedBox(height: 10.0),
                Text("아이의 프로필 이미지"),
                SizedBox(
                  height: 100,
                ),
                Text("부모의 응원 메세지"),
                Text(
                  widget.item["cheeringMessage"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                //// 자식의 메세지가 null이면 랜더링을 못한다
                Text("자식의 완료 메세지"),
                widget.item["childComment"] != null
                    ? Text(
                        widget.item["childComment"],
                        style: TextStyle(fontSize: 16.0),
                      )
                    : SizedBox(),
                /////
                SizedBox(height: 10.0),
                Text(
                  "시작일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["startDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "종료일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["endDate"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),

                Text(
                  widget.item["completed"],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  "생성일:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.item["createdDate"].toString().substring(0, 10),
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: getBottomButtonText(widget.item["completed"]),
        action: () => handleButtonClick(widget.item["completed"]),
        isDisabled: () {
          String status = widget.item["completed"];

          if (status == "CREATE_WAIT" && !isParent) {
            return true; // 자녀는 비활성화
          } else if (status == "YET" && isParent) {
            return true; // 부모는 비활성화
          } else if (status == "FINISH_WAIT" && !isParent) {
            return true; // 자녀는 비활성화
          } else if (status == "FINISH" && isParent) {
            return true; // 부모는 비활성화
          }

          return false; // 기본값은 활성화
        }(),
      ),
    );
  }
}

//필터링 바//
class FilteringBar extends StatelessWidget {
  const FilteringBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 20,
        color: Colors.purple,
        child: (Column(children: [
          Text('필터링 바', style: TextStyle(color: Colors.white, fontSize: 10)),
        ])));
  }
}

// 미션 생성 승인 입력 폼 페이지
class MissionApprovePage extends StatefulWidget {
  final int? missionId;
  const MissionApprovePage({super.key, required this.missionId});

  @override
  State<MissionApprovePage> createState() => _MissionApprovePageState();
}

class _MissionApprovePageState extends State<MissionApprovePage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  ///CREATED_WAIT 상태인 미션을 YET으로 바꾸기
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    var data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "YET"
    };

    try {
      var response = await dio.patch(
          "$_baseUrl/mission-service/api/$memberKey/complete",
          data: data,
          options: Options(headers: {"Authorization": "Bearer  $accessToken"}));
      print(response);

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "미션승인 완료!",
                      targetPage: ParentMissionPage(),
                    )));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "미션 승인 페이지",
      ),
      body: Center(
        child: Column(
          children: [
            renderTextFormField(
                label: "응원 메시지를 적어봐요",
                hintText: "응원 메시지를 적어봐요",
                onChange: (value) {
                  setState(() {
                    comment = value;
                  });
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 생성 승인 하기",
        action: _sendData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

// 미션 완료 요청 폼 페이지
////////////////////////////
class MissionCompleteRequestPage extends StatefulWidget {
  final int? missionId;
  const MissionCompleteRequestPage({super.key, required this.missionId});

  @override
  State<MissionCompleteRequestPage> createState() =>
      _MissionCompleteRequestPageState();
}

class _MissionCompleteRequestPageState
    extends State<MissionCompleteRequestPage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  ///YET 상태인 미션을 FINISH_WAIT으로 바꾸기
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    var data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "FINISH_WAIT"
    };

    try {
      var response = await dio.patch(
          "$_baseUrl/mission-service/api/$memberKey/complete",
          data: data,
          options: Options(headers: {"Authorization": "Bearer  $accessToken"}));
      print(response);

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "미션완료 요청완료!",
                      targetPage: MissionPage(),
                    )));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "미션 완료 요청 페이지",
      ),
      body: Center(
        child: Column(
          children: [
            renderTextFormField(
                label: "완료 메시지를 적어봐요",
                hintText: "완료 메시지를 적어봐요",
                onChange: (value) {
                  setState(() {
                    comment = value;
                  });
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 완료 요청 하기",
        action: _sendData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}

// 미션 완료 폼 페이지
////////////////////////////
class MissionCompletePage extends StatefulWidget {
  final int? missionId;
  const MissionCompletePage({super.key, required this.missionId});

  @override
  State<MissionCompletePage> createState() => _MissionCompletePageState();
}

class _MissionCompletePageState extends State<MissionCompletePage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  ///FINISH_WAIT 상태인 미션을 FINISH로 바꾸기
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    var data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "FINISH"
    };

    try {
      var response = await dio.patch(
          "$_baseUrl/mission-service/api/$memberKey/complete",
          data: data,
          options: Options(headers: {"Authorization": "Bearer  $accessToken"}));
      print(response);

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "미션완료 승인완료!",
                      targetPage: ParentMissionPage(),
                    )));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "미션 완료 요청 페이지",
      ),
      body: Center(
        child: Column(
          children: [
            renderTextFormField(
                label: "완료 승인메세지를 적어봐요",
                hintText: "완료 승인 메세지를 적어봐요",
                onChange: (value) {
                  setState(() {
                    comment = value;
                  });
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 완료 승인 하기",
        action: _sendData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
