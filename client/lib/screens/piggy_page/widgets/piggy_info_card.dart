import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/styles.dart';

class PiggyInfoCard extends StatefulWidget {
  final String content;
  final num balance;
  final num goalMoney;
  // final Uint8List img;
  final dynamic img;
  final String imgPath;

  PiggyInfoCard({
    super.key,
    required this.content,
    required this.balance,
    required this.goalMoney,
    this.img,
    // required this.img,
    this.imgPath = 'assets/image/temp_image.jpg',
  });

  @override
  State<PiggyInfoCard> createState() => _PiggyInfoCardState();
}

class _PiggyInfoCardState extends State<PiggyInfoCard> {
  final formattedMoney = NumberFormat('#,##0');
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Container(
        width: 360,
        height: 160,
        decoration: roundedBoxWithShadowStyle(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _piggyStringImg(widget.imgPath),
              // widget.img ? _piggyStringImg(widget.imgPath) : _piggyImg(widget.img!),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.content,
                    style: _contentStyle(),
                  ),
                  Text(
                    '${formattedMoney.format(widget.balance)}원',
                    style: _balanceStyle(),
                  ),
                  Text(
                    '목표 금액 ${formattedMoney.format(widget.goalMoney)}원',
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

ClipOval _piggyImg(Uint8List img) {
  return ClipOval(
    child: SizedBox(
      width: 100,
      height: 100,
      child: Image.memory(
        img,
        fit: BoxFit.cover
      ),
    ),
  );
}

ClipOval _piggyStringImg(String imgPath) {
  return ClipOval(
    child: SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover
      ),
    ),
  );
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