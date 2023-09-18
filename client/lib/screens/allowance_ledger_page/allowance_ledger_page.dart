import 'package:flutter/material.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/account_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/allow_search_bar.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';

class AllowanceLedgerPage extends StatefulWidget {
  const AllowanceLedgerPage({super.key});

  @override
  State<AllowanceLedgerPage> createState() => _AllowanceLedgerPageState();
}

class _AllowanceLedgerPageState extends State<AllowanceLedgerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈기입장',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          AccountInfo(),
          AllowSearchBar(),
          Expanded(
            child: Container(
              decoration: moneyRecordsBgStyle(),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    moneyRecordDate(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                    MoneyRecord(),
                  ],
                ),
              )
            )
          )
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

BoxDecoration moneyRecordsBgStyle() {
  return BoxDecoration(
    color: const Color(0xFFFAFAFA),
  );
}

Padding moneyRecordDate() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: 360,
      child: Text(
        '9월 18일',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),
      )  
    )
  );
}