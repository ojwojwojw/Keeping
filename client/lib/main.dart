import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/provider/piggy_provider.dart';

import 'package:keeping/fcmSetting.dart';
import 'screens/main_page/main_page.dart';

//provider관련
import 'package:provider/provider.dart';
import 'package:keeping/provider/provider.dart';

//FCM
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin notiPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> cancelNotification() async {
  await notiPlugin.cancelAll();
}

Future<void> requestPermissions() async {
  await notiPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

Future<void> showNotification({
  required title,
  required message,
}) async {
  notiPlugin.show(
    11,
    title,
    message,
    NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        channelDescription: "channelDescription",
        icon: '@mipmap/ic_launcher',
      ),
      // iOS: const IOSNotificationDetails(
      //   badgeNumber: 1,
      //   subtitle: 'subtitle',
      // ),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  print('noti - title : ${notification?.title}, body : ${notification?.body}');
  Map<String, dynamic> data = message.data;
  await cancelNotification();
  await requestPermissions();
  await showNotification(title: data['title'], message: data['value']);
}

//여기에 프로바이더를 추가해
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env");
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   // apiKey: 'AIzaSyBWmD28vXwr8HQcIQmjrW_fZMTVq8a2SNo',
    //   // appId: '1:926429802747:android:1c00de6777c5e72f90805e',
    //   // messagingSenderId: '926429802747',
    //   // projectId: 'keeping-dc42f',
    // ),
    options: DefaultFirebaseOptions.android,
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('인쇄 돼?');
  print('token : ${fcmToken ?? 'tokenNull'}');

  String? firebaseToken = await fcmSetting();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Counts()), //Counts 인스턴스 추가
    ChangeNotifierProvider(create: (_) => TestArray()), // TestArray 인스턴스 추가
    ChangeNotifierProvider(create: (_) => PiggyDetailProvider()),
    ChangeNotifierProvider(create: (_) => AddPiggyProvider()),
  ], child: const MaterialApp(home: MainPage())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
