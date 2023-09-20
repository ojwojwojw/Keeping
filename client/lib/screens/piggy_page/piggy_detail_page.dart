import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/allow_search_bar.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/screens/piggy_page/make_piggy_test.dart';
import 'package:keeping/screens/piggy_page/piggy_saving_page.dart';
import 'package:keeping/screens/piggy_page/widgets/chart_sample.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_detail_info.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class PiggyDetailPage extends StatefulWidget {
  final String piggyAccountNumber;

  PiggyDetailPage({
    super.key,
    required this.piggyAccountNumber,
  });

  @override
  State<PiggyDetailPage> createState() => _PiggyDetailPageState();
}

class _PiggyDetailPageState extends State<PiggyDetailPage> {
  dynamic piggyResponse;

  @override
  void initState() {
    super.initState();
    initPiggyDetail();

  }

  initPiggyDetail() async {
    final _response = {
      "piggy": {
        "id": 3,
        "piggyAccountNumber": "1",
        "content": "아디다스 삼바",
        "goalMoney": 140000,
        "balance": 70000,
        "uploadImage": "produce1.png",
      },
      "saving": [
        {
          "id": 13,
          "name": "1회차",
          "money": 3000,
          "balance": 3000,
          "createdDate": "2023-09-01 12:23"
        },
        {
          "id": 35,
          "name": "2회차",
          "money": 5500,
          "balance": 8500,
          "createdDate": "2023-09-02 18:45"
        }
      ]
    };
    await context.read<PiggyDetailProvider>().initPiggyDetail(_response['piggy']);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          PiggyDetailInfo(),
          AllowSearchBar(),
          Expanded(
            child: Container(
              decoration: lightGreyBgStyle(),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MoneyRecordsDate(date: DateTime.parse('2020-10-10T14:58:04+09:00')),
                    // ..._response['saving']?.map((e) =>
                    //   MoneyRecord(
                    //     date: DateTime.parse(e['date']), 
                    //     storeName: e['store_name'], 
                    //     money: e['money'], 
                    //     balance: e['balance']
                    //   )
                    // ).toList(),
                  ]
                ),
              )
            )
          )
          // ChartSample(),
        ],
      ),
      floatingActionButton: FloatingBtn(
        text: '저금하기',
        icon: Icon(Icons.savings_rounded),
        path: PiggySavingPage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}