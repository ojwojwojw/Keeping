import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/online_payment_request/utils/online_payment_request_future_methods.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:keeping/widgets/color_info_detail_card.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

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
  bool? _parent;
  String? _accessToken;
  String? _memberKey;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '부탁 내용 확인하기',
      ),
      body: FutureBuilder(
        future: getOnlinePaymentRequestDetail(
          accessToken: _accessToken, 
          memberKey: _memberKey, 
          targetKey: _parent != null && _parent! ? null : _memberKey, 
          onlineId: widget.onlineId
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var response = snapshot.data;
            if (response['resultBody'] != null && response['resultBody'].isEmpty) {
              return Text('부탁내용이 없습니다.');
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorInfoDetailCard(
                    name: response['resultBody']['productName'],
                    url: response['resultBody']['url'],
                    reason: response['resultBody']['content'],
                    cost: response['resultBody']['totalMoney'],
                    paidMoney: response['resultBody']['childMoney'],
                    status: response['resultBody']['approve'],
                    createdDate: DateTime.parse(response['resultBody']['createdDate']),
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
            );
          } else {
            return Text('로딩중');
          }

        }
      ),
      bottomNavigationBar: BottomBtn(
        text: '확인',
        isDisabled: false,
      ),
    );
  }
}