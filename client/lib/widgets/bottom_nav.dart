import 'package:flutter/material.dart';
import 'package:keeping/screens/diary_page/diary_page.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/my_page/child_my_page.dart';
import 'package:keeping/screens/my_page/parent_my_page.dart';
import 'package:keeping/screens/push_notification_page.dart/push_notification_page.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

// 하단 내비게이션 클래스
class BottomNav extends StatelessWidget {
  final bool home;
  final bool diary;
  final bool notification;
  final bool myPage;

  BottomNav({
    super.key,
    this.home = false,
    this.diary = false,
    this.notification = false,
    this.myPage = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isParent = Provider.of<UserInfoProvider>(context, listen: false).parent;

    return SizedBox(
      child: Container(
        height: 60,
        decoration: navStyle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(fit: FlexFit.tight, child: Center(child: homeBtn(context, isParent, home))),
            Flexible(fit: FlexFit.tight, child: Center(child: diaryBtn(context, isParent, diary))),
            Flexible(fit: FlexFit.tight, child: Center(child: notificationBtn(context, isParent, notification))),
            Flexible(fit: FlexFit.tight, child: Center(child: myPageBtn(context, isParent, myPage))),
          ],
        ),
      ),
    );
  }
}

// 홈으로 이동하는 버튼
Widget homeBtn(BuildContext context, bool isParent, bool isSelected) {
  return InkWell(
    onTap: () {
      if (isParent) {
        noEffectTransition(context, ParentMainPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ParentMainPage()));
      } else {
        noEffectTransition(context, ChildMainPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ChildMainPage()));
      }
    },
    child: _navBtnStyle(icon: Icons.home, text: '홈', isSelected: isSelected),
  );
}

// 다이어리로 이동하는 버튼
Widget diaryBtn(BuildContext context, bool isParent, bool isSelected) {
  return InkWell(
    onTap: () {
      if (isParent) {
        noEffectReplacementTransition(context, ParentDiaryPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ParentDiaryPage()));
      } else {
        noEffectReplacementTransition(context, ChildDiaryPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ChildDiaryPage()));
      }
    },
    child: _navBtnStyle(icon: Icons.book, text: '다이어리', isSelected: isSelected),
  );
}

// 푸시알림 페이지로 이동하는 버튼
Widget notificationBtn(BuildContext context, bool isParent, bool isSelected) {
  return InkWell(
    onTap: () {
      noEffectReplacementTransition(context, PushNotificationPage());
      // Navigator.push(context, MaterialPageRoute(builder: (_) => PushNotificationPage()));
    },
    child: _navBtnStyle(icon: Icons.notifications, text: '알림', isSelected: isSelected),
  );
}

// 마이페이지로 이동하는 버튼
Widget myPageBtn(BuildContext context, bool isParent, bool isSelected) {
  return InkWell(
    onTap: () {
      if (isParent) {
        noEffectReplacementTransition(context, ParentMyPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ParentMyPage()));
      } else {
        noEffectReplacementTransition(context, ChildMyPage());
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ChildMyPage()));
      }
    },
    child: _navBtnStyle(icon: Icons.person, text: '마이페이지', isSelected: isSelected),
  );
}

Widget _navBtnStyle({required IconData icon, required String text, bool isSelected = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 30, color: isSelected ? Color(0xFF8320E7) : Color(0xFFA5A5A5),),
      Text(text, style: TextStyle(fontSize: 9, color: isSelected ? Color(0xFF8320E7) : Color(0xFFA5A5A5)),),
    ],
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
