import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keeping/firebase_options.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart'; // 추가: MaterialApp과 navigatorKey에 필요

// 앱 전체에서 Navigator에 액세스할 수 있는 key를 생성
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
}

Future<String?> fcmSetting(UserInfoProvider userInfoProvider) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

//iOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
//Android
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );
  // Android용 새 Notification Channel

  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'keeping_notification',
    'keeping_notification',
    description: '키핑 알림',
    importance: Importance.max,
  );

  // Notification Channel을 디바이스에 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    // Get.to(NotificationDetailsPage(), arguments: payload);
  });

// foreground 푸시 알림 핸들링
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      print(message);
      print('포그라운드 수신');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          0,
          notification.title!,
          notification.body!,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'keeping_notification',
              'keeping_notification',
              channelDescription: androidNotificationChannel.description,
              icon: android.smallIcon,
            ),
          ),
          //경로 처리
          payload: message.data['argument'],
        );
      }
    },
  );

  await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    final String? payload = response.payload; // 수정된 부분
    print('페이로드');
    print(payload);
    // if (payload != null) {
    //   // navigatorKey를 사용하여 원하는 화면으로 이동
    //   navigatorKey.currentState!
    //       .push(MaterialPageRoute(builder: (context) => ChildMainPage()));
    // }
  });
  String? firebaseToken = await messaging.getToken();
  userInfoProvider.updateFcmToken(fcmToken: firebaseToken);

  print('firebase_token : $firebaseToken');
  return firebaseToken;
}
