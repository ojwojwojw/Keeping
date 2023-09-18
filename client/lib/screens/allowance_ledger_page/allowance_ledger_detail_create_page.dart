import 'package:flutter/material.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

class AllowanceLedgerDetailCreatePage extends StatefulWidget {
  // 카테고리 따라 사진 다르게 설정, 지출 입금 따라 -/+ 기호 추가
  final DateTime date;
  final String storeName;
  final num money;
  final num balance;
  final Map<String, dynamic>? detail;

  AllowanceLedgerDetailCreatePage({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    this.detail
  });

  @override
  State<AllowanceLedgerDetailCreatePage> createState() => _AllowanceLedgerDetailCreatePageState();
}

class _AllowanceLedgerDetailCreatePageState extends State<AllowanceLedgerDetailCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '상세 내역 쓰기',
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MoneyRecord(date: widget.date, storeName: widget.storeName, money: widget.money, balance: widget.balance)
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(text: '등록하기'),
    );
  }
}