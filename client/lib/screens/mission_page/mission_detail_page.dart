import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/sample_code_page/make_piggy_sample_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final _baseUrl = dotenv.env['BASE_URL'];


class MissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  // final Map<String, dynamic> missionId;
  const MissionDetailPage({super.key, required this.item});
  // const MissionDetailPage({super.key, required this.item , required this.missionId});

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  late bool isParent;
  String? profileImage = '';
  String? childProfileImage = '';
  bool isFinishedCommentNull = true;
  late String memberKey;

  Future<void> _isFinishedCommentNull() async {
    print('debug:');
    print(widget.item['finishedComment']);
    if (widget.item['finishedComment'] == null) {
      setState(() {
        isFinishedCommentNull = true;
      });
    } else {
      isFinishedCommentNull = false;
    }
  }

  // 미션 상세조회 데이터 비동기 요청
  // Future<List<Map<String, dynamic>>> getParentData() async {
  //   // Dio 객체 생성
  //   final dio = Dio();
  //   var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
  //   var childInfoProvider =
  //       Provider.of<ChildInfoProvider>(context, listen: false);
  //   var memberKey = userProvider.memberKey;
  //   var childMemberKey = childInfoProvider.memberKey;
  //   var accessToken = userProvider.accessToken;
  //   print('미션 상세조회?!?');
  //   print(memberKey);
  //   print(accessToken);

  //     final headers = {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer $accessToken'
  // };

  //   try {
  //     // GET 요청 보내기
  //     final response = await http.get(
  //         Uri.parse("$_baseUrl/mission-service/api/$memberKey/$childMemberKey/${widget.missionId}"),
  //         headers: headers);

  //     // 요청이 성공했을 때 처리
  //     if (response.statusCode == 200 && response.data['resultBody'] is Map) {
  //       return <Map<String, dynamic>>.from(response.data['resultBody']);
  //     } else {
        
  //     }
  //   } catch (error) {
  //     // 요청이 실패했을 때 처리
  //     print('Error: $error');
      
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _isFinishedCommentNull();
    isParent = context.read<UserInfoProvider>().parent;
    var userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    profileImage = userInfoProvider.profileImage;
    var childInfoProvider =
        Provider.of<ChildInfoProvider>(context, listen: false);
    childProfileImage = childInfoProvider.profileImage;
    memberKey = context.read<UserInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션',
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Container(
                                decoration: roundedBoxWithShadowStyle(
                                    shadow: false,
                                    bgColor: missionRequestStatusBgColor(
                                        widget.item['completed'])),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  child: Text(
                                    missionRequestStatusText(
                                        widget.item['completed']),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.item['todo'],
                              style: TextStyle(fontSize: 22),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.item['money'].toString(),
                                  style: TextStyle(
                                      color: missionRequestStatusBgColor(
                                          widget.item['completed']),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '원',
                                  style: TextStyle(fontSize: 22),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        roundedAssetImg(
                            imgPath: 'assets/image/mission/smile1.png',
                            size: 100)
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    '응원메시지',
                                    style: TextStyle(
                                        color: Color(0xff808080), fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  roundedAssetImg(
                                      imgPath:
                                          'assets/image/profile/parent1.png',
                                      size: 50),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                        width: double.infinity,
                                        decoration: roundedBoxWithShadowStyle(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Text(
                                              widget.item['cheeringMessage']),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    '요청메시지',
                                    style: TextStyle(
                                        color: Color(0xff808080), fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  isParent
                                      ? roundedAssetImg(
                                          imgPath: childProfileImage ??
                                              'assets/image/profile/parent1.png',
                                          size: 50)
                                      : roundedAssetImg(
                                          imgPath: profileImage ??
                                              'assets/image/profile/parent1.png',
                                          size: 50),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                        width: double.infinity,
                                        decoration: roundedBoxWithShadowStyle(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Text(widget.item[
                                                  'childRequestComment'] ??
                                              ''),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: roundedBoxWithShadowStyle(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.keyboard_tab,
                                          textDirection: TextDirection.rtl,
                                          color: missionRequestStatusBgColor(
                                              widget.item['completed'])),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '만든 날',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    formattedYMDDate(DateTime.parse(
                                        widget.item['startDate'])),
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.keyboard_tab,
                                          color: missionRequestStatusBgColor(
                                              widget.item['completed'])),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '완료하는 날',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    formattedYMDDate(
                                        DateTime.parse(widget.item['endDate'])),
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// 소감 작성하기 버튼 /// /// 소감 작성하기 버튼 ///
                  isFinishedCommentNull && !isParent
                      ? _commentWriteBtn()
                      : Container(),
                  !isFinishedCommentNull ? _CompleteComment() : Container(),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            );
          }),

      // FutureBuilder(
      //   // 비동기 데이터를 기다리고 UI를 구성
      //   future: getData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('에러 발생: ${snapshot.error}'));
      //     } else {
      //       data = snapshot.data ?? {}; // 여기에서 snapshot의 데이터를 받아옵니다.
      //       return 
      // ),



      bottomNavigationBar: BottomBtn(
        bgColor: missionRequestStatusBgColor(widget.item['completed']),
        text: _getBottomButtonText(isParent, widget.item["completed"]),
        action: () {
          isParent
            ? handleParentButtonClick(
                context, widget.item, widget.item["completed"])
            : handleChildButtonClick(
                context, widget.item, widget.item["completed"],
                accessToken: accessToken, memberKey: memberKey, parent: isParent, missionId: widget.item['id'],
              );
          // if (isParent == null) return;
          // isParent!
          //     ? handleParentButtonClick(
          //         context, widget.item, widget.item["completed"])
          //     : handleChildButtonClick(
          //         context, widget.item, widget.item["completed"]);
        },
        isDisabled: false,
        // isDisabled: () {
        //   String status = widget.item["completed"];
        //   if (isParent != null) {
        //     if (status == "CREATE_WAIT" && !isParent!) {
        //       return true; // 자녀는 비활성화
        //     } else if (status == "YET" && isParent!) {
        //       return true; // 부모는 비활성화
        //     } else if (status == "FINISH_WAIT" && !isParent!) {
        //       return true; // 자녀는 비활성화
        //     } else if (status == "FINISH" && isParent!) {
        //       return true; // 부모는 비활성화
        //     } else if (widget.item["finishedComment"] == null) {
        //       return false; // 완료 메세지가 없으면 활성화
        //     }
        //     return false; // 기본값은 활성화
        //   }
        //   return true; // 기본값은 활성화
        // }(),
      ),
    );
  }

  //커멘트 작성 페이지로 가는 버튼//
  Widget _commentWriteBtn() {
    return GestureDetector(
      onTap: () {
        if (widget.item["completed"] == "FINISH") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MissionCompleteCommentPage(
                    missionId: widget.item["id"], item: widget.item)),
          );
        }
      },
      child: Padding(
          padding: EdgeInsets.only(top: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/mission/pencil.png',
                width: 50.0,
              ),
              Text(
                "완료 소감 적기!",
                style: TextStyle(fontSize: 18),
              ),
            ],
          )),
    );

    /// 소감 작성하기 버튼 /// /// 소감 작성하기 버튼 ///
  }

  Widget _CompleteComment() {
    return Stack(
      children: [
        Image.asset(
          'assets/image/mission/target.png',
          height: 300,
        ),
        SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    '완료소감',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 130,
                  decoration: roundedBoxWithShadowStyle(),
                  // child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Text(widget.item["finishedComment"] ?? ''),
                  ),
                  // ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // Widget _CompleteComment() {
  //   return Opacity(
  //     opacity: widget.item["completed"] == "FINISH" ? 1 : 0, // 조건에 따라 투명도 조절
  //     child: IgnorePointer(
  //       ignoring: widget.item["completed"] != "FINISH", // 조건에 따라 클릭 이벤트 제어
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Text(
  //                 '완료소감',
  //                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.85,
  //             height: 150,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 5,
  //                   blurRadius: 7,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ],
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Center(
  //               child: Text(widget.item["finishedComment"] ?? ''),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

String _getBottomButtonText(bool parent, String status) {
  if (parent == true) {
    if (status == 'CREATE_WAIT') {
      return '확인';
    } else if (status == 'YET') {
      return '참 잘했어요 꾸욱!';
    } else if (status == 'FINISH_WAIT') {
      return '열심히 미션을 하고 있어요!';
    } else {
      return '확인';
    }
  } else {
    if (status == 'CREATE_WAIT') {
      return '승인을 기다리는 중이에요!';
    } else if (status == 'YET') {
      return '완료 하러 가기!';
    } else if (status == 'FINISH_WAIT') {
      return '완료!';
    } else {
      return '확인';
    }
  }
}

void handleParentButtonClick(
    BuildContext context, dynamic item, String status) {
  switch (status) {
    case "CREATE_WAIT":
      // 미션 생성 승인 로직
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MissionApprovePage(
      //             missionId: item["id"], item: item))); //미션 id 넘겨주는곳

      noEffectReplacementTransition(
          context, MissionApprovePage(missionId: item["id"], item: item));

      break;
    case "YET":
      // 미션 진행 확인 로직
      Navigator.pop(context);
      break;
    case "FINISH_WAIT":
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MissionCompletePage(
      //             missionId: item["id"], item: item))); //미션 id 넘겨주는곳

      noEffectReplacementTransition(
          context, MissionCompletePage(missionId: item["id"], item: item));

      // 미션 완료 승인 로직
      break;
    case "FINISH":
      // 미션 확인 로직
      Navigator.pop(context);
      break;
    default:
      // 기본 로직
      break;
  }
}

void handleChildButtonClick(BuildContext context, dynamic item, String status,
  {required String accessToken, required String memberKey, required bool parent, required int missionId}
) {
  switch (status) {
    case "CREATE_WAIT":
      // 미션 생성 승인 로직
      Navigator.pop(context);
      break;
    case "YET":
      // 미션 진행 확인 로직
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MissionCompleteRequestPage(
      //               missionId: item["id"],
      //               item: item,
      //             ))); //미션 id 넘겨주는곳

      noEffectReplacementTransition(
          context,
          MissionCompleteRequestPage(
            missionId: item["id"],
            item: item,
          ));
      ///YET 상태인 미션을 FINISH_WAIT으로 바꾸는 비동기 요청
      // Future<void> _sendData() async {
      //   var userType = parent ? "PARENT" : "CHILD";

      //   final data = {
      //     "type": userType,
      //     "missionId": missionId,
      //     "cheeringMessage": '',
      //     "completed": "FINISH_WAIT"
      //   };

      //   final headers = {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $accessToken'
      //   };

      //   try {
      //     var response = await http.patch(
      //         Uri.parse("$_baseUrl/mission-service/api/$memberKey/complete"),
      //         headers: headers,
      //         body: jsonEncode(data));
      //     Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      //     print('미션 완료 하러 가기 ${jsonResponse}');
      //     if (jsonResponse.isEmpty) return;
      //     // if (jsonResponse['status'] == '500') return;
      //     // if (jsonResponse['resultStatus']['successCode'] == '0') {
      //     //   // Navigator.push(
      //     //   //     context,
      //     //   //     MaterialPageRoute(
      //     //   //         builder: (context) => CompletedPage(
      //     //   //               text: "미션완료 요청완료!",
      //     //   //               button: ConfirmBtn(
      //     //   //                 action: MissionPage(),
      //     //   //               ),
      //     //   //             ))); //페이지터짐관련

      //     //   noEffectReplacementTransition(
      //     //       context,
      //     //       CompletedPage(
      //     //         text: "미션완료 요청완료!",
      //     //         button: ConfirmBtn(
      //     //           action: MissionPage(),
      //     //         ),
      //     //       ));

      //     //   // Navigator.push(
      //     //   //     context,
      //     //   //     MaterialPageRoute(
      //     //   //         builder: (context) => CompletedAndGoPage(text: '미션 완료!', targetPage: MissionPage(),
      //     //   //             )));
      //     // }
      //   } catch (e) {
      //     print('Error: $e');
      //     print(data);
      //   }
      // }
      // _sendData();

      break;
    case "FINISH_WAIT":
      // 미션 완료 승인 로직
      Navigator.pop(context);
      break;
    case "FINISH":
      // 미션 확인 로직
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MissionCompleteCommentPage(
      //               missionId: item["id"],
      //               item: item,
      //             ))); //미션 id 넘겨주는곳
      Navigator.pop(context);
      break;
    default:
      // 기본 로직
      break;
  }
}
