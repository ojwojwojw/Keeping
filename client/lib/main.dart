import 'package:flutter/material.dart';
import 'package:keeping/fcmSetting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/provider/online_payment_request_provider.dart';
import 'package:keeping/provider/piggy_provider.dart';

import 'package:keeping/fcmSetting.dart';
import 'package:keeping/provider/user_info.dart';
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
  String? firebaseToken = await fcmSetting();
  await dotenv.load(fileName: "lib/.env");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Counts()), //Counts 인스턴스 추가
    ChangeNotifierProvider(create: (_) => TestArray()), // TestArray 인스턴스 추가
    ChangeNotifierProvider(create: (_) => PiggyProvider()),
    ChangeNotifierProvider(create: (_) => PiggyDetailProvider()),
    ChangeNotifierProvider(create: (_) => AddPiggyProvider()),
    ChangeNotifierProvider(create: (_) => OnlinePaymentRequestFormProvider()),
    ChangeNotifierProvider(create: (_) => UserInfoProvider()),
  ], child: const MaterialApp(home: MainPage())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
