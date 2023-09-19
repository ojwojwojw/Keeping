import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';

final formattedMoney = NumberFormat('#,##0');
final formattedTime = DateFormat('HH:mm');

class MoneyRecordWithDetail extends StatefulWidget {
  // 카테고리 따라 사진 다르게 설정, 지출 입금 따라 -/+ 기호 추가
  final DateTime date;
  final String storeName;
  final num money;
  final num balance;
  final List<dynamic> detail;

  MoneyRecordWithDetail({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    required this.detail
  });

  @override
  State<MoneyRecordWithDetail> createState() => _MoneyRecordWithDetail();
}

class _MoneyRecordWithDetail extends State<MoneyRecordWithDetail> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Container(
            width: 360,
            decoration: moneyRecordStyle(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _mainMoneyRecord(
                    widget.storeName, widget.date, widget.money, widget.balance
                  ),
                  _detailMoneyRecords(widget.detail),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _mainMoneyRecord(String storeName, DateTime date, num money, num balance) {
  return Container(
    height: 90,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: _categoryImg('assets/image/temp_image.jpg'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName, 
                  style: bigStyle(),
                ),
                Text(
                  formattedTime.format(date),
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
              Text('-${formattedMoney.format(money)}원', style: bigStyle(),),
              Text('${formattedMoney.format(balance)}원')
            ],
          )
        ),
      ],
    ),
  );
}

Widget _detailMoneyRecords(List<dynamic> detail) {
  return Container(
    color: Color.fromARGB(255, 242, 242, 242),
    child: Column(
      children: detail.map((e) => 
        _detailMoneyRecord(
          e['content'], e['money']
        )
      ).toList()
    ),
  );
}

Widget _detailMoneyRecord(String content, num money) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Container(
      height: 90,
      alignment: Alignment.center,
      color: Colors.transparent,
      // decoration: moneyRecordStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: _categoryImg('assets/image/temp_image.jpg'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content, 
                    style: bigStyle(),
                  ),
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
                Text('-${formattedMoney.format(money)}원', style: bigStyle(),),
              ],
            )
          ),
        ],
      ),
    )
  );
}

// 카테고리 이미지
ClipOval _categoryImg(String imgPath) {
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