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
import 'package:keeping/widgets/bottom_nav.dart';

final _baseUrl = dotenv.env['BASE_URL'];

// 자식 미션페이지 //
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissonPageState();
}

class _MissonPageState extends State<MissionPage> {
  List<Map<String, dynamic>> data = [];
  String currentFilter = "ALL";

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

  // 필터링 바
  Widget filterBar() {
    Map<String, String> filters = {
      "ALL": "전체",
      "YET": "미완료",
      "CREATE_WAIT": "생성 대기",
      "FINISH_WAIT": "완료 대기",
      "FINISH": "완료"
    };

    return Container(
      height: 30.0, // 높이를 조정하여 바를 얇게 만듭니다.
      color: Colors.purple,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.keys.length,
        itemBuilder: (BuildContext context, int index) {
          String key = filters.keys.elementAt(index);
          return InkWell(
            onTap: () {
              setState(() {
                currentFilter = key;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 2.0), // 위젯의 패딩 조절
              child: Container(
                decoration: BoxDecoration(
                  color: currentFilter == key ? Colors.purple[800] : null,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.topCenter, // 글자를 위에 떠있게 만듭니다.
                    child: Text(
                      filters[key]!, // 한글로 매핑된 값을 사용합니다.
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
            final filteredData =
                filterMissionsByStatus(currentFilter); // 여기에서 필터링을 적용합니다
            return Center(
              child: Column(
                children: [
                  CreateMissonBox(),
                  SizedBox(
                    height: 10,
                  ),
                  filterBar(),
                  missionData(filteredData),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  // 상태를 한글로 매핑해주는 함수
  String mapStatusToKorean(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return "생성 승인 대기중...";
      case "YET":
        return "미션 진행중...";
      case "FINISH_WAIT":
        return "승인 요청이 왔어요!";
      case "FINISH":
        return "미션완료!";
      default:
        return "알 수 없음";
    }
  }

  //미션 데이터를 리스트뷰로 랜더링 하는 위젯
  Widget missionData(data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MissionDetailPage(item: item),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    mapStatusToKorean(item["completed"]), // 매핑 함수 사용
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 400,
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item["completed"]),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // 가로 방향으로 가운데 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 세로 방향으로 가운데 정렬
                        children: [
                          // Text('#' + (index + 1).toString()),

                          Text(
                            item["startDate"],
                            style: TextStyle(
                              fontSize: 8.0,
                              color: item["completed"] == "FINISH_WAIT"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          Text(
                            item["todo"].length > 15
                                ? item["todo"].substring(0, 15) + '...'
                                : item["todo"],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: item["completed"] == "FINISH_WAIT"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          Image.asset(
                            'assets/image/right_arrow.png',
                            width: 20.0,
                            height: 100.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //색깔 매핑
  Color _getStatusColor(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return Color(0xFFDFDFDF); // 16진수로 회색 지정
      case "YET":
        return Color(0xFFFF6262); // 16진수로 빨강 지정
      case "FINISH_WAIT":
        return Color(0xFF8320E7); // 16진수로 보라 지정
      case "FINISH":
        return Color(0xFF55FF55); // 16진수로 초록 지정
      default:
        return Colors.black;
    }
  }
  //미션 데이터를 최초로 가져오는 비동기 요청

  
}



//부모 미션 페이지
class ParentMissionPage extends StatefulWidget {
  const ParentMissionPage({Key? key}) : super(key: key);

  @override
  State<ParentMissionPage> createState() => _ParentMissonPageState();
}

class _ParentMissonPageState extends State<ParentMissionPage> {
  List<Map<String, dynamic>> data = [];
  String currentFilter = "ALL";

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

  // 필터링 바
  Widget filterBar() {
    Map<String, String> filters = {
      "ALL": "전체",
      "YET": "미완료",
      "CREATE_WAIT": "생성 대기",
      "FINISH_WAIT": "완료 대기",
      "FINISH": "완료"
    };

    return Container(
      height: 30.0, // 높이를 조정하여 바를 얇게 만듭니다.
      color: Colors.purple,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.keys.length,
        itemBuilder: (BuildContext context, int index) {
          String key = filters.keys.elementAt(index);
          return InkWell(
            onTap: () {
              setState(() {
                currentFilter = key;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 2.0), // 위젯의 패딩 조절
              child: Container(
                decoration: BoxDecoration(
                  color: currentFilter == key ? Colors.purple[800] : null,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.topCenter, // 글자를 위에 떠있게 만듭니다.
                    child: Text(
                      filters[key]!, // 한글로 매핑된 값을 사용합니다.
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
            final filteredData = filterMissionsByStatus(currentFilter);
            return Center(
              child: Column(
                children: [
                  CreateMissonBox(),
                  SizedBox(
                    height: 10,
                  ),
                  filterBar(),
                  parentMissionData(filteredData),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  // 상태를 한글로 매핑해주는 함수
  String mapStatusToKorean(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return "생성 승인 대기중...";
      case "YET":
        return "미션 진행중...";
      case "FINISH_WAIT":
        return "승인 요청이 왔어요!";
      case "FINISH":
        return "미션완료!";
      default:
        return "알 수 없음";
    }
  }

  //미션 데이터를 리스트뷰로 랜더링 하는 위젯
  Widget parentMissionData(data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ParentMissionDetailPage(item: item),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    mapStatusToKorean(item["completed"]), // 매핑 함수 사용
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 400,
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item["completed"]),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // 가로 방향으로 가운데 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 세로 방향으로 가운데 정렬
                        children: [
                          // Text('#' + (index + 1).toString()),

                          Text(
                            item["startDate"],
                            style: TextStyle(
                              fontSize: 8.0,
                              color: item["completed"] == "FINISH_WAIT"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          Text(
                            item["todo"].length > 15
                                ? item["todo"].substring(0, 15) + '...'
                                : item["todo"],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: item["completed"] == "FINISH_WAIT"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          Image.asset(
                            'assets/image/right_arrow.png',
                            width: 20.0,
                            height: 100.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //색깔 매핑
  Color _getStatusColor(String status) {
    switch (status) {
      case "CREATE_WAIT":
        return Color(0xFFDFDFDF); // 16진수로 회색 지정
      case "YET":
        return Color(0xFFFF6262); // 16진수로 빨강 지정
      case "FINISH_WAIT":
        return Color(0xFF8320E7); // 16진수로 보라 지정
      case "FINISH":
        return Color(0xFF55FF55); // 16진수로 초록 지정
      default:
        return Colors.black;
    }
  }
  //미션 데이터를 최초로 가져오는 비동기 요청

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
          fixedSize: MaterialStateProperty.all(Size(400.0, 150.0)),
          backgroundColor: MaterialStateProperty.all(Color(0xFF8320E7)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15), // 원하는 둥글게 만들 모서리의 반지름 값. 15은 예시입니다.
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙에 배치하기 위해 사용
          children: [
            Container(
              width: 40, // 네모 박스의 가로 길이 설정
              height: 40, // 네모 박스의 세로 길이 설정
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2), // 테두리 설정
                borderRadius: BorderRadius.circular(5), // 네모 박스의 모서리 둥글게 설정
              ),
              child: Center(
                child: Icon(Icons.add,
                    size: 25, color: Colors.white), // 플러스 아이콘 추가
              ),
            ),
            SizedBox(height: 10), // 아이콘과 텍스트 사이의 간격
            Text('새로운 미션 만들기', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}



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

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    isParent = userProvider.parent;
  }

  ///CREATED_WAIT 상태인 미션을 YET으로 바꾸는 비동기요청
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
  
  
  //하단 버튼 랜더링과 동작 로직 관련
  
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

  
  ///위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "미션상세조회(자녀)"),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                style: TextStyle(fontSize: 16.0, color: Colors.purple), // 보라색
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

            Image.asset(
              'assets/image/m_face.png',
              width: 100.0, // 원하는 크기로 조정
              height: 100.0, // 원하는 크기로 조정
              fit: BoxFit.cover, // 이미지가 부모의 크기에 맞게 조정됩니다.
            ),

            SizedBox(
              height: 20,
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

            ///
            SizedBox(height: 10.0),

            ///정보를 출력하는 회색 폼///
            Column(
              children: [
                // 상단 부분 (진한 회색 배경)
                Container(
                  width: 380.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "미션을 만든사람:",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.item["type"] == "PARENT"
                            ? "부모님"
                            : widget.item["type"] == "CHILD"
                                ? "아이"
                                : widget.item["type"],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                // 하단 부분 (연한 회색 배경)
                Container(
                  width: 380.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "생성일:",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.item["createdDate"]
                                .toString()
                                .substring(0, 10),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            //////////////////////////////
          ],
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

  @override
  void didChangeDependencies() {
    dio = Dio();
    super.didChangeDependencies();
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
  
  ///위젯 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: "미션상세조회(부모)"),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                style: TextStyle(fontSize: 16.0, color: Colors.purple), // 보라색
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

            Image.asset(
              'assets/image/m_face.png',
              width: 100.0, // 원하는 크기로 조정
              height: 100.0, // 원하는 크기로 조정
              fit: BoxFit.cover, // 이미지가 부모의 크기에 맞게 조정됩니다.
            ),

            SizedBox(
              height: 20,
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

            ///정보를 출력하는 회색 폼///
            Column(
              children: [
                // 상단 부분 (진한 회색 배경)
                Container(
                  width: 380.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "미션을 만든사람:",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.item["type"] == "PARENT"
                            ? "부모님"
                            : widget.item["type"] == "CHILD"
                                ? "아이"
                                : widget.item["type"],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                // 하단 부분 (연한 회색 배경)
                Container(
                  width: 380.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "생성일:",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.item["createdDate"]
                                .toString()
                                .substring(0, 10),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            //////////////////////////////
          ],
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


// 미션 완료 승인 폼 페이지
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

  //위젯 빌드,
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
