import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/reject_online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/utils/online_payment_request_future_methods.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/bottom_double_btn.dart';
import 'package:keeping/widgets/color_info_detail_card.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class OnlinePaymentRequestDetailPage extends StatefulWidget {
  final int onlineId;
  final String? status;

  OnlinePaymentRequestDetailPage({
    super.key,
    required this.onlineId,
    required this.status,
  });

  @override
  State<OnlinePaymentRequestDetailPage> createState() => _OnlinePaymentRequestDetailPageState();
}

class _OnlinePaymentRequestDetailPageState extends State<OnlinePaymentRequestDetailPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _childKey;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _childKey = context.read<ChildInfoProvider>().memberKey;
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
          targetKey: _parent != null && _parent! ? _childKey : _memberKey, 
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
                ],
              ),
            );
          } else {
            return Text('로딩중');
          }

        }
      ),
      bottomSheet: _parent != null && _parent! && widget.status == 'WAIT' ? 
        BottomDoubleBtn(
          firstText: '거절하기', 
          firstAction: RejectOnlinePaymentRequestPage(onlineId: widget.onlineId),
          secondText: '승인하기',
          secondAction: () async {
            var response = await approveOnlinePaymentRequest(
              accessToken: _accessToken, 
              memberKey: _memberKey, 
              onlineId: widget.onlineId, 
              childKey: _childKey
            );
            print('온라인 결제 승인 결과 $response');
            if (response == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CompletedPage(
                text: '부탁이\n승인되었습니다.',
                button: ConfirmBtn(
                  action: OnlinePaymentRequestPage(),
                ),
              )));
            } else {
              roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
            }
          },
          isDisabled: false,
        ) :
        BottomBtn(text: '확인', isDisabled: false),
    );
  }
}