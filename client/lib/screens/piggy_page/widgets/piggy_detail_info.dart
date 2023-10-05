import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_detail_chart.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class PiggyDetailInfo extends StatefulWidget {
  final int piggyId;
  final String content;
  final int balance;
  final int goalMoney;
  final String img;
  final DateTime createdDate;

  PiggyDetailInfo({
    super.key,
    required this.piggyId,
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
  String? accessToken;
  String? memberKey;
  bool? parent;
  String? childKey;
  String? childName;

  @override
  void initState() {
    super.initState();
    accessToken = context.read<UserInfoProvider>().accessToken;
    memberKey = context.read<UserInfoProvider>().memberKey;
    parent = context.read<UserInfoProvider>().parent;
    childKey = context.read<ChildInfoProvider>().memberKey;
    childName = context.read<ChildInfoProvider>().name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: roundedBoxWithShadowStyle(
          blurRadius: 1.5,
          bgColor: Color.fromARGB(255, 242, 230, 255),
        ),
        child: FutureBuilder(
          future: getPiggyDetailList(
            accessToken: accessToken,
            memberKey: memberKey,
            piggyId: widget.piggyId,
            targetKey: parent != null && !parent! ? memberKey : childKey,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['resultStatus']['resultCode'] == '404' || snapshot.data['resultStatus']['resultCode'] == '401') {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            if (parent != null && parent! && childName != null) ChildTag(childName: childName!, text: '저금통',),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                roundedMemoryImg(img: widget.img),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Center(
                                        child: TextScroll(
                                          widget.content,
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black,),
                                          intervalSpaces: 10,
                                          velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                                        ),
                                      )
                                    ),
                                    Text(formattedMoney(widget.balance), style: TextStyle(fontSize: 32, color: Colors.black),),
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
                );
              }
              var response = snapshot.data['resultBody'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          if (parent != null && parent! && childName != null) ChildTag(childName: childName!, text: '저금통',),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              roundedMemoryImg(img: widget.img),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: Center(
                                      child: TextScroll(
                                        widget.content,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black,),
                                        intervalSpaces: 10,
                                        velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                                      ),
                                    )
                                  ),
                                  Text(formattedMoney(widget.balance), style: TextStyle(fontSize: 32, color: Colors.black),),
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
              );
            }
            return Column(

            );
          }
        ),
      ),
    );
  }
}