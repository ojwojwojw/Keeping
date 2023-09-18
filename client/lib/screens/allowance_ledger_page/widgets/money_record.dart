import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      onTap: () {
        bottomModal(
          context: context,
          title: '상세 내역 쓰기',
          content: Text('안녕'),
          button: Text('안녕'),
        );
      },
      child: Padding(
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

// 용돈기입장 내역 상자 스타일
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

// 카테고리 이미지
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


// 용돈기입장 내역 클릭시 나오는 모달에 들어갈 버튼
