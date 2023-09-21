import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keeping/styles.dart';

Widget colorInfoCardStatus(double width) {
  return Container(
    width: width,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFFFDDDD)
    ),
    child: Text('부탁 거절', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
  );
}

Widget colorInfoCardContent() {
  return Container();
}

Widget colorInfoDetailCardHeader() {
  return Container();
}

Widget colorInfoDetailCardContents(Column content) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 280,
            // height: 280,
            child: content,
          )
        )
      )
    )
  );
}

Widget colorInfoDetailCardContent(String title, {bool box = true}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        colorInfoDetailCardContentTitle(title),
        SizedBox(height: 5,),
        box ? colorInfoDetailCardContentGreyBox('안녕하세요')
          : colorInfoDetailCardContentUnderLine('URL입니다'),
      ],
    )
  );
}

Widget colorInfoDetailCardContentTitle(String title) {
  return Text(
    title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget colorInfoDetailCardContentGreyBox(String content) {
  return Container(
    width: 280,
    decoration: roundedBoxWithShadowStyle(
      bgColor: const Color(0xFFF2F2F2), borderRadius: 20, shadow: false
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Text(content),
    )
  );
}

Widget colorInfoDetailCardContentUnderLine(String content) {
  return InkWell(
    onTap: () {
      Clipboard.setData(ClipboardData(text: content));
      Fluttertoast.showToast(
        msg: '복사되었습니다.',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    },
    child: Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide())
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(content),
      )
    )
  );
}