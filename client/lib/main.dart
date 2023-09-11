import 'package:flutter/material.dart';
import 'screens/main_page/main_page.dart';
import 'package:keeping/screens/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 플러그인 초기화
  await FlutterLocalNotification.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
