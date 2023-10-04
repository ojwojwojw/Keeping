import 'package:flutter/material.dart';

// body에 들어가는 상단 헤더 클래스
class MyHeader extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color bgColor;
  final Color elementColor;
  final dynamic backPath;
  final Widget? icon; // 오른쪽 상단에 들어갈 아이콘 (ex. Icon(Icons.arrow_back))
  final dynamic iconPath; // 오른쪽 상단 아이콘을 클릭했을 때 이동할 곳
  final dynamic path;
  final bool backIcon;

  MyHeader({
    super.key,
    required this.text,
    this.bgColor = Colors.transparent,
    this.elementColor = Colors.black,
    this.backPath,
    this.icon,
    this.iconPath,
    this.path,
    this.backIcon = true,
  });

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
              (backIcon) // 오른쪽 아이콘이 없을 경우 SizedBox를 추가해 정렬에 문제없도록 처리
                ? backBtn(context, elementColor, backPath)
                : SizedBox(width: 55, height: 55,),
              titleText(context, elementColor, text),
              (icon != null) // 오른쪽 아이콘이 없을 경우 SizedBox를 추가해 정렬에 문제없도록 처리
                ? extraBtn(context, elementColor, icon!, iconPath)
                : SizedBox(width: 55,)
            ]),
            SizedBox(
              height: 5,
            )
          ],
        ));
  }
}

// 뒤로 돌아가는 화살표 버튼
Widget backBtn(BuildContext context, Color elementColor, dynamic backPath) {
  return IconButton(
    onPressed: () {
      if (backPath is Widget) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => backPath));
      } else if (backPath is Function) {
        backPath();
      } else {
        Navigator.pop(context);
      }
    },
    icon: Icon(Icons.arrow_back_rounded),
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
    BuildContext context, Color elementColor, Widget icon, dynamic iconPath) {
  return IconButton(
    onPressed: () {
      if (iconPath is Widget) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => iconPath));
      } else if (iconPath is Function) {
        iconPath();
      } else {
        Navigator.pop(context);
      }
    },
    icon: icon,
    color: elementColor,
    iconSize: 40.0,
  );
}
