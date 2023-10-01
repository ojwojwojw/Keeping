import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/main_page/util/main_future_methods.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/gradient_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/main_page/widgets/tab_profile.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class ParentMainPage extends StatefulWidget {
  ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> with TickerProviderStateMixin {
  String? _accessToken;
  String? _memberKey;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _fcmToken = context.read<UserInfoProvider>().fcmToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: bgStyle(),
        child: FutureBuilder(
          future: getChildrenList(
            accessToken: _accessToken,
            memberKey: _memberKey,
            fcmToken: _fcmToken,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('부모 메인 페이지 ${snapshot.data}');
              var response = snapshot.data;
              if (response['resultBody']['childrenList'].isEmpty) {
                return Text('연결된 자녀가 없습니다.');
              }
              final TabController tabController = TabController(
                length: response['resultBody']['childrenList'].length, 
                vsync: this
              );
              return Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFFFFD600).withOpacity(0.2),
                      backgroundBlendMode: BlendMode.srcATop,
                      border: Border.all(
                        color: const Color(0xFFFFD600), // 테두리 색상
                        width: 2.0, // 테두리 두께
                      ),
                    ),
                    tabs: <Widget>[
                      ...response['resultBody']['childrenList'].map((e) {
                        return Tab(
                          height: 110,
                          child: TabProfile(
                            imgPath: 'assets/image/temp_image.jpg',
                            name: e['name'],
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ...response['resultBody']['childrenList'].map((e) => 
                          ChildContent(
                            childInfo: e,
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              );
            } else {
              return const Text('로딩중');
            }
          },
        )
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class ChildContent extends StatefulWidget {
  final Map<String, dynamic>? childInfo;

  ChildContent({
    super.key,
    required this.childInfo,
  });

  @override
  State<ChildContent> createState() => _ChildContentState();
}

class _ChildContentState extends State<ChildContent> {
  String? _accessToken;
  String? _memberKey;
  bool? _hasChildAccount;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    Provider.of<ChildInfoProvider>(context, listen: false).setChildInfo(widget.childInfo);
    _hasChildAccount = context.read<ChildInfoProvider>().accountNumber.isNotEmpty ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: getAccountInfo(
              accessToken: _accessToken,
              memberKey: _memberKey,
              targetKey: widget.childInfo != null ? widget.childInfo!['memberKey'] : null
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var response = snapshot.data;
                if (response['resultStatus']['resultCode'] == '404') {
                  return MakeAccountBtn();
                } else {
                  Provider.of<ChildInfoProvider>(context, listen: false).setChildAccount(response['resultBody']);
                  return AccountInfo(
                    balance: response['resultBody']['balance'],
                  );
                }
              } else {
                return Text('로딩중');
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BeforeUserLinkPage(),
                ),
              );
            },
            child: const Text('유저 연결 페이지'),
          ),
          SizedBox(height: 10),
          SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientBtn(
                    hasAccount: _hasChildAccount,
                    path: PiggyPage(),
                    text: '저금통',
                    beginColor: Color(0xFF9271C8),
                    endColor: Color(0xFF6E2FD5),
                  ),
                  GradientBtn(
                    hasAccount: _hasChildAccount,
                    path: OnlinePaymentRequestPage(),
                    text: '온라인 결제\n부탁 목록',
                    beginColor: Color(0xFFFF7595),
                    endColor: Color(0xFFFA3B68),
                    fontSize: 26,
                  ),
                ],
              )),
          SizedBox(height: 8),
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientBtn(
                  hasAccount: _hasChildAccount,
                  path: MissionPage(),
                  text: '미션',
                  beginColor: Color(0xFF07B399),
                  endColor: Color(0xFF068572),
                ),
                GradientBtn(
                  hasAccount: _hasChildAccount,
                  path: QuestionPage(),
                  text: '질문',
                  beginColor: Color(0xFFFFCE72),
                  endColor: Color(0xFFFFBC3F),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ));
  }
}
