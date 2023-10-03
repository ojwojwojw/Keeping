import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';

Widget colorInfoCardStatus(double width, String status) {
  return Container(
    width: width,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: requestStatusBgColor(status)),
    child: Text(
      requestStatusText('부탁', status),
      style: TextStyle(
          color: requestStatusTextColor(status), fontWeight: FontWeight.bold),
    ),
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
  return Text(formattedYMDDate(date));
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
          )))));
}

Widget colorInfoDetailCardContent(String title, String content,
    {bool box = true}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          colorInfoDetailCardContentTitle(title),
          SizedBox(
            height: 5,
          ),
          box
              ? colorInfoDetailCardContentGreyBox(content)
              : colorInfoDetailCardContentUnderLine(content),
        ],
      ));
}

Widget colorInfoDetailCardContentTitle(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget colorInfoDetailCardContentGreyBox(String content) {
  return Container(
      width: 280,
      decoration: roundedBoxWithShadowStyle(
          bgColor: const Color(0xFFF2F2F2), borderRadius: 20, shadow: false),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Text(content),
      ));
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(content),
          )));
}

String requestStatusText(String service, String status) {
  if (status == 'APPROVE') {
    return '$service 완료';
  } else if (status == 'REJECT') {
    return '$service 거절';
  } else {
    return '$service 대기';
  }
}

Color requestStatusBgColor(String status) {
  if (status == 'APPROVE') {
    return Color(0xFFFFC754);
  } else if (status == 'REJECT') {
    return Color(0xFFFF5993);
  } else {
    return Color(0xFF805AF1);
  }
}

Color requestStatusTextColor(String status) {
  // if (status == 'APPROVE') {
  //   return Color(0xFF62D00B);
  // } else if (status == 'REJECT') {
  //   return Color(0xFFFF0000);
  // } else {
  //   return Color(0xFF000000);
  // }
  return Colors.white;
}

String missionRequestStatusText(String status) {
  if (status == 'YET') {
    return '미션 대기';
  } else if (status == 'FINISH_WAIT') {
    return '미션 완료';
  } else if (status == 'FINISH') {
    return '이전 미션';
  } else {
    return '진행 중';
  }
}

Color missionRequestStatusBgColor(String status) {
  if (status == 'YET') {
    return Color(0xFFFF5993);
  } else if (status == 'FINISH_WAIT') {
    return Color(0xFFFF8F67);
  } else if (status == 'FINISH') {
    return Color(0xFFFFC754);
  } else {
    return Color(0xFF805AF1);
  }
}

// Color missionRequestStatusTextColor(String status) {
//   if (status == 'APPROVE') {
//     return Color(0xFF62D00B);
//   } else if (status == 'REJECT') {
//     return Color(0xFFFF0000);
//   } else {
//     return Color(0xFF000000);
//   }
// }
