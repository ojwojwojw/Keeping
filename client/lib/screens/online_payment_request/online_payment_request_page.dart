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

// final _tempData = {
//   "online": [
//     {
//       "id": 1,
//       "name": "가방",
//       "url": "http://localhost:8080",
//       "reason": "이 가방이 너무 예뻐요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "YET",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//     {
//       "id": 2,
//       "name": "신발",
//       "url": "http://localhost:8080",
//       "reason": "이 신발이 너무 멋져요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "ACCEPT",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//     {
//       "id": 3,
//       "name": "모자",
//       "url": "http://localhost:8080",
//       "reason": "이 모자가 너무 짱이에요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "REJECT",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//     {
//       "id": 4,
//       "name": "가방",
//       "url": "http://localhost:8080",
//       "reason": "이 가방이 너무 예뻐요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "YET",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//     {
//       "id": 5,
//       "name": "신발",
//       "url": "http://localhost:8080",
//       "reason": "이 신발이 너무 멋져요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "ACCEPT",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//     {
//       "id": 6,
//       "name": "모자",
//       "url": "http://localhost:8080",
//       "reason": "이 모자가 너무 짱이에요",
//       "cost": 5000,
//       "paidMoney": 2000,
//       "status": "REJECT",
//       "createdDate": "2020-10-10T14:58:04+09:00"
//     },
//   ]
// };

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
        text: '온라인 결제 부탁하기',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: Column(
        children: [
          OnlinePaymentRequestInfo(),
          OnlinePaymentRequestFilters(),
          FutureBuilder(
            future: _parent != null && _parent! ? 
              getOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _childKey)
              : getOnlinePaymentRequestList(accessToken: _accessToken, memberKey: _memberKey, targetKey: _memberKey),
            builder: (context, snapshot) {
              print('스냅샷스냅샷스냅샷 ${snapshot.toString()}');
              if (snapshot.hasData) {
                var response = snapshot.data;
                if (response['resultBody'].isEmpty) {
                  return Text('거래내역이 없습니다.');
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