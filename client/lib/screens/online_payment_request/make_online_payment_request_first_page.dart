import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

class MakeOnlinePaymentRequestFirstPage extends StatefulWidget {
  MakeOnlinePaymentRequestFirstPage({
    super.key
  });

  @override
  State<MakeOnlinePaymentRequestFirstPage> createState() => _MakeOnlinePaymentRequestFirstPageState();
}

class _MakeOnlinePaymentRequestFirstPageState extends State<MakeOnlinePaymentRequestFirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '온라인 결제 부탁하기',
      ),
      body: Container(),
      bottomNavigationBar: BottomBtn(
        text: '다음',
      ),
    );
  }
}