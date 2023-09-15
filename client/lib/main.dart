import 'package:flutter/material.dart';
import 'screens/main_page/main_page.dart';

//provider관련
import 'package:provider/provider.dart';
import 'package:keeping/provider/provider.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: MainPage(),
//   ));
// }

//여기에 프로바이더를 추가해
void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Counts()), //Counts 인스턴스 추가
    ChangeNotifierProvider(create: (_) => TestArray()), // TestArray 인스턴스 추가
  ], child: const MaterialApp(home: MainPage())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
