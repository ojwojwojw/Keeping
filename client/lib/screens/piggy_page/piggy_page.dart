import 'package:flutter/material.dart';
import 'package:keeping/screens/piggy_page/make_piggy_test.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_filters.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info_card.dart';
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
          Expanded(
            child: Container(
              decoration: piggyPageBgStyle(),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PiggyInfoCard(
                      balance: 74000,
                      content: '아디다스 삼바 내꺼야',
                      goalMoney: 140000,
                    ),
                    PiggyInfoCard(
                      balance: 74000,
                      content: '아디다스 삼바 내꺼야',
                      goalMoney: 140000,
                    ),
                    PiggyInfoCard(
                      balance: 74000,
                      content: '아디다스 삼바 내꺼야',
                      goalMoney: 140000,
                    ),
                  ],
                ),
              ),
            ),
          )
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

BoxDecoration piggyPageBgStyle() {
  return BoxDecoration(
    color: const Color(0xFFFAFAFA),
  );
}