import 'package:flutter/material.dart';

// 확인 버튼 클래스
class ConfirmBtn extends StatefulWidget {
  final String text;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final dynamic action;
  final bool shadow;

  const ConfirmBtn({
    super.key,
    this.text = '확인',
    this.bgColor = const Color(0xFF8320E7),
    this.borderColor = const Color(0xFF8320E7),
    this.textColor = Colors.white,
    this.action,
    this.shadow = true,
  });

  @override
  State<ConfirmBtn> createState() => _ConfirmBtnState();
}

class _ConfirmBtnState extends State<ConfirmBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.action is Widget) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget.action));
        } else if (widget.action is Function) {
          widget.action();
        } else {
          Navigator.pop(context);
        }
      },
      style: confirmBtnStyle(widget.bgColor, widget.textColor, widget.borderColor, widget.shadow),
      child: Text(widget.text),
    );
  }
}

// 버튼 스타일
ButtonStyle confirmBtnStyle(Color bgColor, Color textColor, Color borderColor, bool shadow) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(bgColor),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(fontSize: 18, color: textColor)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기 반지름 설정
        side: BorderSide(color: borderColor)
      ),
    ),
    minimumSize: MaterialStateProperty.all<Size>(
      Size(300.0, 50.0), // 버튼의 최소 높이와 너비 설정
    ),
    shadowColor: shadow ? null : MaterialStateProperty.all<Color>(Colors.transparent),
  );
}
