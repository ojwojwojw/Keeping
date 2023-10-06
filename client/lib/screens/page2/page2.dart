import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyHeader(
            text: '페이지 2',
            elementColor: Colors.black,
            icon: Icon(Icons.arrow_circle_up),
            path: Page2(),
          ),
        ],
      ),
    );
  }
}
