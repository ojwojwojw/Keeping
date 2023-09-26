import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';

class AccountInfo extends StatefulWidget {
  final String? accessToken;
  final String? memberKey;
  final bool? parent;
  final int? balance;

  AccountInfo({
    super.key,
    required this.accessToken,
    required this.memberKey,
    required this.parent,
    required this.balance,
  });

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.parent != null && widget.parent! == true) ChildTag(childName: '김첫째', text: '용돈 잔액'),
            Text(
              widget.balance == null ? '0원' : formattedMoney(widget.balance),
              style: TextStyle(
                fontSize: 40,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            FutureBuilder(
              future: getMonthTotalExpense(
                accessToken: widget.accessToken,
                memberKey: widget.memberKey,
                targetKey: widget.parent != null && widget.parent! ? null : widget.memberKey,
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              ), 
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var response = snapshot.data['resultBody'];
                  return Text(
                    '${DateTime.now().month}월 총 지출액: ${formattedMoney(response)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  );
                } else {
                  return Text('로딩중');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}