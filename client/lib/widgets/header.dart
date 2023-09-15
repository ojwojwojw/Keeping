import 'package:flutter/material.dart';

// body에 들어가는 상단 헤더 클래스
class MyHeader extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color bgColor;
  final Color elementColor;
  final Widget? icon; // 오른쪽 상단에 들어갈 아이콘 (ex. Icon(Icons.arrow_back))
  final Widget? path; // 오른쪽 상단 아이콘을 클릭했을 때 이동할 곳

  MyHeader(
      {super.key,
      required this.text,
      this.bgColor = Colors.transparent,
      this.elementColor = Colors.black,
      this.icon,
      this.path});

  @override
  Size get preferredSize => Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final double statusBarSize = MediaQuery.of(context).padding.top; // 상태표시줄 높이

    return Container(
        color: bgColor,
        child: Column(
          children: [
            SizedBox(
              height: statusBarSize + 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              backBtn(context, elementColor),
              titleText(context, elementColor, text),
              (icon != null &&
                      path != null) // 오른쪽 아이콘이 없을 경우 SizedBox를 추가해 정렬에 문제없도록 처리
                  ? extraBtn(context, elementColor, icon!, path!)
                  : SizedBox(
                      width: 55,
                    )
            ]),
            SizedBox(
              height: 5,
            )
          ],
        ));
  }
}

// 뒤로 돌아가는 화살표 버튼
Widget backBtn(BuildContext context, Color elementColor) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back),
    color: elementColor,
    iconSize: 40.0,
  );
}

// 타이틀
Widget titleText(BuildContext context, Color elementColor, String text) {
  return Text(
    text,
    style: TextStyle(
      color: elementColor,
      fontSize: 25.0,
    ),
  );
}

// 있을수도 없을수도 있는 추가 버튼
Widget extraBtn(
    BuildContext context, Color elementColor, Widget icon, Widget path) {
  return IconButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => path));
    },
    icon: icon,
    color: elementColor,
    iconSize: 40.0,
  );
}
