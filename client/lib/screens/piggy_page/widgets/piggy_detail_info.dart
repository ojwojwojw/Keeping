import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/util/display_format.dart';
import 'package:provider/provider.dart';

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
            context.watch<PiggyDetailProvider>().content!,
            style: TextStyle(
              fontSize: 40,
              color: Colors.white
            ),
          ),
          Row(
            children: [
              Text('이미지'),
              Text(formattedMoney(context.watch<PiggyDetailProvider>().balance))
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

// 둥근 저금통 이미지
ClipOval categoryImg(String imgPath) {
  return ClipOval(
    child: SizedBox(
      width: 60,
      height: 60,
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover
      ),
    ),
  );
}