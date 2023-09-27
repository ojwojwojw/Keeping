import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keeping/firebase_options.dart';
import 'package:keeping/provider/user_info.dart';

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
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {});

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
        );
      }
    },
  );

  String? firebaseToken = await messaging.getToken();
  print('firebase_token : $firebaseToken');
  userInfoProvider.updateFcmToken(fcmToken: firebaseToken);
  return firebaseToken;
}
