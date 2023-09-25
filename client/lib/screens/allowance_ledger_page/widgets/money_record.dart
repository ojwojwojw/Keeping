import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_detail_create_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_modal.dart';

class MoneyRecord extends StatefulWidget {
  // 카테고리 따라 사진 다르게 설정, 지출 입금 따라 -/+ 기호 추가
  final DateTime date;
  final String storeName;
  final num money;
  final num balance;
  final Map<String, dynamic>? detail;

  MoneyRecord({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    this.detail
  });

  @override
  State<MoneyRecord> createState() => _MoneyRecordState();
}

class _MoneyRecordState extends State<MoneyRecord> {
  final formattedMoney = NumberFormat('#,##0');
  final formattedTime = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        bottomModal(
          context: context,
          title: '상세 내역 쓰기',
          content: moneyRecordModalContent(widget.date, widget.storeName, widget.money),
          button: moneyRecordModalBtns(context, widget.date, widget.storeName, widget.money, widget.balance),
        );
      },
      child: Padding(
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
                        widget.storeName, 
                        style: bigStyle(),
                      ),
                      Text(
                        formattedTime.format(widget.date),
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
                    Text('-${formattedMoney.format(widget.money)}원', style: bigStyle(),),
                    Text('${formattedMoney.format(widget.balance)}원')
                  ],
                )
              ),
            ],
          ),
        )
      )
    );
  }
}

// 용돈기입장 내역 큰 글씨
TextStyle bigStyle() {
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600
  );
}

// 용돈기입장 내역 작고 옅은 글씨
TextStyle smallStyle() {
  return TextStyle(
    color: const Color(0xFF696969)
  );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(DateFormat('M월 d일').format(date).toString()),
            ]
          ),
          SizedBox(height: 7,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(storeName, style: bigStyle(),),
              Text('${NumberFormat('#,##0').format(money).toString()}원', style: bigStyle(),)
            ],
          )
        ],
      )
    )
  );
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어갈 버튼(2개)
Row moneyRecordModalBtns(
  BuildContext context, DateTime date, String storeName, num money, num balance
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      moneyRecordModalBtn(
        Icons.receipt_long, 
        '영수증 찍기', 
        context, 
        AllowanceLedgerDetailCreatePage(date: date, storeName: storeName, money: money, balance: balance,)),
      moneyRecordModalBtn(
        Icons.create, 
        '직접 쓰기', 
        context, 
        AllowanceLedgerDetailCreatePage(date: date, storeName: storeName, money: money, balance: balance,))
    ],
  );
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어가는 버튼 한 개
InkWell moneyRecordModalBtn(IconData icon, String text, BuildContext context, Widget path) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => path));
    },
    child: Container(
      width: 150,
      height: 150,
      decoration: _moneyRecordModalBtnStyle(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 50,),
          Text(text, style: TextStyle(fontSize: 20),)
        ],
      ),
    )
  );
}

// 용돈기입장 내역 클릭시 나오는 모달 버튼 스타일
BoxDecoration _moneyRecordModalBtnStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: Color.fromARGB(255, 236, 236, 236), // 테두리 색상
      width: 2.0, // 테두리 두께
    ),
  );
}