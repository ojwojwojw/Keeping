import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class MissionDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const MissionDetailPage({super.key, required this.item});

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  bool? isParent;

  @override
  void initState() {
    super.initState();
    isParent = context.read<UserInfoProvider>().parent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈 미션',
      ),
      body: Padding(
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
                      imgPath: 'assets/image/temp_image.jpg', size: 100)
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              '응원메시지',
                              style: TextStyle(color: Color(0xff808080)),
                            ),
                            roundedAssetImg(
                                imgPath: 'assets/image/temp_image.jpg',
                                size: 50),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: roundedBoxWithShadowStyle(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(widget.item['cheeringMessage']),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              '요청메시지',
                              style: TextStyle(color: Color(0xff808080)),
                            ),
                            roundedAssetImg(
                                imgPath: 'assets/image/temp_image.jpg',
                                size: 50),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: roundedBoxWithShadowStyle(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                    widget.item['childRequestComment'] ?? ''),
                              ),
                            ),
                          ],
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Text('만든 날'),
                              ],
                            ),
                            Text(formattedYMDDate(
                                DateTime.parse(widget.item['startDate'])))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.keyboard_tab,
                                    color: missionRequestStatusBgColor(
                                        widget.item['completed'])),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('완료하는 날'),
                              ],
                            ),
                            Text(formattedYMDDate(
                                DateTime.parse(widget.item['endDate'])))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// 소감 작성하기 버튼 /// /// 소감 작성하기 버튼 ///
            GestureDetector(
              onTap: () {
                if (widget.item["completed"] == "FINISH") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MissionCompleteCommentPage(missionId: widget.item["id"], item: widget.item)),
                  );
                }
              },
              child: Opacity(
                opacity: widget.item["completed"] == "FINISH" ? 1 : 0,
                child: IgnorePointer(
                  ignoring: widget.item["completed"] != "FINISH",
                    child: Center(child: Text("완료소감적기!")),
                  )
                ),
              ),
            
            Text(widget.item["finishedComment"] ?? '')

            /// 소감 작성하기 버튼 /// /// 소감 작성하기 버튼 ///
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        bgColor: missionRequestStatusBgColor(widget.item['completed']),
        text: _getBottomButtonText(widget.item["completed"]),
        action: () {
          if (isParent == null) return;
          isParent!
              ? handleParentButtonClick(
                  context, widget.item, widget.item["completed"])
              : handleChildButtonClick(
                  context, widget.item, widget.item["completed"]);
        },
        isDisabled: () {
          String status = widget.item["completed"];
          if (isParent != null) {
            if (status == "CREATE_WAIT" && !isParent!) {
              return true; // 자녀는 비활성화
            } else if (status == "YET" && isParent!) {
              return true; // 부모는 비활성화
            } else if (status == "FINISH_WAIT" && !isParent!) {
              return true; // 자녀는 비활성화
            } else if (status == "FINISH" && isParent!) {
              return true; // 부모는 비활성화
            }
            return false; // 기본값은 활성화
          }
          return true; // 기본값은 활성화
        }(),
      ),
    );
  }
}

String _getBottomButtonText(String status) {
  switch (status) {
    case "CREATE_WAIT":
      return "미션생성을 승인해요.";
    case "YET":
      return "미션을 완료했어요!";
    case "FINISH_WAIT":
      return "참 잘했어요 꾸욱 :)";
    case "FINISH":
      return "기억하기 .";
    default:
      return "미션 승인하기";
  }
}

void handleParentButtonClick(
    BuildContext context, dynamic item, String status) {
  switch (status) {
    case "CREATE_WAIT":
      // 미션 생성 승인 로직
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MissionApprovePage(
                    missionId: item["id"],
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
                    missionId: item["id"],
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

void handleChildButtonClick(BuildContext context, dynamic item, String status) {
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
                    missionId: item["id"],
                  ))); //미션 id 넘겨주는곳
      break;
    case "FINISH_WAIT":
      // 미션 완료 승인 로직
      break;
    case "FINISH":
      // 미션 확인 로직
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MissionCompleteCommentPage(
                    missionId: item["id"],
                    item: item,
                  ))); //미션 id 넘겨주는곳
      break;
    default:
      // 기본 로직
      break;
  }
}
