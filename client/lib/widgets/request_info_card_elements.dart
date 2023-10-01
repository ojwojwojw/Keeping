import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

Widget requestInfoCardStatus(double width, String status) {
  return Container(
    width: width,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: requestStatusBgColor(status)),
    child: Text(
      requestStatusText('조르기', status),
      style: TextStyle(
          color: requestStatusTextColor(status), fontWeight: FontWeight.bold),
    ),
  );
}

Widget requestInfoDetailCardHeader(DateTime date, String name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        requestInfoDetailDate(date),
        Row(
          children: [
            Text(name),
          ],
        )
      ],
    ),
  );
}

Widget requestInfoDetailDate(DateTime date) {
  return Text(formattedYMDDate(date));
}

Widget requestInfoDetailCardContents(Column content) {
  return Expanded(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: SizedBox(
            width: 260,
            child: content,
          )))));
}

Widget requestInfoDetailCardContent(String title, String content,
    {bool box = true}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          requestInfoDetailCardContentTitle(title),
          SizedBox(
            height: 5,
          ),
          box
              ? requestInfoDetailCardContentGreyBox(content)
              : requestInfoDetailCardContentUnderLine(content),
        ],
      ));
}

Widget requestInfoDetailCardContentTitle(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget requestInfoDetailCardContentGreyBox(String content) {
  return Container(
      width: 280,
      decoration: roundedBoxWithShadowStyle(
          bgColor: const Color(0xFFF2F2F2), borderRadius: 20, shadow: false),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Text(content),
      ));
}

Widget requestInfoDetailCardContentUnderLine(String content) {
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(content),
          )));
}
