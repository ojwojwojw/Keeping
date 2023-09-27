import 'package:flutter/material.dart';
import 'package:keeping/screens/push_notification_page.dart/utils/get_push_notification.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

class ParentPushNotificationPage extends StatefulWidget {
  const ParentPushNotificationPage({Key? key});

  @override
  State<ParentPushNotificationPage> createState() =>
      _ParentPushNotificationPageState();
}

class _ParentPushNotificationPageState
    extends State<ParentPushNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '알림'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getPushNotification(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('로딩 중...'); // 데이터를 기다리는 동안 표시할 내용
                  } else if (snapshot.hasError) {
                    return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
                  } else {
                    final notiList = snapshot.data;
                    if (notiList != null && notiList.isNotEmpty) {
                      return Column(
                        children: notiList.map((noti) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 타입과 날짜를 좌우 양쪽에 배치
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            noti['type'],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '날짜: ${noti['createdDate']}',
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 제목
                                          Text(
                                            '${noti['title']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // 내용
                                          // Text('${noti['content']}'),
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
                    } else {
                      return Text('데이터가 없어요');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
