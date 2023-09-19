import 'package:flutter/material.dart';

class PiggyInfo extends StatefulWidget {
  PiggyInfo({
    super.key
  });

  @override
  State<PiggyInfo> createState() => _PiggyInfoState();
}

class _PiggyInfoState extends State<PiggyInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '무슨 내용을 넣지',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white
            ),
          ),
          SizedBox(height: 10,),
          Text(
            '저금통 통계를 넣어볼까',
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