import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/parent_accept_request_money/parent_accept_request_money.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_page.dart';
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
      child: SizedBox(
        width: 350,
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money_rounded,
                    size: 70,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formattedMoney(balance),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        if (_parent && _accountNumber != '') {
                          return ParentRequestMoneyPage();
                        } else if (_parent == false && _accountNumber != '') {
                          return ChildRequestMoneyPage();
                        } else {
                          return MakeAccountPage();
                        }
                      },
                    ),
                  );
                },
                style: accountInfoRoundedBtn(300, 50),
                child: Text(
                  _parent ? '용돈 조르기 모아보기' : '용돈 조르기',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
