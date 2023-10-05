import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/piggy_page/piggy_saving_page.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_detail_info.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_money_record.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/loading.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class PiggyDetailPage extends StatefulWidget {
  final Map<String, dynamic> piggyDetailInfo;

  PiggyDetailPage({
    super.key,
    required this.piggyDetailInfo,
  });

  @override
  State<PiggyDetailPage> createState() => _PiggyDetailPageState();
}

class _PiggyDetailPageState extends State<PiggyDetailPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _childKey;

  void reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<PiggyDetailProvider>().initSelectedPiggyDetailInfo();
    context.read<PiggyDetailProvider>().setSelectedPiggyDetailInfo(widget.piggyDetailInfo);
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _childKey = context.read<ChildInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통',
        // bgColor: const Color(0xFF8320E7),
        // elementColor: Colors.white,
      ),
      body: Column(
        children: [
          PiggyDetailInfo(
            piggyId: widget.piggyDetailInfo['id'],
            content: widget.piggyDetailInfo['content'],
            balance: widget.piggyDetailInfo['balance'],
            goalMoney: widget.piggyDetailInfo['goalMoney'],
            img: widget.piggyDetailInfo['savedImage'],
            createdDate: DateTime.parse(widget.piggyDetailInfo['createdDate']),
            reload: reload
          ),
          FutureBuilder(
            future: getPiggyDetailList(
              accessToken: _accessToken,
              memberKey: _memberKey,
              piggyId: widget.piggyDetailInfo['id'],
              targetKey: _parent != null && _parent == true ? _childKey : _memberKey,
            ),
            builder: (context, snapshot) {
              print('저금통 상세 페이지 ${snapshot.toString()}');
              if (snapshot.hasData) {
                var response = snapshot.data;
                if (response['resultBody'] != null && response['resultBody'].isEmpty) {
                  return empty(text: '저금 내역이 없습니다.');
                }
                return Expanded(
                  child: Container(
                    decoration: lightGreyBgStyle(),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                        ...response['resultBody'].map((e) => PiggyMoneyRecord(
                          date: DateTime.parse(e['createdDate']),
                          name: '${int.parse(e['name'])}회차',
                          money: e['money'],
                          balance: e['balance'],
                        )).toList(),
                      ]),
                    )
                  )
                );
              } else {
                return loading();
              }
            },
          ),
        ],
      ),
      floatingActionButton: _parent != null && !_parent! ? FloatingBtn(
        text: '저금하기',
        icon: Icons.savings_rounded,
        path: PiggySavingPage(piggyDetailInfo: widget.piggyDetailInfo),
      ) : null,
      bottomNavigationBar: BottomNav(),
    );
  }
}
