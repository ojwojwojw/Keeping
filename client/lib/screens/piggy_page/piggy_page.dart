import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/piggy_page/make_piggy_page.dart';
import 'package:keeping/screens/piggy_page/piggy_detail_page.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info_card.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

// final List<Map<String, dynamic>> tempData = [
//   {
//     "id": 3,
//     "childKey": "0986724",
//     "accountNumber": "172-123456-707-27",
//     "piggyAccountNumber": "1",
//     "content": "아디다스 삼바",
//     "goalMoney": 140000,
//     "balance": 70000,
//     "savedImage": '[Base64 이미지]',
//     "completed": "INCOMPLETED"
//   },
//   {
//     "id": 7,
//     "childKey": "0986724",
//     "accountNumber": "172-234567-707-27",
//     "piggyAccountNumber": "2",
//     "content": "후드티 갖고 싶다",
//     "goalMoney": 140000,
//     "balance": 70000,
//     "savedImage": '[Base64 이미지]',
//     "completed": "INCOMPLETED"
//   }
// ];

class PiggyPage extends StatefulWidget {
  PiggyPage({super.key});

  @override
  State<PiggyPage> createState() => _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> {
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
        text: '\u{1F437} 저금통',
        bgColor: const Color(0xFF8320E7),
        elementColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getPiggyList(
          accessToken: _accessToken, 
          memberKey: _memberKey,
          targetKey: _parent != null && _parent == true ? null : _memberKey,
        ),
        builder: (context, snapshot) {
          print('저금통 페이지 ${snapshot.toString()}');
          if (snapshot.hasData) {
            var response = snapshot.data;
            if (response['resultBody'].isEmpty) {
              return Text('거래내역이 없습니다.');
            }
            return Column(
              children: [
                PiggyInfo(),
                // PiggyFilters(),
                Expanded(
                  child: Container(
                    decoration: lightGreyBgStyle(),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ...response['resultBody'].map((e) => InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PiggyDetailPage(piggyId: e['id'])));
                            },
                            child: PiggyInfoCard(
                              content: e['content'],
                              balance: e['balance'],
                              goalMoney: e['goalMoney'],
                              img: Base64Decoder().convert(e['savedImage']),
                            )
                          )).toList()
                        ]
                      ),
                    ),
                  )
                )
              ],
            );
          } else {
            return const Text('로딩중');
          }
        }
      ),
      floatingActionButton: _parent != null && _parent! == true ? null : FloatingBtn(
        text: '만들기',
        icon: Icon(Icons.savings_rounded),
        path: MakePiggyPage(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
