import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/parent_accept_request_money/parent_accept_request_money.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:provider/provider.dart';

class AccountInfo extends StatelessWidget {
  final int balance;

  AccountInfo({
    super.key,
    required this.balance,
  });
  @override
  Widget build(BuildContext context) {
    bool _parent = context.read<UserInfoProvider>().parent;
    String _accountNumber = context.read<AccountInfoProvider>().accountNumber;
    print(_parent);
    print(_accountNumber);
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AllowanceLedgerPage()));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: SizedBox(
          height: 160,
          child: DecoratedBox(
            decoration: roundedBoxWithShadowStyle(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/money_coins.png', width: 100,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              formattedMoney(balance),
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${DateTime.now().month}월 총 지출액:'
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(height: 1.2, color: Color.fromARGB(255, 204, 204, 204),),
                ),
                !_parent ? 
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
