import 'package:flutter/material.dart';
import 'package:keeping/screens/push_notification_page.dart/utils/get_push_notification.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

class ChildPushNotificationPage extends StatefulWidget {
  const ChildPushNotificationPage({super.key});

  @override
  State<ChildPushNotificationPage> createState() =>
      _ChildPushNotificationPageState();
}

class _ChildPushNotificationPageState extends State<ChildPushNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '알림'),
      body: SingleChildScrollView(
          child: FutureBuilder<List<NotiResponse>?>(
        future: getPushNotification(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('로딩 중...'); // 데이터를 기다리는 동안 표시할 내용
          } else if (snapshot.hasError) {
            return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
          } else {
            final notiList = snapshot.data;
            if (notiList != null && notiList.isNotEmpty) {
              final titles =
                  notiList.map((noti) => noti.title).join(', '); // 모든 제목 연결
              return Text('알림 데이터: $titles');
            } else {
              return Text('데이터가 없어요');
            }
          }
        },
      )),
    );
  }
}
