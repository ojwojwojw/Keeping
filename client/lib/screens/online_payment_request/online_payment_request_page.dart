import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/online_payment_request/make_online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_detail_page.dart';
import 'package:keeping/screens/online_payment_request/utils/online_payment_request_future_methods.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_filters.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_info.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/color_info_card.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class OnlinePaymentRequestPage extends StatefulWidget {
  OnlinePaymentRequestPage({
    super.key,
  });

  @override
  State<OnlinePaymentRequestPage> createState() => _OnlinePaymentRequestPageState();
}

class _OnlinePaymentRequestPageState extends State<OnlinePaymentRequestPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _childKey;
  Future<dynamic>? _future;

  void setFuture(String? status) {
    if (status == null) {
      setState(() {
        _future = getOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _parent != null && _parent! ? _childKey : _memberKey);
      });
    } else {
      setState(() {
        _future = getFilteredOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _parent != null && _parent! ? _childKey : _memberKey, status: status);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _future = getOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _parent != null && _parent! ? _childKey : _memberKey);
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
          OnlinePaymentRequestFilters(setFuture: setFuture),
          FutureBuilder(
            // future: getOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _parent != null && _parent! ? _childKey : _memberKey),
            future: _future,
            builder: (context, snapshot) {
              print('스냅샷스냅샷스냅샷 ${snapshot.toString()}');
              if (snapshot.hasData) {
                var response = snapshot.data;
                if (response['resultBody'].isEmpty) {
                  return Text('부탁내역이 없습니다.');
                }
                return Expanded(
                  child: Container(
                    decoration: lightGreyBgStyle(),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...response['resultBody'].map((e) => 
                            ColorInfoCard(
                              name: e['productName'],
                              url: e['url'],
                              reason: e['content'],
                              cost: e['totalMoney'],
                              paidMoney: e['childMoney'],
                              status: e['approve'],
                              createdDate: DateTime.parse(e['createdDate']),
                              path: OnlinePaymentRequestDetailPage(onlineId: e['id']),
                            )                    
                          ),
                        ],
                      )
                    )
                  )
                );
              } else {
                return Text('로딩중');
              }
            },
          ),
        ],
      ),
      floatingActionButton: _parent != null && _parent! ? null : FloatingBtn(
        text: '부탁하기',
        icon: Icon(Icons.face),
        path: MakeOnlinePaymentRequestFirstPage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}