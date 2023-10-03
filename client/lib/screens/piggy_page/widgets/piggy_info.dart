import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

class PiggyInfo extends StatefulWidget {
  bool? parent;

  PiggyInfo({
    super.key,
    required this.parent
  });

  @override
  State<PiggyInfo> createState() => _PiggyInfoState();
}

class _PiggyInfoState extends State<PiggyInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: roundedBoxWithShadowStyle(
          // shadow: false,
          blurRadius: 1.5,
          bgColor: Color.fromARGB(255, 255, 240, 248),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.parent != null && !widget.parent! ? 
                  '목표를 정하고\n차곡차곡 모아보아요!'
                  : '지금 자녀가 갖고 싶은건\n무엇일까요?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('🐷', style: TextStyle(fontSize: 80),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}