import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/request_info_card_elements.dart';
import 'package:provider/provider.dart';

class RequestInfoDetailCard extends StatefulWidget {
  final String name;
  final String reason;
  final String status;
  final int money;
  final DateTime createdDate;

  RequestInfoDetailCard({
    super.key,
    required this.name,
    required this.reason,
    required this.status,
    required this.money,
    required this.createdDate,
  });

  @override
  State<RequestInfoDetailCard> createState() => _RequestInfoDetailCardState();
}

class _RequestInfoDetailCardState extends State<RequestInfoDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 300,
          height: 450,
          decoration: roundedBoxWithShadowStyle(
              borderRadius: 30,
              shadow: false,
              border: true,
              borderColor: requestStatusBgColor(widget.status)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Column(
              children: [
                requestInfoCardStatus(300, widget.status),
                requestInfoDetailCardHeader(
                    widget.createdDate, widget.name, widget.money, widget.status),
                colorInfoDetailCardContents(
                  Column(
                    children: [
                      colorInfoDetailCardContent('조르기 메세지', widget.reason),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget requestInfoDetailCardHeader(DateTime date, String name, int money, String status) {
  String setImgPath(status) {
    if (status == 'APPROVE') {
      return 'assets/image/face/face4.png';
    } else if (status == 'REJECT') {
      return 'assets/image/face/face6.png';
    } else {
      return 'assets/image/face/face1.png';
    }
  }
  String formatMoney = formattedMoney(money);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        colorInfoDetailDate(date),
        SizedBox(height: 10),
        Row(
          children: [
            roundedAssetImg(imgPath: setImgPath(status), size: 90),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      '$name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '이/가',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      Text(
                        '$formatMoney',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '을',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '졸랐어요!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
