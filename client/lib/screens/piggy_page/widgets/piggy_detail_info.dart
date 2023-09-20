import 'package:flutter/material.dart';
import 'package:keeping/screens/piggy_page/widgets/chart_sample.dart';

class PiggyDetailInfo extends StatefulWidget {
  PiggyDetailInfo({
    super.key,
  });

  @override
  State<PiggyDetailInfo> createState() => _PiggyDetailInfoState();
}

class _PiggyDetailInfoState extends State<PiggyDetailInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '무슨 내용을 넣지',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white
            ),
          ),
          Row(
            children: [
              Text('이미지'),
              Text('74,000원')
            ],
          ),
          Text(
            '저금통 통계를 넣어볼까',
          )
        ],
      ),
    );
  }
}