import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/reload_btn.dart';

class PiggyInfo extends StatefulWidget {
  bool? parent;
  final reload;

  PiggyInfo({
    super.key,
    required this.parent,
    required this.reload,
  });

  @override
  State<PiggyInfo> createState() => _PiggyInfoState();
}

class _PiggyInfoState extends State<PiggyInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: roundedBoxWithShadowStyle(
              // shadow: false,
              blurRadius: 1.5,
              bgColor: Color.fromARGB(255, 255, 240, 248),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.parent != null && !widget.parent! ? 
                          '목표를 정하고\n차곡차곡 모아보아요!'
                          : '자녀가 갖고 싶은건\n무엇일까요?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   child: widget.parent != null && widget.parent! ? null : 
                      //     InkWell(
                      //       onTap: () {
                              
                      //       }, 
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: const [
                      //           Text('만들러가기'),
                      //           Icon(Icons.arrow_right)
                      //         ],
                      //       )
                      //     ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/image/main/cropped_piggy.png', height: 100,),
                        // Text('🐷', style: TextStyle(fontSize: 80),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: reloadBtn(widget.reload),
          ),
        ],
      ),
    );
  }
}