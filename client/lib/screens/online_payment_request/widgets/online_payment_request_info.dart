import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

class OnlinePaymentRequestInfo extends StatefulWidget {
  bool? parent;

  OnlinePaymentRequestInfo({
    super.key,
    required this.parent,
  });

  @override
  State<OnlinePaymentRequestInfo> createState() => _OnlinePaymentRequestInfoState();
}

class _OnlinePaymentRequestInfoState extends State<OnlinePaymentRequestInfo> {
  int selectedBtnIdx = 0;  // 선택된 버튼의 인덱스

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: roundedBoxWithShadowStyle(
          // shadow: false,
          blurRadius: 1.5,
          bgColor: Color.fromARGB(255, 249, 240, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.parent != null && !widget.parent! ? 
                  '이유를 적고, 내 돈을 담아\n부모님께 부탁해봐요!'
                  : '자녀가 보낸 내용을 확인하고\n부탁을 고민해봐요!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('🙇‍♀️', style: TextStyle(fontSize: 80),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}