import 'package:flutter/material.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/util/display_format.dart';

class AccountInfo extends StatelessWidget {
  final int balance;
  
  AccountInfo({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AllowanceLedgerPage()));
      },
      child: SizedBox(
        width: 350,
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image(image: image),
                  Icon(Icons.money_rounded, size: 70,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formattedMoney(balance),
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              // ElevatedButton(
              //   onPressed: () {
                  
              //   },
              //   style: accountInfoRoundedBtn(300, 50),
              //   child: Text('용돈 조르기'),
              // )
            ],
          ),
        ),
      ),
    );
  }
}