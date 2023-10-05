import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/account_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record_with_detail.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/screens/allowance_ledger_page/child_spending_route_page.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/empty.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class AllowanceLedgerPage extends StatefulWidget {
  const AllowanceLedgerPage({super.key});

  @override
  State<AllowanceLedgerPage> createState() => _AllowanceLedgerPageState();
}

class _AllowanceLedgerPageState extends State<AllowanceLedgerPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _accountNumber;
  int? _balance;
  String? _childKey;
  String? _childAccountNumber;
  int? _childBalance;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _accountNumber = context.read<AccountInfoProvider>().accountNumber;
    _balance = context.read<AccountInfoProvider>().balance;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    _childAccountNumber = context.read<ChildInfoProvider>().accountNumber;
    _childBalance = context.read<ChildInfoProvider>().balance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '용돈기입장',
        backPath: _parent != null && _parent! ? ParentMainPage() : ChildMainPage(),
        // bgColor: const Color(0xFF8320E7),
        // elementColor: Colors.white,
      ),
      body: Column(
        children: [
          AccountInfo(
            accessToken: _accessToken,
            memberKey: _memberKey,
            parent: _parent, 
            balance: _parent != null && _parent == true ? _childBalance : _balance,
          ),
          FutureBuilder(
            future: _parent != null && _parent! == true ? getAccountList(accessToken: _accessToken, memberKey: _memberKey, accountNumber: _childAccountNumber, targetKey: _childKey)
              : getAccountList(accessToken: _accessToken, memberKey: _memberKey, accountNumber: _accountNumber, targetKey: _memberKey),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('용돈기입장 페이지 ${snapshot.data}');
                var response = snapshot.data;
                if (response['resultBody'].isEmpty) {
                  return empty(text: '거래내역이 없습니다.');
                } else if (response['resultStatus']['resultCode'] == '503') {
                  return empty(text: '정보를 불러오는 중 문제가 생겼습니다.\n잠시 후 다시 시도해주세요.');
                }
                List<Widget> widgetLists = [];
                response['resultBody'].forEach((key, valueList) {
                  widgetLists.add(MoneyRecordsDate(date: DateTime.parse(key)));
                  valueList.forEach((record) {
                    widgetLists.add(
                      record['detailed'] ? 
                        MoneyRecordWithDetail(
                          date: DateTime.parse(record['createdDate']), 
                          storeName: record['storeName'], 
                          money: record['money'], 
                          balance: record['balance'], 
                          accountHistoryId: record['id'],
                          detail: record['detailList'],
                          type: record['type'],
                          largeCategory: record['largeCategory'],
                        )
                      :
                        MoneyRecord(
                          date: DateTime.parse(record['createdDate']),
                          storeName: record['storeName'],
                          money: record['money'],
                          balance: record['balance'],
                          accountHistoryId: record['id'],
                          type: record['type'],
                          largeCategory: record['largeCategory'],
                        )
                    );
                  });
                });
                print(response['resultBody'].toString());
                return Expanded(
                  child: Container(
                    decoration: lightGreyBgStyle(),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: widgetLists,
                      ),
                    )
                  )
                );
              } else {
                return const Text('');
              }
            }
          ),
          SizedBox(height: 10,)
        ],
      ),   
      floatingActionButton: FloatingBtn(
        text: '소비지도',
        icon: Icons.map,
        path: ChildSpendingRoutePage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
