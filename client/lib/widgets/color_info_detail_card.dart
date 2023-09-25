import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

class ColorInfoDetailCard extends StatefulWidget {
  final String name;
  final String url;
  final String reason;
  final int cost;
  final int paidMoney;
  final String status;
  final DateTime createdDate;

  ColorInfoDetailCard({
    super.key,
    required this.name,
    required this.url,
    required this.reason,
    required this.cost,
    required this.paidMoney,
    required this.status,
    required this.createdDate,
  });

  @override
  State<ColorInfoDetailCard> createState() => _ColorInfoDetailCardState();
}

class _ColorInfoDetailCardState extends State<ColorInfoDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => widget.path));
        },
        child: Container(
          width: 300,
          height: 450,
          decoration: roundedBoxWithShadowStyle(borderRadius: 30, shadow: false, border: true, borderColor: requestStatusBgColor(widget.status)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                colorInfoCardStatus(300, widget.status),
                colorInfoDetailCardHeader(widget.createdDate, widget.name),
                colorInfoDetailCardContents(
                  Column(
                    children: [
                      colorInfoDetailCardContent('금액', '${widget.paidMoney} / ${widget.cost}'),
                      colorInfoDetailCardContent('구매 URL', widget.url, box: false),
                      colorInfoDetailCardContent('필요한 이유', widget.reason),
                    ],
                  )
                ),
              ],
            ),
          ) 
        ),
      ),
    );
  }
}