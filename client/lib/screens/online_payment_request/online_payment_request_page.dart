import 'package:flutter/material.dart';
import 'package:keeping/screens/online_payment_request/make_online_payment_request_first_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_detail_page.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_filters.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_info.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/color_info_card.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';

class OnlinePaymentRequestPage extends StatefulWidget {
  OnlinePaymentRequestPage({
    super.key,
  });

  @override
  State<OnlinePaymentRequestPage> createState() => _OnlinePaymentRequestPageState();
}

class _OnlinePaymentRequestPageState extends State<OnlinePaymentRequestPage> {
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
                    ColorInfoCard(path: OnlinePaymentRequestDetailPage()),
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