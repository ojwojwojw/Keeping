import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

class BtnTest extends StatelessWidget {
  const BtnTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(
            text: '제목',
            elementColor: Colors.black,
          ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
      )
    );
  }
}