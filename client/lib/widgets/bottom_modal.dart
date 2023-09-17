import 'package:flutter/material.dart';

Future<dynamic> bottomModal({
  required BuildContext context,
  required String title,
  Color bgColor = Colors.white,
  required Widget content,
  required Widget button,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Color(0xFF737373),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // 테두리 둥글기 설정
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,  // 모달 높이 자동으로 지정
            children: [
              SizedBox(height: 15),
              modalHeader(title, context),
              SizedBox(height: 15),
              content,
              SizedBox(height: 25),
              button,
              SizedBox(height: 25),
            ],
          ),
        )
      );
    }
  );
}

// 모달 헤더 위젯
Widget modalHeader(String title, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: 50,),
      Text(title, style: TextStyle(fontSize: 25),),
      modalCancleBtn(context)
    ],
  );
}

// 모달 헤더의 취소(X) 버튼
Widget modalCancleBtn(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Icon(Icons.cancel, size: 35,)
  );
}