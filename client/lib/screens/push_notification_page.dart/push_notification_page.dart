import 'package:flutter/material.dart';
import 'package:keeping/screens/push_notification_page.dart/utils/get_push_notification.dart';
import 'package:keeping/screens/push_notification_page.dart/widgets/push_notification_filter.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_detail.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/request_info_card.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({Key? key});
  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  List<Map<String, dynamic>> _result = []; // 데이터를 저장할 변수
  int selectedBtnIdx = 0;

  late Future<List<Map<String, dynamic>>> _dataFuture;
  @override
  void initState() {
    super.initState();
    _dataFuture = renderPushNotification(context, selectedBtnIdx);
  }

  void handleResult(res) {
    if (res != null) {
      setState(() {
        _result = List<Map<String, dynamic>>.from(res);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '알림'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              PushNotificationFilters(
                onPressed: (int idx) {
                  setState(() {
                    selectedBtnIdx = idx;
                  });
                  _updateData();
                },
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getPushNotification(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200, // 원하는 높이로 조정하세요
                      child: Container(
                        child: Center(
                          child: Text(
                            '잠시 기다려주세요...',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 77, 19, 135)),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
                  } else if (snapshot.hasData) {
                    if (_result.isNotEmpty) {
                      return totalPushNotification(_result);
                    } else {
                      return Text('데이터가 없어요');
                    }
                  } else {
                    return Text('데이터가 없어요');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        notification: true,
      ),
    );
  }

  void _updateData() {
    setState(() {
      _dataFuture = renderPushNotification(context, selectedBtnIdx);
    });
  }

  Future<List<Map<String, dynamic>>> renderPushNotification(
      BuildContext context, selectedBtnIdx) async {
    String memberKey =
        Provider.of<UserInfoProvider>(context, listen: false).memberKey;
    String accessToken =
        Provider.of<UserInfoProvider>(context, listen: false).accessToken;
    var url = '';
    if (selectedBtnIdx == 0) {
      url = '/noti-service/api/$memberKey';
    } else if (selectedBtnIdx == 1) {
      url = '/noti-service/api/$memberKey/MISSION';
    } else if (selectedBtnIdx == 2) {
      url = '/noti-service/api/$memberKey/QUESTION';
    } else {
      url = '/noti-service/api/$memberKey/ACCOUNT';
    }
    final response = await dioGet(
      accessToken: accessToken,
      url: url,
    );
    final responsebody = response['resultBody'];
    print(responsebody);
    handleResult(response['resultBody']);
    if (response != null) {
      final dynamic resultBody = response['resultBody'];
      if (resultBody != null) {
        final List<dynamic> requestResponseList = resultBody as List<dynamic>;
        handleResult(requestResponseList);
        return requestResponseList.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Widget totalPushNotification(List<Map<String, dynamic>> requests) {
    print('req: $requests');
    if (requests.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            '내역이 없습니다.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          )
        ],
      );
    }
    return Column(
      children: requests.map((noti) {
        String typeString = '';
        if (noti['type'] == 'MISSION') {
          typeString = '미션';
        } else if (noti['type'] == 'QUESTION') {
          typeString = '질문';
        } else if (noti['type'] == 'ACCOUNT') {
          typeString = '계좌';
        }

        String FormatDate = '';
        if (noti['createdDate'] == null) {
          final now = DateTime.now();
          FormatDate = formattedMDDate(now);
          // final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
          // FormatDate = formatter.format(now);
        } else {
          FormatDate = formattedMDDate(noti['createdDate']);
          // FormatDate = noti['createdDate'];
        }

        // 알림을 랩핑하는 컨테이너
        return Container(
          width: 330,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: roundedBoxWithShadowStyle(),
          child: Row(
            children: [
              // 이미지 표시
              roundedAssetImg(
                imgPath: 'assets/image/temp_image.jpg',
              ),
              SizedBox(width: 15), // 이미지와 텍스트 사이 간격
              // 나머지 요소들을 세로로 나열
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타입과 날짜를 좌우 양쪽에 배치
                    Row(
                      children: [
                        Text(
                          typeString,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 145, 145, 145),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                        ),
                        Text(
                          '$FormatDate',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // 텍스트와 제목 사이 간격
                    // 나머지 내용들은 이곳에 추가
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        Text(
                          '${noti['title']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
