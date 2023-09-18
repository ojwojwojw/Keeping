import 'package:flutter/material.dart';
import 'package:keeping/screens/piggy_page/make_piggy_test.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_filters.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';

class PiggyPage extends StatelessWidget {
  PiggyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '\u{1F437} 저금통',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          PiggyInfo(),
          PiggyFilters(),
        ],
      ),
      floatingActionButton: FloatingBtn(
        text: '만들기',
        icon: Icon(Icons.savings_rounded),
        path: MakePiggyTest(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}