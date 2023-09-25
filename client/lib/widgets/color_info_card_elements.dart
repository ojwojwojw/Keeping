import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:keeping/styles.dart';

Widget colorInfoCardStatus(double width, String status) {
  return Container(
    width: width,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: requestStatusBgColor(status)
    ),
    child: Text(requestStatusText(status), style: TextStyle(color: requestStatusTextColor(status), fontWeight: FontWeight.bold),),
  );
}

Widget colorInfoCardContent() {
  return Container();
}

Widget colorInfoDetailCardHeader(DateTime date, String name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        colorInfoDetailDate(date),
        Row(
          children: [
            Text(name),
          ],
        )
      ],
    ),
  );
}

Widget colorInfoDetailDate(DateTime date) {
  return Text(
    DateFormat('yyyy년 M월 d일').format(date)
  );
}

Widget colorInfoDetailCardContents(Column content) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 260,
            child: content,
          )
        )
      )
    )
  );
}

Widget colorInfoDetailCardContent(String title, String content, {bool box = true}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        colorInfoDetailCardContentTitle(title),
        SizedBox(height: 5,),
        box ? colorInfoDetailCardContentGreyBox(content)
          : colorInfoDetailCardContentUnderLine(content),
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

String requestStatusText(String status) {
  if (status == 'ACCEPT') {
    return '부탁 완료';
  } else if (status == 'REJECT') {
    return '부탁 거절';
  } else {
    return '부탁 대기';
  }
}

Color requestStatusBgColor(String status) {
  if (status == 'ACCEPT') {
    return Color(0xFFE0FBD6);
  } else if (status == 'REJECT') {
    return Color(0xFFFFDDDD);
  } else {
    return Color(0xFFD5D5D5);
  }
}

Color requestStatusTextColor(String status) {
  if (status == 'ACCEPT') {
    return Color(0xFF62D00B);
  } else if (status == 'REJECT') {
    return Color(0xFFFF0000);
  } else {
    return Color(0xFF000000);
  }
}