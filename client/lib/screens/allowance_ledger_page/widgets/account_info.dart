import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';
import 'package:keeping/widgets/reload_btn.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class AccountInfo extends StatefulWidget {
  final String? accessToken;
  final String? memberKey;
  final bool? parent;
  final int? balance;
  final reload;

  AccountInfo({
    super.key,
    required this.accessToken,
    required this.memberKey,
    required this.parent,
    required this.balance,
    required this.reload,
  });

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String? _childName;
  String? _childKey;

  @override
  void initState() {
    super.initState();
    _childName = context.read<ChildInfoProvider>().name;
    _childKey = context.read<ChildInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: roundedBoxWithShadowStyle(
          blurRadius: 1.5,
          bgColor: Color.fromARGB(255, 255, 247, 222),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.parent != null && widget.parent! == true && _childName != null ? 10 : 30, 
                bottom: 30
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.parent != null && widget.parent! == true && _childName != null)
                    ChildTag(childName: _childName!, text: '용돈 잔액'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '🪙 ',
                      //   style: TextStyle(fontSize: 35,),
                      // ),
                      Image.asset('assets/image/money/coin.png', height: 60,),
                      SizedBox(width: 8,),
                      Text(
                        widget.balance == null ? '0원' : formattedMoney(widget.balance),
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: getMonthTotalExpense(
                      accessToken: widget.accessToken,
                      memberKey: widget.memberKey,
                      targetKey: widget.parent != null && widget.parent!
                          ? _childKey
                          : widget.memberKey,
                      date: DateFormat('yyyy-MM').format(DateTime.now()),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['resultStatus']['resultCode'] == '503') {
                          return Text(
                            '${DateTime.now().month}월 총 지출액: 0원',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),
                          );
                        }
                        var response = snapshot.data['resultBody'];
                        return Text(
                          '${DateTime.now().month}월 총 지출액: ${formattedMoney(response)}',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        );
                      } else {
                        return Text('');
                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: reloadBtn(widget.reload),
            ),
          ],
        ),
      ),
    );
  }
}
