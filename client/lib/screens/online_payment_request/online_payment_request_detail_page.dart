import 'package:flutter/material.dart';
import 'package:keeping/widgets/color_info_detail_card.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';

class OnlinePaymentRequestDetailPage extends StatefulWidget {
  OnlinePaymentRequestDetailPage({
    super.key,
  });

  @override
  State<OnlinePaymentRequestDetailPage> createState() => _OnlinePaymentRequestDetailPageState();
}

class _OnlinePaymentRequestDetailPageState extends State<OnlinePaymentRequestDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '부탁 내용 확인하기',
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ColorInfoDetailCard(),
            ),
            ConfirmBtn(
              bgColor: Colors.white,
              textColor: const Color(0xFFFF8989),
              borderColor: const Color(0xFFFFDDDD),
              shadow: false,
            ),
            SizedBox(height: 45,)
          ],
        ),
      )
    );
  }
}