import 'package:flutter/material.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/account_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/allow_search_bar.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record_with_detail.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';

class AllowanceLedgerPage extends StatefulWidget {
  const AllowanceLedgerPage({super.key});

  @override
  State<AllowanceLedgerPage> createState() => _AllowanceLedgerPageState();
}

class _AllowanceLedgerPageState extends State<AllowanceLedgerPage> {
  final List<Map<String, dynamic>> tempData = [
    {
      'date': '2020-10-10T14:58:04+09:00',
      'store_name': '달콤왕가탕후루 전대',
      'money': 3000,
      'balance': 50000,
      'detail': []
    },
    {
      'date': '2020-10-10T14:58:04+09:00',
      'store_name': '올리브영 전대',
      'money': 5000,
      'balance': 53000,
      'detail': [
        {
          'content': '클렌징티슈',
          'money': 3000
        },
        {
          'content': '초콜릿',
          'money': 2000
        },
      ]
    },
    {
      'date': '2020-10-10T14:58:04+09:00',
      'store_name': '달콤왕가탕후루 전대',
      'money': 3000,
      'balance': 58000,
      'detail': []
    },
    {
      'date': '2020-10-10T14:58:04+09:00',
      'store_name': '달콤왕가탕후루 전대',
      'money': 3000,
      'balance': 61000,
      'detail': []
    },
  ];
  
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
                    MoneyRecordsDate(date: DateTime.parse('2020-10-10T14:58:04+09:00')),
                    ...tempData.map((e) => 
                      e['detail'].isEmpty ? 
                        MoneyRecord(
                          date: DateTime.parse(e['date']), 
                          storeName: e['store_name'], 
                          money: e['money'], 
                          balance: e['balance']
                        )
                      :
                        MoneyRecordWithDetail(
                          date: DateTime.parse(e['date']), 
                          storeName: e['store_name'], 
                          money: e['money'], 
                          balance: e['balance'],
                          detail: e['detail'],
                        )
                    ).toList(),
                  ]
                  // children: [
                    
                  //   MoneyRecordsDate(date: DateTime.parse('2020-10-10T14:58:04+09:00')),
                  //   MoneyRecord(
                  //     date: DateTime.parse('2020-10-10T14:58:04+09:00'),
                  //     storeName: '달콤왕가탕후루 전대',
                  //     money: 3000,
                  //     balance: 50000,
                  //   ),
                  //   MoneyRecord(
                  //     date: DateTime.parse('2020-10-10T14:58:04+09:00'),
                  //     storeName: '올리브영 전대',
                  //     money: 5000,
                  //     balance: 53000,
                  //   ),
                  // ],
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