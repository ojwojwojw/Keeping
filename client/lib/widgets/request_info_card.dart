import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

class RequestInfoCard extends StatefulWidget {
  final int money;
  final String status;
  final DateTime createdDate;
  final Widget path;

  RequestInfoCard({
    super.key,
    required this.money,
    required this.status,
    required this.createdDate,
    required this.path,
  });

  @override
  State<RequestInfoCard> createState() => _RequestInfoCardState();
}

class _RequestInfoCardState extends State<RequestInfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget.path));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Container(
            width: 360,
            height: 110,
            decoration: roundedBoxWithShadowStyle(borderRadius: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Column(
                children: [
                  _requestStatus(widget.status),
                  _requestContent(widget.money, widget.status),
                ],
              ),
            )),
      ),
    );
  }
}

Widget _requestStatus(String status) {
  return Container(
    width: 360,
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

Widget _requestContent(int money, String status) {
  String setImgPath(status) {
    if (status == 'APPROVE') {
      return 'assets/image/face/face4.png';
    } else if (status == 'REJECT') {
      return 'assets/image/face/face6.png';
    } else {
      return 'assets/image/face/face1.png';
    }
  }
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          categoryImg(setImgPath(status)),
          SizedBox(
            width: 250,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                formattedMoney(money),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '을 졸랐어요!',
                style: TextStyle(fontSize: 20),
              )
            ]),
          ),
        ],
      ),
    ),
  );
}
