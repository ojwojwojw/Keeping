import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';

class PiggyMoneyRecord extends StatefulWidget {
  final DateTime date;
  final String name;
  final int money;
  final int balance;

  PiggyMoneyRecord({
    super.key,
    required this.date,
    required this.name,
    required this.money,
    required this.balance,
  });

  @override
  State<PiggyMoneyRecord> createState() => _PiggyMoneyRecordState();
}

class _PiggyMoneyRecordState extends State<PiggyMoneyRecord> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 360,
        height: 90,
        alignment: Alignment.center,
        decoration: roundedBoxWithShadowStyle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: categoryImg('assets/image/temp_image.jpg'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: bigStyle(),
                    ),
                    Text(formattedFullDate(widget.date),)
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${formattedMoney(widget.money)}',
                    style: bigStyle(),
                  ),
                  Text(formattedMoney(widget.balance))
                ],
              )),
          ],
        ),
      )
    );
  }
}

// 용돈기입장 내역 큰 글씨
TextStyle bigStyle() {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
}

// 용돈기입장 내역 작고 옅은 글씨
TextStyle smallStyle() {
  return TextStyle(color: const Color(0xFF696969));
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어갈 내용
Widget moneyRecordModalContent(DateTime date, String storeName, num money) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Color.fromARGB(255, 236, 236, 236), // 위쪽 테두리 색상
          width: 2.0, // 위쪽 테두리 두께
        ),
        bottom: BorderSide(
          color: Color.fromARGB(255, 236, 236, 236), // 아래쪽 테두리 색상
          width: 2.0, // 아래쪽 테두리 두께
        ),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(formattedMDDate(date)),
          ]),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                storeName,
                style: bigStyle(),
              ),
              Text(
                formattedMoney(money).toString(),
                style: bigStyle(),
              )
            ],
          )
        ],
      )
    )
  );
}
