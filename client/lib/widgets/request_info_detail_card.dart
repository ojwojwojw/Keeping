import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/request_info_card_elements.dart';

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
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                requestInfoCardStatus(300, widget.status),
                requestInfoDetailCardHeader(
                    widget.createdDate, widget.name, widget.money),
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

Widget requestInfoDetailCardHeader(DateTime date, String name, int money) {
  String formatMoney = formattedMoney(money);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        colorInfoDetailDate(date),
        SizedBox(height: 30),
        Row(
          children: [
            categoryImg('assets/image/temp_image.jpg', size: 75),
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
