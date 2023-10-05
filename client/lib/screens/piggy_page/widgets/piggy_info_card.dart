import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';

class PiggyInfoCard extends StatefulWidget {
  final String content;
  final num balance;
  final num goalMoney;
  final String img;

  PiggyInfoCard({
    super.key,
    required this.content,
    required this.balance,
    required this.goalMoney,
    required this.img,
  });

  @override
  State<PiggyInfoCard> createState() => _PiggyInfoCardState();
}

class _PiggyInfoCardState extends State<PiggyInfoCard> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 24),
      child: Container(
        height: 160,
        decoration: roundedBoxWithShadowStyle(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // _piggyStringImg(widget.imgPath),
              roundedMemoryImg(img: widget.img),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.content,
                    style: _contentStyle(),
                  ),
                  Text(
                    formattedMoney(widget.balance),
                    style: _balanceStyle(),
                  ),
                  Text(
                    '목표 금액 ${formattedMoney(widget.goalMoney)}',
                    style: _goalMoneyStyle(),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}

TextStyle _contentStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold
  );
}

TextStyle _balanceStyle() {
  return TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold
  );
}

TextStyle _goalMoneyStyle() {
  return TextStyle(
    fontSize: 15,
    color: Color.fromARGB(255, 124, 124, 124),
  );
}