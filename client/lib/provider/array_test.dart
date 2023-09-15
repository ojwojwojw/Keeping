//실제 프로파이더 기능을 사용할 dart 파일//

import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> object = {"key": 12345}; //전역변수로 선언된 객체

class ArrayTest extends StatefulWidget {
  const ArrayTest({super.key});

  @override
  State<ArrayTest> createState() => _ArrayTestState();
}

class _ArrayTestState extends State<ArrayTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CounterTest'),
      ),
      body: Center(
        child: Column(
          children: [
            Buttons(),
            Text(
              context.watch<TestArray>().testArray.toString(),
            ), //watch로 provider의 TestArray 클래스 에 접근합니다.
            Text(
              context.watch<Counts>().count.toString(),
            ) //watch로 provider의 Counts 클래스 에 접근합니다.
          ],
        ),
      ),
    );
  }
}

//전역변수로 관리되는 'testArray'를 변화시킵니다.//
class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              context.read<TestArray>().addToTestArray(object);
            },
            child: Icon(Icons.add)),
        ElevatedButton(
            onPressed: () {
              context.read<TestArray>().removeFromTestArray(object);
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
