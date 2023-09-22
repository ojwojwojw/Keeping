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
import 'package:keeping/util/dio_method.dart';
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
  Map<String, dynamic>? _response;

  @override
  void initState() {
    super.initState();
    context.read<PiggyDetailProvider>().removePiggyDetail();
    initPiggyDetail();
  }

  initPiggyDetail() async {
    _response = {
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
    await context.read<PiggyDetailProvider>().initPiggyDetail(_response!['piggy']);
    if (!mounted) return;
    await context.read<PiggyProvider>().initPiggy(_response!['saving']);
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
          FutureBuilder(
            future: dioGet(
              accessToken: "dd", 
              url: "/bank-service/piggy/member-key/piggy-account-number",
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('로딩중');
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('에러');
                } else if (snapshot.hasData) {
                  // List<Post> _posts = snapshot.data as List<Post>; 이런 식으로 정의하기
                  return Column(
                    children: [
                      // PiggyDetailInfo(),
                      // AllowSearchBar(),
                      Expanded(
                        child: Container(
                          decoration: lightGreyBgStyle(),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MoneyRecordsDate(date: DateTime.parse('2020-10-10T14:58:04+09:00')),
                                // ..._response!['saving']!.map((e) =>
                                //   MoneyRecord(
                                //     date: DateTime.parse(e['date']), 
                                //     storeName: e['store_name'], 
                                //     money: e['money'], 
                                //     balance: e['balance']
                                //   )
                                // ).toList(),
                                Text(context.watch<PiggyProvider>().piggyInfos.toString())
                              ]
                            ),
                          )
                        )
                      )
                      // ChartSample(),
                    ],
                  );
                } else {
                  return const Text('스냅샷 데이터 없음');
                }
              } else {
                return Text('퓨처 객체 null');
              }
            },
          ),
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