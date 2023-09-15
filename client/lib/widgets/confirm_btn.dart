import 'package:flutter/material.dart';

// 확인 버튼 클래스
class ConfirmBtn extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final dynamic action;
  // final Widget? path;  // 버튼 클릭 후 이동할 곳. 비어있으면 이전 페이지로 이동

  ConfirmBtn({
    super.key,
    this.text = '확인',
    this.bgColor = const Color(0xFF8320E7),
    this.textColor = Colors.white,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (action is Widget) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => action));
        } else if (action is Function) {
          action();
        } else {
          Navigator.pop(context);
        }
      },
      style: confirmBtnStyle(bgColor, textColor),
      child: Text(text),
    );
  }
}

// 버튼 스타일
ButtonStyle confirmBtnStyle(Color bgColor, Color textColor) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(bgColor),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(fontSize: 18, color: textColor)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기 반지름 설정
      ),
    ),
    minimumSize: MaterialStateProperty.all<Size>(
      Size(300.0, 50.0), // 버튼의 최소 높이와 너비 설정
    ),
  );
}
