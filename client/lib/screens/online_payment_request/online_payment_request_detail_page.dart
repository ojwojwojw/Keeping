import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/color_info_detail_card.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';

final _tempData = [
  {
    "id": 1,
    "name": "가방",
    "url": "http://localhost:8080",
    "reason": "이 가방이 너무 예뻐요",
    "cost": 5000,
    "paidMoney": 2000,
    "status": "YET",
    "createdDate": "2020-10-10T14:58:04+09:00"
  },
  {
    "id": 2,
    "name": "신발",
    "url": "http://localhost:8080",
    "reason": "이 신발이 너무 멋져요",
    "cost": 5000,
    "paidMoney": 2000,
    "status": "ACCEPT",
    "createdDate": "2020-10-10T14:58:04+09:00"
  },
  {
    "id": 3,
    "name": "모자",
    "url": "http://localhost:8080",
    "reason": "이 모자가 너무 짱이에요",
    "cost": 5000,
    "paidMoney": 2000,
    "status": "REJECT",
    "createdDate": "2020-10-10T14:58:04+09:00"
  },
];

class OnlinePaymentRequestDetailPage extends StatefulWidget {
  final int onlineId;

  OnlinePaymentRequestDetailPage({
    super.key,
    required this.onlineId,
  });

  @override
  State<OnlinePaymentRequestDetailPage> createState() => _OnlinePaymentRequestDetailPageState();
}

class _OnlinePaymentRequestDetailPageState extends State<OnlinePaymentRequestDetailPage> {
  Map<String, dynamic> _response = {};

  @override
  void initState() {
    super.initState();
    _response = _tempData.firstWhere((e) => e['id'] == widget.onlineId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '부탁 내용 확인하기',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorInfoDetailCard(
              name: _response['name'],
              url: _response['url'],
              reason: _response['reason'],
              cost: _response['cost'],
              paidMoney: _response['paidMoney'],
              status: _response['status'],
              createdDate: DateTime.parse(_response['createdDate']),
            ),
            // ConfirmBtn(
            //   bgColor: Colors.white,
            //   textColor: const Color(0xFFFF8989),
            //   borderColor: const Color(0xFFFFDDDD),
            //   shadow: false,
            // ),
            // SizedBox(height: 45,)
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '확인',
        isDisabled: false,
      ),
    );
  }
}