import 'package:flutter/material.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';

class ParentDiaryPage extends StatefulWidget {
  const ParentDiaryPage({super.key});

  @override
  State<ParentDiaryPage> createState() => _ParentDiaryPageState();
}

class _ParentDiaryPageState extends State<ParentDiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8320E7),
      appBar: MyHeader(
        text: '다이어리',
        bgColor: Color(0xFF8320E7),
      ),
      body: Center(
        child: Column(
          children: [
            Text('text'),

            ///
          ],
        ),
      ),
    );
  }
}
