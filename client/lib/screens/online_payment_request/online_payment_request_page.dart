import 'package:flutter/material.dart';
import 'package:keeping/screens/online_payment_request/make_online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_detail_page.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_filters.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_info.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/color_info_card.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';

final _tempData = {
  "online": [
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
    {
      "id": 4,
      "name": "가방",
      "url": "http://localhost:8080",
      "reason": "이 가방이 너무 예뻐요",
      "cost": 5000,
      "paidMoney": 2000,
      "status": "YET",
      "createdDate": "2020-10-10T14:58:04+09:00"
    },
    {
      "id": 5,
      "name": "신발",
      "url": "http://localhost:8080",
      "reason": "이 신발이 너무 멋져요",
      "cost": 5000,
      "paidMoney": 2000,
      "status": "ACCEPT",
      "createdDate": "2020-10-10T14:58:04+09:00"
    },
    {
      "id": 6,
      "name": "모자",
      "url": "http://localhost:8080",
      "reason": "이 모자가 너무 짱이에요",
      "cost": 5000,
      "paidMoney": 2000,
      "status": "REJECT",
      "createdDate": "2020-10-10T14:58:04+09:00"
    },
  ]
};

class OnlinePaymentRequestPage extends StatefulWidget {
  OnlinePaymentRequestPage({
    super.key,
  });

  @override
  State<OnlinePaymentRequestPage> createState() => _OnlinePaymentRequestPageState();
}

class _OnlinePaymentRequestPageState extends State<OnlinePaymentRequestPage> {
  List<Map<String, dynamic>> _response = [];

  @override
  void initState() {
    super.initState();
    _response = _tempData['online'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '온라인 결제 부탁하기',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          OnlinePaymentRequestInfo(),
          OnlinePaymentRequestFilters(),
          Expanded(
            child: Container(
              decoration: lightGreyBgStyle(),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._response.map((e) => 
                      ColorInfoCard(
                        name: e['name'],
                        url: e['url'],
                        reason: e['reason'],
                        cost: e['cost'],
                        paidMoney: e['paidMoney'],
                        status: e['status'],
                        createdDate: DateTime.parse(e['createdDate']),
                        path: OnlinePaymentRequestDetailPage(onlineId: e['id']),
                      )                    
                    ),
                    // ColorInfoCard(path: OnlinePaymentRequestDetailPage()),
                  ],
                )
              )
            )

          )
        ],
      ),
      floatingActionButton: FloatingBtn(
        text: '부탁하기',
        icon: Icon(Icons.face),
        path: MakeOnlinePaymentRequestFirstPage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}