import 'package:flutter/material.dart';

class MoneyRecord extends StatefulWidget {
  MoneyRecord({super.key});

  @override
  State<MoneyRecord> createState() => _MoneyRecordState();
}

class _MoneyRecordState extends State<MoneyRecord> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 360,
        height: 90,
        alignment: Alignment.center,
        decoration: moneyRecordStyle(),
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
                      '달콤왕가탕후루 전대', 
                      style: bigStyle(),
                    ),
                    Text(
                      '16:41',
                    )
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
                  Text('-3,000원', style: bigStyle(),),
                  Text('50,000원')
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}

BoxDecoration moneyRecordStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.7),
        spreadRadius: 0,
        blurRadius: 5.0,
        offset: Offset(0, 0),
      ),
    ],
  );
}

ClipOval categoryImg(String imgPath) {
  return ClipOval(
    child: SizedBox(
      width: 60,
      height: 60,
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover
      ),
    ),
  );
}

TextStyle bigStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600
  );
}

TextStyle smallStyle() {
  return TextStyle(
    color: const Color(0xFF696969)
  );
}