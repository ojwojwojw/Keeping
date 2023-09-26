import 'package:flutter/material.dart';

class OnlinePaymentRequestInfo extends StatefulWidget {
  OnlinePaymentRequestInfo({super.key});

  @override
  State<OnlinePaymentRequestInfo> createState() => _OnlinePaymentRequestInfoState();
}

class _OnlinePaymentRequestInfoState extends State<OnlinePaymentRequestInfo> {
  int selectedBtnIdx = 0;  // 선택된 버튼의 인덱스

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
            '무슨 내용을 넣을까',
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