import 'package:flutter/material.dart';
import 'package:keeping/widgets/child_tag.dart';

class AccountInfo extends StatefulWidget {
  AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

const String type = 'PARENT';

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
            if (type == 'PARENT') ChildTag(childName: '김첫째', text: '용돈 잔액'),
            Text(
              '50,000원',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            Text(
              '8월 총 지출액: 20,000원',
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