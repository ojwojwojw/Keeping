import 'package:flutter/material.dart';
import 'package:keeping/screens/keyboard_test/keyboard_test.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';

// 하단 내비게이션 클래스
class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: navStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          notificationBtn(context),
          homeBtn(context),
          myPageBtn(context)
        ],
      ),
    );
  }
}

// 페이지가 안 만들어진 관계로 임시로 경로를 부여함

// 푸시알림 페이지로 이동하는 버튼
Widget notificationBtn(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => KeyboardTest()));
    },
    icon: Icon(Icons.notifications),
    color: Colors.black,
    iconSize: 40.0,
  );
}

// 홈으로 이동하는 버튼
Widget homeBtn(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChildMainPage()));
    },
    icon: Icon(Icons.home),
    color: Colors.black,
    iconSize: 40.0,
  );
}

// 마이페이지로 이동하는 버튼
Widget myPageBtn(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => KeyboardTest()));
    },
    icon: Icon(Icons.person),
    color: Colors.black,
    iconSize: 40.0,
  );
}

// 스타일
BoxDecoration navStyle() {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.7),
        spreadRadius: 0,
        blurRadius: 5.0,
        offset: Offset(0, 0),
      ),
    ],
  );
}