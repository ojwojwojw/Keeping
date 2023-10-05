import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/piggy_page/make_piggy_page.dart';
import 'package:keeping/screens/piggy_page/piggy_detail_page.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_info_card.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/empty.dart';
import 'package:keeping/widgets/floating_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({super.key});

  @override
  State<PiggyPage> createState() => _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _childKey;
  String? _accountNumber;
  String? _childAccountNumber;

  void reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    _accountNumber = context.read<AccountInfoProvider>().accountNumber;
    _childAccountNumber = context.read<ChildInfoProvider>().accountNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통',
        backPath: _parent != null && _parent! ? ParentMainPage() : ChildMainPage(),
        // bgColor: const Color(0xFF8320E7),
        // elementColor: Colors.white,
      ),
      body: Column(
        children: [
          PiggyInfo(parent: _parent, reload: reload),
          FutureBuilder(
            future: getPiggyList(
              accessToken: _accessToken, 
              memberKey: _memberKey,
              targetKey: _parent != null && _parent == true ? _childKey : _memberKey,
            ),
            builder: (context, snapshot) {
              print('저금통 페이지 ${snapshot.toString()}');
              if (snapshot.hasData) {
                var response = snapshot.data;
                if (response['resultBody'] != null && response['resultBody'].isEmpty) {
                  return empty(text: '개설된 저금통이 없습니다.');
                }
                return Expanded(
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
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => PiggyDetailPage(piggyDetailInfo: e))
                              );
                            },
                            child: PiggyInfoCard(
                              content: e['content'],
                              balance: e['balance'],
                              goalMoney: e['goalMoney'],
                              img: e['savedImage'],
                            )
                          )).toList()
                        ]
                      ),
                    ),
                  )
                );
              } else {
                // return const Text('');
                return Container();
              }
            }
          ),
        ],
      ),
      floatingActionButton: _parent != null && _parent! == true ? null : FloatingBtn(
        text: '만들기',
        icon: Icons.savings_rounded,
        path: _accountNumber != null && _accountNumber! != '' ? MakePiggyPage() : null,
        action: _accountNumber != null && _accountNumber! != '' ? null : () {
          roundedModal(context: context, title: '계좌 개설 후에 이용하실 수 있습니다.');
        }
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
