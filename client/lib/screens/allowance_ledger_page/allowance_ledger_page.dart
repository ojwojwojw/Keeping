import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/account_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record_with_detail.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/screens/allowance_ledger_page/child_spending_route_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class AllowanceLedgerPage extends StatefulWidget {
  const AllowanceLedgerPage({super.key});

  @override
  State<AllowanceLedgerPage> createState() => _AllowanceLedgerPageState();
}

class _AllowanceLedgerPageState extends State<AllowanceLedgerPage> {
  // final List<Map<String, dynamic>> _tempData = [
  //   {
  //     'date': '2020-10-10T14:58:04+09:00',
  //     'store_name': '달콤왕가탕후루 전대',
  //     'money': 3000,
  //     'balance': 50000,
  //     'detail': []
  //   },
  //   {
  //     'date': '2020-10-10T14:58:04+09:00',
  //     'store_name': '올리브영 전대',
  //     'money': 5000,
  //     'balance': 53000,
  //     'detail': [
  //       {
  //         'content': '클렌징티슈',
  //         'money': 3000
  //       },
  //       {
  //         'content': '초콜릿',
  //         'money': 2000
  //       },
  //     ]
  //   },
  //   {
  //     'date': '2020-10-10T14:58:04+09:00',
  //     'store_name': '달콤왕가탕후루 전대',
  //     'money': 3000,
  //     'balance': 58000,
  //     'detail': []
  //   },
  //   {
  //     'date': '2020-10-10T14:58:04+09:00',
  //     'store_name': '달콤왕가탕후루 전대',
  //     'money': 3000,
  //     'balance': 61000,
  //     'detail': []
  //   },
  // ];

  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _accountNumber;
  int? _balance;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    // _accessToken = context.read<UserInfoProvider>().accessToken;
    // _memberKey = context.read<UserInfoProvider>().memberKey;
    // _accountNumber = context.read<UserInfoProvider>().accountNumber;
    // _balance = context.read<UserInfoProvider>().balance;
    _accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NGFiMjY2MS00N2EyLTQ4NmMtOWY3Zi1mOGNkNTkwMGRiMTAiLCJleHAiOjE2OTU3MDM4NzZ9.Pmks2T9tCqjazb4IUgx1GVUCbtOz97DsBBGKrwkGd5c';
    _memberKey = '84ab2661-47a2-486c-9f7f-f8cd5900db10';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈기입장',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _accessToken == null || _memberKey == null || _accountNumber == null ? null :
          getAccountList(accessToken: _accessToken!, memberKey: _memberKey!, accountNumber: _accountNumber!),
        builder: (context, snapshot) {
          return Column(
            children: [
              AccountInfo(parent: _parent, balance: _balance,),
              Expanded(
                child: Container(
                  decoration: lightGreyBgStyle(),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MoneyRecordsDate(date: DateTime.parse('2020-10-10T14:58:04+09:00')),
                        // ..._tempData.map((e) => 
                        //   e['detail'].isEmpty ? 
                        //     MoneyRecord(
                        //       date: DateTime.parse(e['date']), 
                        //       storeName: e['store_name'], 
                        //       money: e['money'], 
                        //       balance: e['balance'],
                        //       accountHistoryId: e['id'],
                        //     )
                        //   :
                        //     MoneyRecordWithDetail(
                        //       date: DateTime.parse(e['date']), 
                        //       storeName: e['store_name'], 
                        //       money: e['money'], 
                        //       balance: e['balance'],
                        //       detail: e['detail'],
                        //     )
                        // ).toList(),
                      ]
                    ),
                  )
                )
              )
            ],
          );
        }
      ),
      floatingActionButton: FloatingBtn(
        text: '소비지도',
        icon: Icon(Icons.map),
        path: ChildSpendingRoutePage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
