import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/screens/parent_accept_request_money/parent_accept_request_money.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:provider/provider.dart';

class AccountInfo extends StatefulWidget {
  final int balance;

  AccountInfo({
    super.key,
    required this.balance,
  });

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _accountNumber;
  String? _childKey;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _accountNumber = context.read<AccountInfoProvider>().accountNumber;
    _childKey = context.read<ChildInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AllowanceLedgerPage()));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: SizedBox(
          height: 160,
          child: DecoratedBox(
            decoration: roundedBoxWithShadowStyle(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/money_coins.png', width: 100,),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              formattedMoney(widget.balance),
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder(
                              future: getMonthTotalExpense(
                                accessToken: _accessToken,
                                memberKey: _memberKey,
                                targetKey: _parent != null && _parent! ? _childKey : _memberKey,
                                date: DateFormat('yyyy-MM').format(DateTime.now()),
                              ), 
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data['resultStatus']['resultCode'] == '503') {
                                    return Text(
                                      '${DateTime.now().month}월 총 지출액: 0원',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF737373)
                                      ),
                                    );
                                  }
                                  var response = snapshot.data['resultBody'];
                                  return Text(
                                    '${DateTime.now().month}월 총 지출액: ${formattedMoney(response)}',
                                    style: TextStyle(
                                      fontSize: 14, 
                                      color: Color(0xFF737373)
                                    ),
                                  );
                                } else {
                                  return Text('로딩중');
                                }
                              },
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(height: 1.2, color: Color.fromARGB(255, 204, 204, 204),),
                ),
                _parent != null && !_parent! ? 
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) {
                          if (_accountNumber != '') {
                            return ChildRequestMoneyPage();
                          } else {
                            return MakeAccountPage();
                          }
                        },
                      ),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '용돈 조르기',
                        style: TextStyle(color: Color(0xFFA5A5A5), fontSize: 14),
                      )
                    ),
                  )
                :
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                        
                            },
                            child: Text(
                              '용돈 보내기', 
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFFA5A5A5), fontSize: 14),
                            ),
                          ),
                        ),
                        Container(width: 1.2, height: 30, color: Color.fromARGB(255, 204, 204, 204),),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ParentRequestMoneyPage()),);
                            },
                            child: Text(
                              '조르기 모아보기', 
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFFA5A5A5), fontSize: 14),
                            )
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
