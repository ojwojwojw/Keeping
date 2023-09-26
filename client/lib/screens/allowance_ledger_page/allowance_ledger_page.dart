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
    _accountNumber = '171-682675-422-27';
    // _accountNumber = context.read<UserInfoProvider>().accountNumber;
    // _balance = context.read<UserInfoProvider>().balance;
    _accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1OTVkOTUyYy0xNmVkLTQwOGUtYmE2My1lZjk4OGQ2MjRmYTUiLCJleHAiOjE2OTU4MDQ4NTh9.fddpAvh-i63SvuXF0DVHj480lduLnnZz0qgNaVVMfI4';
    _memberKey = '595d952c-16ed-408e-ba63-ef988d624fa5';
  }

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
          AccountInfo(parent: _parent, balance: _balance,),
          FutureBuilder(
            future: _parent != null && _parent! ? getAccountList(accessToken: _accessToken, memberKey: _memberKey, accountNumber: _accountNumber, targetKey: 'd')
              : getAccountList(accessToken: _accessToken, memberKey: _memberKey, accountNumber: _accountNumber, targetKey: _memberKey),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('로딩중');
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('에러');
                } else if (snapshot.hasData) {
              // List<Post> _posts = snapshot.data as List<Post>; 이런 식으로 정의하기
              // return Column(
              //   children: [
                  print('스냅샷스냅샷스냅샷 ${snapshot.data}');
                  return Column(
                    children: [
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

                } else {
                  return const Text('스냅샷 데이터 없음');
                }
              } else {
                return Text('퓨처 객체 null');
              }
            }
          ),
        ],
      ),   
      // floatingActionButton: FloatingBtn(
      //   text: '소비지도',
      //   icon: Icon(Icons.map),
      //   path: ChildSpendingRoutePage(),
      // ),
      // bottomNavigationBar: BottomNav(),
    );
  }
}
