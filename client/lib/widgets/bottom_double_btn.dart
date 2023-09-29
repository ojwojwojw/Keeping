import 'package:flutter/material.dart';

// 하단 네모난 버튼 클래스
class BottomDoubleBtn extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final dynamic action;
  final bool isDisabled;

  BottomDoubleBtn({
    super.key,
    required this.text,
    this.bgColor = const Color(0xFF8320E7),
    this.textColor = Colors.white,
    this.action,
    this.isDisabled = true,
  });

  // 특정 페이지로 가던지, 데이터를 보내던지, 이전 페이지로 돌아가던지 구분해서 로직 짜기

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {  },
            child: Text('Login'),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BottomAppBar(
  //     color: isDisabled ? Colors.black38 : bgColor,
  //     height: 70.0,
  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //     child: TextButton(
  //       onPressed: () {
  //         if (!isDisabled) {
  //           if (action is Widget) {
  //             Navigator.push(context, MaterialPageRoute(builder: (_) => action));
  //           } else if (action is Function) {
  //             action();
  //           } else {
  //             Navigator.pop(context);
  //           }
  //         }
  //       },
  //       style: _bottomBtnStyle(textColor),
  //       child: Text(text),
  //     ),
  //   );
  // }
}

// 버튼 스타일
ButtonStyle _bottomBtnStyle(Color textColor) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: 25.0, color: textColor),
    ),
  );
}
