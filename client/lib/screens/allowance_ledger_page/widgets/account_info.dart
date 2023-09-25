import 'package:flutter/material.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';

class AccountInfo extends StatefulWidget {
  final String? type;
  final int? balance;

  AccountInfo({
    super.key,
    required this.type,
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
            if (widget.type == 'PARENT') ChildTag(childName: '김첫째', text: '용돈 잔액'),
            Text(
              widget.balance == null ? '0원' : formattedMoney(widget.balance),
              style: TextStyle(
                fontSize: 40,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            Text(
              '${DateTime.now().month}월 총 지출액: ${formattedMoney(10000)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}