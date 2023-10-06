//실제 프로파이더 기능을 사용할 dart 파일//

import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';

//실제 프로파이더 기능을 사용할 클래스//
//button과 counter라는 위젯을 포함하고 있습니다//
class CounterTest extends StatefulWidget {
  @override
  _CounterTestState createState() => _CounterTestState();
}

class _CounterTestState extends State<CounterTest> {
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
              context.watch<Counts>().count.toString(),
            ), //watch로 provider의 Counts 에 접근합니다.
            Text(
              context.watch<TestArray>().testArray.toString(),
            )
            //watch로 provider의 TestArray 클래스 에 접근합니다.
          ],
        ),
      ),
    );
  }
}

//원래는 위젯에 있어야할 dart 파일//
//전역에서 관리되고 있는 변수 'int _counter'을 변화시키는 버튼입니다.//
class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              context.read<Counts>().add();
            },
            child: Icon(Icons.add)),
        ElevatedButton(
            onPressed: () {
              context.read<Counts>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
