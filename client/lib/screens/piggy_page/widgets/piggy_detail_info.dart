import 'package:flutter/material.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_detail_chart.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';
import 'package:text_scroll/text_scroll.dart';

class PiggyDetailInfo extends StatefulWidget {
  final bool? parent;
  final String content;
  final int balance;
  final int goalMoney;
  final String img;
  final DateTime createdDate;

  PiggyDetailInfo({
    super.key,
    required this.parent,
    required this.content,
    required this.balance,
    required this.goalMoney,
    required this.img,
    required this.createdDate,
  });

  @override
  State<PiggyDetailInfo> createState() => _PiggyDetailInfoState();
}

class _PiggyDetailInfoState extends State<PiggyDetailInfo> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  if (widget.parent != null && widget.parent!) ChildTag(childName: '김첫째', text: '저금통',),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      roundedMemoryImg(img: widget.img),
                      Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Center(
                              child: TextScroll(
                                widget.content,
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),
                                intervalSpaces: 10,
                                velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                              ),
                            )
                          ),
                          Text(formattedMoney(widget.balance), style: TextStyle(fontSize: 40, color: Colors.white),),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            PiggyDetailChart(balance: widget.balance, goalMoney: widget.goalMoney, createdDate: widget.createdDate,)
          ],
        ),
      ),
    );
  }
}