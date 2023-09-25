import 'package:flutter/material.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/child_tag.dart';

class AccountInfo extends StatefulWidget {
  final String? type;

  AccountInfo({
    super.key,
    required this.type,
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
              '50,000원',
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