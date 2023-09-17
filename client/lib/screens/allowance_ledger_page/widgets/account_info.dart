import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
    );
  }
}