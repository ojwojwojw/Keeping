import 'package:flutter/material.dart';
import 'package:keeping/screens/keyboard_test/keyboard_test.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/my_page/child_my_page.dart';
import 'package:keeping/screens/my_page/parent_my_page.dart';
import 'package:keeping/screens/push_notification_page.dart/push_notification_page.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

// 하단 내비게이션 클래스
class BottomNav extends StatelessWidget {
  BottomNav({Key? key});

  @override
  Widget build(BuildContext context) {
    // UserInfoProvider에서 isParent 값을 가져오기 위해 Provider.of를 사용합니다.
    bool _isParent =
        Provider.of<UserInfoProvider>(context, listen: false).parent;

    return Container(
      decoration: navStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          notificationBtn(context, _isParent),
          homeBtn(context, _isParent),
          myPageBtn(context, _isParent), // _isParent 변수를 myPageBtn에 전달합니다.
        ],
      ),
    );
  }
}

// 마이페이지로 이동하는 버튼
Widget myPageBtn(BuildContext context, bool isParent) {
  return IconButton(
    onPressed: () {
      // isParent에 따라 페이지를 다르게 이동하도록 조건을 설정합니다.
      if (isParent) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ParentMyPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChildMyPage()));
      }
    },
    icon: Icon(Icons.person),
    color: Colors.black,
    iconSize: 40.0,
  );
}

// 페이지가 안 만들어진 관계로 임시로 경로를 부여함

// 푸시알림 페이지로 이동하는 버튼
Widget notificationBtn(BuildContext context, bool isParent) {
  return IconButton(
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => PushNotificationPage()));
    },
    icon: Icon(Icons.notifications),
    color: Colors.black,
    iconSize: 40.0,
  );
}

// 홈으로 이동하는 버튼
Widget homeBtn(BuildContext context, bool isParent) {
  return IconButton(
    onPressed: () {
      if (isParent) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ParentMainPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChildMainPage()));
      }
    },
    icon: Icon(Icons.home),
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
