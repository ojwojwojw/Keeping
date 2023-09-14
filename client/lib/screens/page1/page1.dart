import 'package:flutter/material.dart';
import 'package:keeping/screens/child_spending_route_page/child_spending_route_page.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/page3/page3.dart';
import 'package:keeping/screens/sample_code_page/sample_code_page.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_nav.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            MyHeader(
              text: '제목',
              elementColor: Colors.black,
              icon: Icon(Icons.arrow_circle_up),
              path: Page1(),
            ),
            ConfirmBtn(
              text: '확인확인',
              action: Page3(),
            ),
            testBtn(context),
            ConfirmBtn(
              text: '자녀 메인페이지',
              action: ChildMainPage(),
            ),
            SizedBox(height: 15),
            ConfirmBtn(
              text: '샘플코드',
              action: SampleCodePage(),
            ),
          ],
        ),
        floatingActionButton: FloatingBtn(
          text: '소비지도',
          icon: Icon(Icons.map),
          path: ChildSpendingRoutePage(),
        ),
        bottomNavigationBar: BottomNav());
  }
}

// 모달 테스트용 - 클릭하면 모달 나옴
Widget testBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomModal(
              title: '안녕',
              content: testContent(context),
              button: ConfirmBtn(),
            );
          });
    },
    child: const Text('모달'),
  );
}

// 모달 테스트용 - 모달 안에 들어갈 내용 위젯
Widget testContent(BuildContext context) {
  return Center(
    child: Column(
      children: [Text('모달에 넣고싶은 내용(위젯들) 넣기'), Icon(Icons.heart_broken)],
    ),
  );
}

void onPressed(BuildContext context) {
  Navigator.pop(context);
}
