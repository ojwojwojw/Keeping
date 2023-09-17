import 'package:flutter/material.dart';

Future<dynamic> roundedModal({
  required BuildContext context,
  required String title,
  bool doubleBtn = false,
  String firstBtn = '확인',
  dynamic firstAction,
  String secondBtn = '취소',
  dynamic secondAction,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          title,
          style: TextStyle(
            fontSize: 20
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              onPressed(context, firstAction);
            },
            style: btnStyle(bgColor: const Color(0xFF8320E7), textColor: Colors.white,),
            child: Text(firstBtn)
          ),
          if (doubleBtn) ElevatedButton(
            onPressed: () {
              onPressed(context, secondAction);
            },
            style: btnStyle(bgColor: Colors.white, textColor: const Color(0xFF8320E7)),
            child: Text(secondBtn)
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0), // 각 모퉁이의 둥근 정도 설정
        ),
      );
    }
  );
}

void onPressed(BuildContext context, dynamic action) {
  if (action is Widget) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => action));
  } else if (action is Function) {
    action();
  } else {
    Navigator.pop(context);
  }
}

ButtonStyle btnStyle({required Color bgColor, required textColor,}) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(bgColor),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(fontSize: 18)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기 반지름 설정
        side: BorderSide(color: const Color(0xFF8320E7))
      ),
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      Size(110, 40)
    )
  );
}