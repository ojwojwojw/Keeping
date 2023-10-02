import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/parent_accept_request_money/parent_accept_request_money.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/bottom_double_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/request_info_detail_card.dart';
import 'package:provider/provider.dart';

class ParentRequestMoneyDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ParentRequestMoneyDetailPage({Key? key, required this.data})
      : super(key: key);

  @override
  State<ParentRequestMoneyDetailPage> createState() =>
      _ParentRequestMoneyDetailPageState();
}

class _ParentRequestMoneyDetailPageState
    extends State<ParentRequestMoneyDetailPage> {
  late Map<String, dynamic> data;
  late String _name;
  late String _memberKey;
  late String? _childKey;
  String? _accessToken;

  get id => null;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _name = context.read<UserInfoProvider>().name;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    data = widget.data; // 이전 페이지에서 전달된 데이터를 저장
    print('data : $data');
  }

  @override
  Widget build(BuildContext context) {
    final content = data['content'] ?? '';
    final money = data['money'] ?? 0;
    final approve = data['approve'] ?? '';
    final id = data['id'] ?? 0;
    final createdDate = data['createdDate'] is String
        ? DateTime.tryParse(data['createdDate'] ?? '') ?? DateTime.now()
        : DateTime.now();

    return Scaffold(
      appBar: MyHeader(text: '조르기 모아보기'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RequestInfoDetailCard(
              name: _name,
              money: money,
              reason: content,
              status: approve,
              createdDate: createdDate,
            )
          ],
        ),
      ),
      bottomSheet: BottomDoubleBtn(
        firstText: '거부하기',
        firstAction: () {
          determineRequestMoney('REJECT', id);
        },
        secondText: '승인하기',
        secondAction: () {
          determineRequestMoney('APPROVE', id);
        },
        isDisabled: false,
      ),
    );
  }

  determineRequestMoney(String selectState, int requestId) async {
    data = {
      "allowanceId": requestId,
      "childKey": _childKey,
      "approve": selectState,
    };
    print(data);
    String url =
        'http://j9c207.p.ssafy.io:8000/bank-service/api/$_memberKey/allowance/approve';
    final response = await dioPost(
      accessToken: _accessToken,
      url: url,
      data: data,
    );
    if (response['resultStatus']['successCode'] == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ParentRequestMoneyPage(),
        ),
      );
    }
    print(response);
    print('승인할 거예요');
  }
}
