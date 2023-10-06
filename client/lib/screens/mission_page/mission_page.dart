import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/mission_page/widgets/mission_color_info_card.dart';
import 'package:keeping/screens/mission_page/widgets/mission_filters.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/loading.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/mission_create_page/mission_create.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _baseUrl = dotenv.env['BASE_URL'];

// 자식 미션페이지 //
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissonPageState();
}

class _MissonPageState extends State<MissionPage> {
  List<Map<String, dynamic>> data = [];
  String? profileImage = '';
  String currentFilter = "ALL";
  int _selectedBtnIdx = 1;

  @override
  void initState() {
    super.initState();
    var userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    profileImage = userInfoProvider.profileImage;
  }

  void changeFilter(val) {
    setState(() {
      currentFilter = val;
    });
  }

  void _setSelectedBtnIdx(val) {
    setState(() {
      _selectedBtnIdx = val;
    });
  }

  //미션 상태변화 반영
  void onMissionDeleted() {
    setState(() {});
  }

  //새로고침
  void reload(){
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getData() async {
    // Dio 객체 생성
    final dio = Dio();
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;
    print(data);
    try {
      // GET 요청 보내기
      final response = await dio.get(
          "$_baseUrl/mission-service/api/$memberKey/$memberKey",
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      print(response.data);
      // 요청이 성공했을 때 처리
      if (response.statusCode == 200 && response.data['resultBody'] is List) {
        return List<Map<String, dynamic>>.from(response.data['resultBody']);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      // 요청이 실패했을 때 처리
      print('Error: $error');
      // print(response.data);
      return []; // 빈 리스트 반환
    }
  }

  // 미션 데이터를 선택된 상태에 따라 필터링하는 함수
  List<Map<String, dynamic>> filterMissionsByStatus(String status) {
    if (status == "ALL") {
      return data; // 모든 미션을 반환
    } else {
      return data.where((item) => item["completed"] == status).toList();
    }
  }

  //페이지 위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션',
        elementColor: Colors.black,
        backPath: ChildMainPage(),
      ),
      body: Column(
        children: [
          CreateMissonBox(),
          SizedBox(
            height: 10,
          ),
          MissionFilters(
            setFilter: changeFilter,
            setIdx: _setSelectedBtnIdx,
            Idx: _selectedBtnIdx
          ),
          FutureBuilder(
            // 비동기 데이터를 기다리고 UI를 구성
            future: getData(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // } else if (snapshot.hasError) {
              //   return Center(child: Text('에러 발생: ${snapshot.error}'));
              // } else {
              if (snapshot.hasData) {
                data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
                final filteredData = filterMissionsByStatus(currentFilter); // 여기에서 필터링을 적용합니다
                if (data == [] || data.isEmpty) {
                  return empty(text: '미션 내역이 없습니다.');
                }
                return Expanded(
                    child: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...filteredData.map((e) => MissionColorInfoCard(
                              status: e["completed"],
                              createdDate: DateTime.parse(e['startDate']),
                              todo: e['todo'],
                              item: e,
                              profileImage: profileImage,
                              onMissionDeleted: onMissionDeleted,
                            )),
                                        ],
                                      )),
                    ));
              } else {
                return loading();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

//부모 미션 페이지
class ParentMissionPage extends StatefulWidget {
  const ParentMissionPage({Key? key}) : super(key: key);

  @override
  State<ParentMissionPage> createState() => _ParentMissonPageState();
}

class _ParentMissonPageState extends State<ParentMissionPage> {
  List<Map<String, dynamic>> data = [];
  String currentFilter = "YET";
  int _selectedBtnIdx = 1;
  late String? profileImage;

  void changeFilter(val) {
    setState(() {
      currentFilter = val;
    });
  }

  void _setSelectedBtnIdx(val) {
    setState(() {
      _selectedBtnIdx = val;
    });
  }

  //미션 상태변화 반영
  void onMissionDeleted() {
    setState(() {});
  }

  //새로고침
  void reload(){
    setState(() {});
  }

  //새로고침
  void reload2(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var childInfoProvider =
        Provider.of<ChildInfoProvider>(context, listen: false);
    profileImage = childInfoProvider.profileImage;
  }

  //데이터 비동기 요청
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

  // 미션 데이터를 선택된 상태에 따라 필터링하는 함수
  List<Map<String, dynamic>> filterMissionsByStatus(String status) {
    if (status == "ALL") {
      return data; // 모든 미션을 반환
    } else {
      return data.where((item) => item["completed"] == status).toList();
    }
  }

  //페이지 위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션',
        elementColor: Colors.black,
        backPath: ParentMainPage(),
      ),
      body: Column(
        children: [
          CreateMissonBox(),
          SizedBox(
            height: 10,
          ),
          MissionFilters(
              setFilter: changeFilter,
              setIdx: _setSelectedBtnIdx,
              Idx: _selectedBtnIdx),
          FutureBuilder(
            // 비동기 데이터를 기다리고 UI를 구성
            future: getParentData(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: CircularProgressIndicator());
              // } else if (snapshot.hasError) {
              //   return Center(child: Text('에러 발생: ${snapshot.error}'));
              // } else {
              if (snapshot.hasData) {
                data = snapshot.data ?? []; // 여기에서 snapshot의 데이터를 받아옵니다.
                final filteredData = filterMissionsByStatus(currentFilter);
                if (data == [] || data.isEmpty) {
                  return empty(text: '미션 내역이 없습니다.');
                }
                return Expanded(
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...filteredData.map((e) => MissionColorInfoCard(
                            status: e["completed"],
                            createdDate: DateTime.parse(e['startDate']),
                            todo: e['todo'],
                            item: e,
                            profileImage: profileImage,
                            onMissionDeleted: onMissionDeleted,
                          )),
                                      ],
                                    )),
                  ));
              } else {
                return loading();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

// 새로운 미션 생성 버튼//
class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  //위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        style: ButtonStyle(
          // fixedSize: MaterialStateProperty.all(Size(400.0, 150.0)),
          backgroundColor: MaterialStateProperty.all(Color(0xFF805AF1)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20), // 원하는 둥글게 만들 모서리의 반지름 값. 15은 예시입니다.
            ),
          ),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (MissionCreatePage1()),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 19),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙에 배치하기 위해 사용
            children: [
              Image.asset(
                'assets/image/mission/new_mission.png',
                width: 100,
              ),
              Text('새로운 미션 만들기',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// 미션 생성 승인 입력 폼 페이지
class MissionApprovePage extends StatefulWidget {
  final int? missionId;
  final Map<String, dynamic> item;
  const MissionApprovePage(
      {super.key, required this.missionId, required this.item});

  @override
  State<MissionApprovePage> createState() => _MissionApprovePageState();
}

class _MissionApprovePageState extends State<MissionApprovePage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  ///CREATED_WAIT 상태인 미션을 YET으로 바꾸는 비동기 요청
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    final data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "YET"
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.patch(
          Uri.parse("$_baseUrl/mission-service/api/$memberKey/complete"),
          headers: headers,
          body: jsonEncode(data));
      print(response);

      if (response.statusCode == 200) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션승인 완료!",
        //               button: ConfirmBtn(
        //                 action: ParentMissionPage(),
        //               ),
        //             ))); //페이지터짐관련

        noEffectReplacementTransition(
            context,
            CompletedPage(
              text: "미션승인 완료!",
              button: ConfirmBtn(
                action: ParentMissionPage(),
              ),
            ));

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(text: '미션 승인완료!', targetPage: ParentMissionPage(),
        //             )));
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
        text: "미션 승인 페이지",
      ),
      body: Center(
        child: Column(
          children: [
            //둥근 모서리 박스
            Container(
              padding: EdgeInsets.all(8), // 텍스트 주변의 패딩 추가
              decoration: BoxDecoration(
                color: Color(0xFF6E2FD5), // 보라색 배경
                borderRadius: BorderRadius.circular(15), // 모서리 둥글기
              ),
              child: Text(
                '엄마와 나의 미션',
                style: TextStyle(
                  color: Colors.white, // 흰색 글씨
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            roundedAssetImg(
                imgPath: 'assets/image/mission/smile2.png',
                size: 160), //이모지 이미지 들어갈 곳

            SizedBox(
              height: 10,
            ),
            Text(
              widget.item['todo'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item['startDate'],
              style: TextStyle(color: Colors.grey),
            ),

            violetBoxFormField(
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
class MissionCompleteRequestPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int? missionId;
  const MissionCompleteRequestPage(
      {super.key, required this.missionId, required this.item});

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

  @override
  void initState() {
    super.initState();
    dio = Dio();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  ///YET 상태인 미션을 FINISH_WAIT으로 바꾸는 비동기 요청
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    final data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "FINISH_WAIT"
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.patch(
          Uri.parse("$_baseUrl/mission-service/api/$memberKey/complete"),
          headers: headers,
          body: jsonEncode(data));
      print(response);

      if (response.statusCode == 200) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션완료 요청완료!",
        //               button: ConfirmBtn(
        //                 action: MissionPage(),
        //               ),
        //             ))); //페이지터짐관련

        noEffectReplacementTransition(
            context,
            CompletedPage(
              text: "미션완료 요청완료!",
              button: ConfirmBtn(
                action: MissionPage(),
              ),
            ));

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(text: '미션 완료!', targetPage: MissionPage(),
        //             )));
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
        text: "미션 완료 승인 !",
      ),
      body: Center(
        child: Column(
          children: [
            //둥근 모서리 박스
            Container(
              padding: EdgeInsets.all(8), // 텍스트 주변의 패딩 추가
              decoration: BoxDecoration(
                color: Color(0xFF6E2FD5), // 보라색 배경
                borderRadius: BorderRadius.circular(15), // 모서리 둥글기
              ),
              child: Text(
                '엄마와 나의 미션일기',
                style: TextStyle(
                  color: Colors.white, // 흰색 글씨
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            roundedAssetImg(
                imgPath: 'assets/image/mission/smile2.png',
                size: 160), //이모지 이미지 들어갈 곳

            SizedBox(
              height: 10,
            ),
            Text(
              widget.item['todo'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item['startDate'],
              style: TextStyle(color: Colors.grey),
            ),

            // violetBoxFormField(
            //     hintText: "완료 메시지를 적어봐요",
            //     onChange: (value) {
            //       setState(() {
            //         comment = value;
            //       });
            //     })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 완료 요청 하기",
        action: _sendData,
        isDisabled: false,
      ),
    );
  }
}

// 미션 완료 승인 폼 페이지
class MissionCompletePage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int? missionId;
  const MissionCompletePage(
      {super.key, required this.missionId, required this.item});

  @override
  State<MissionCompletePage> createState() => _MissionCompletePageState();
}

class _MissionCompletePageState extends State<MissionCompletePage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  ///FINISH_WAIT 상태인 미션을 FINISH로 바꾸는 비동기 요청
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    final data = {
      "type": userType,
      "missionId": widget.missionId,
      "cheeringMessage": comment,
      "completed": "FINISH"
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    print('$data 데이터!!!!!!!!');
    try {
      var response = await http.patch(
          Uri.parse("$_baseUrl/mission-service/api/$memberKey/complete"),
          headers: headers,
          body: jsonEncode(data));
      print(response);

      if (response.statusCode == 200) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션완료 승인완료!",
        //               button: ConfirmBtn(
        //                 action: ParentMissionPage(),
        //               ),
        //             )));

        noEffectReplacementTransition(
            context,
            CompletedPage(
              text: "미션완료 승인완료!",
              button: ConfirmBtn(
                action: ParentMissionPage(),
              ),
            ));

        //페이지터짐관련
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(text: '승인 완료!', targetPage: ParentMissionPage(),
        //             )));
      }
    } catch (e) {
      print('Error: $e');
      print(data);
    }
  }

  //위젯 빌드,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "미션 완료 승인 !",
      ),
      body: Center(
        child: Column(
          children: [
            //둥근 모서리 박스
            Container(
              padding: EdgeInsets.all(8), // 텍스트 주변의 패딩 추가
              decoration: BoxDecoration(
                color: Color(0xFF6E2FD5), // 보라색 배경
                borderRadius: BorderRadius.circular(15), // 모서리 둥글기
              ),
              child: Text(
                '엄마와 나의 미션일기',
                style: TextStyle(
                  color: Colors.white, // 흰색 글씨
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            roundedAssetImg(
                imgPath: 'assets/image/mission/smile2.png',
                size: 160), //이모지 이미지 들어갈 곳

            SizedBox(
              height: 10,
            ),
            Text(
              widget.item['todo'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item['startDate'],
              style: TextStyle(color: Colors.grey),
            ),

            // violetBoxFormField(

            //     hintText: "완료 승인 메세지를 적어봐요",
            //     onChange: (value) {
            //       setState(() {
            //         comment = value;
            //       });
            //     })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "미션 완료 승인 하기",
        action: _sendData,
        isDisabled: false,
      ),
    );
  }
}

// 미션 완료 커멘트 폼 페이지
class MissionCompleteCommentPage extends StatefulWidget {
  final int? missionId;
  final Map<String, dynamic> item;
  const MissionCompleteCommentPage(
      {super.key, required this.missionId, required this.item});

  @override
  State<MissionCompleteCommentPage> createState() =>
      _MissionCompleteCommentPageState();
}

class _MissionCompleteCommentPageState
    extends State<MissionCompleteCommentPage> {
  String comment = '';
  late Dio dio;
  late UserInfoProvider userProvider;
  late List<Map<String, dynamic>> childrenList;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  }

  ///FINISH_WAIT 상태인 미션을 FINISH로 바꾸는 비동기 요청
  Future<void> _sendData() async {
    var accessToken = userProvider.accessToken;
    var memberKey = userProvider.memberKey;
    var userType = userProvider.parent ? "PARENT" : "CHILD";

    final data = {"missionId": widget.missionId, "comment": comment};

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.patch(
        Uri.parse("$_baseUrl/mission-service/api/$memberKey/comment"),
        headers: headers,
        body: jsonEncode(data),
      );
      print(response);

      if (response.statusCode == 200) {
        print('커멘트 200');
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedPage(
        //               text: "미션완료 승인완료!",
        //               button: ConfirmBtn(
        //                 action: MissionPage(),
        //               ),
        //             ))); //페이지터짐관련

        noEffectReplacementTransition(
            context,
            CompletedPage(
              text: "미션완료 승인완료!",
              button: ConfirmBtn(
                action: MissionPage(),
              ),
            ));

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CompletedAndGoPage(text: '기억하기 완료!', targetPage: MissionPage(),
        //             )));
      }
    } catch (e) {
      print('Error: $e');
      print(data);
    }
  }

  //위젯 빌드,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: "완료 소감을 작성해요!",
      ),
      body: Center(
        child: Column(
          children: [
            //둥근 모서리 박스
            Container(
              padding: EdgeInsets.all(8), // 텍스트 주변의 패딩 추가
              decoration: BoxDecoration(
                color: Color(0xFF6E2FD5), // 보라색 배경
                borderRadius: BorderRadius.circular(15), // 모서리 둥글기
              ),
              child: Text(
                '엄마와 나의 미션',
                style: TextStyle(
                  color: Colors.white, // 흰색 글씨
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            roundedAssetImg(
                imgPath: 'assets/image/mission/smile2.png',
                size: 160), //이모지 이미지 들어갈 곳

            SizedBox(
              height: 10,
            ),
            Text(
              widget.item['todo'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item['startDate'],
              style: TextStyle(color: Colors.grey),
            ),

            violetBoxFormField(
                hintText: "완료 커멘트를 남겨봐요",
                onChange: (value) {
                  setState(() {
                    comment = value;
                  });
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: "기억하기",
        action: _sendData,
        isDisabled: comment.isEmpty,
      ),
    );
  }
}
