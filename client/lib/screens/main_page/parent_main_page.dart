import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/main_page/util/main_future_methods.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/gradient_btn.dart';
import 'package:keeping/screens/main_page/widgets/greeting.dart';
import 'package:keeping/screens/main_page/widgets/main_service_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/bottom_modal.dart';
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
  String _name = '';
  String? _childKey;
  String? _childName;
  String? _childProfileImage;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _fcmToken = context.read<UserInfoProvider>().fcmToken;
    _name = context.read<UserInfoProvider>().name;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    _childName = context.read<ChildInfoProvider>().name;
    _childProfileImage = context.read<ChildInfoProvider>().profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: lightGreyBgStyle(),
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
            child: Column(
              children: [
                // ParentGreeting(name: _name, childName: _childName ?? '',),
                FutureBuilder(
                  future: getChildrenList(
                    accessToken: _accessToken, 
                    memberKey: _memberKey, 
                    fcmToken: _fcmToken
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print('부모 메인 페이지 ${snapshot.data}');
                      var response = snapshot.data;
                      if (response['resultBody']['childrenList'].isEmpty) {
                        return Column(
                          children: [
                            _changeChildBtn(
                              context: context, childrenList: [], isDisabled: true
                            ),
                            ParentGreeting(name: _name, childName: null),
                            ChildContent(childInfo: null),
                          ],
                        );
                      } else if (_childKey == null && _childName == null) {
                        return Column(
                          children: [
                            _changeChildBtn(
                              context: context, childrenList: response['resultBody']['childrenList']
                            ),
                            ParentGreeting(name: _name, childName: response['resultBody']['childrenList'].first['name']),
                            ChildContent(childInfo: response['resultBody']['childrenList'].first),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _changeChildBtn(
                            context: context, childrenList: response['resultBody']['childrenList']
                          ),
                          ParentGreeting(name: _name, childName: _childName!,),
                          ChildContent(childInfo: {
                            'memberKey': _childKey,
                            'name': _childName,
                            'profileImage': _childProfileImage,
                          }),
                        ],
                      );
                    } else {
                      return const Text('로딩중');
                    }
                  },
                ),
              ],
            ),
          )
        ),
      ),
      bottomNavigationBar: BottomNav(home: true,),
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
    Provider.of<ChildInfoProvider>(context, listen: false).initChildInfo();
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
                Provider.of<ChildInfoProvider>(context, listen: false).initChildAccount();
                var response = snapshot.data;
                if (response['resultStatus']['resultCode'] == '404') {
                  return noAccountForParent(context);
                } else if (response['resultStatus']['resultCode'] == '503') {
                  return AccountInfo(balance: 0);
                } else {
                  Provider.of<ChildInfoProvider>(context).setChildAccount(response['resultBody']);
                  return AccountInfo(
                    balance: response['resultBody']['balance'],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return disabledAccount();
              } else {
                return disabledAccountForParent(context);
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainServiceBtn(
                hasAccount: context.read<ChildInfoProvider>().accountNumber.isNotEmpty ? true : false,
                path: MissionPage(),
                name: '미션',
                text: '자녀 소비습관 쑥쑥!',
                emoji: '💪',
                parent: true,
              ),
              SizedBox(width: 12,),
              MainServiceBtn(
                hasAccount: context.read<ChildInfoProvider>().accountNumber.isNotEmpty ? true : false,
                path: OnlinePaymentRequestPage(),
                name: '결제 부탁하기',
                text: '자녀가 부탁한\n결제 목록이에요.',
                emoji: '🙇‍♀️',
                parent: true,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainServiceBtn(
                hasAccount: context.read<ChildInfoProvider>().accountNumber.isNotEmpty ? true : false,
                path: QuestionPage(),
                name: '질문',
                text: '질문에 답하고\n자녀와 소통해요',
                emoji: '📬',
                parent: true,
              ),
              SizedBox(width: 12,),
              MainServiceBtn(
                hasAccount: context.read<ChildInfoProvider>().accountNumber.isNotEmpty ? true : false,
                path: PiggyPage(),
                name: '저금통',
                text: '자녀의 위시리스트는?',
                emoji: '🐷',
                parent: true,
              ),
            ],
          ),
        ],
      )
    );
  }
}

// 자녀 전환 버튼
Widget _changeChildBtn({required BuildContext context, required List<dynamic> childrenList, bool isDisabled = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      InkWell(
        onTap: () {
          if (!isDisabled) bottomModal(context: context, title: '자녀 계정 전환', content: _changeChildrenList(context, childrenList), button: Container());
        },
        child: Container(
          width: 66,
          height: 36,
          decoration: roundedBoxWithShadowStyle(shadow: false, border: true, borderColor: Color(0xFFB9B9B9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person_outline, color: Color(0xFFB9B9B9),),
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFB9B9B9),)
            ],
          ),
        ),
      ),
    ],
  );
}

// 하단 모달에 들어갈 자녀 리스트
Widget _changeChildrenList(BuildContext context, List<dynamic> childrenList) {
  return SizedBox(
    height: 150,
    child: SingleChildScrollView(
      child: Column(
        children: [
          ...childrenList.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  Provider.of<ChildInfoProvider>(context, listen: false).initChildInfo();
                  Provider.of<ChildInfoProvider>(context, listen: false).setChildInfo(e);
                  noEffectReplacementTransition(context, ParentMainPage());
                },
                child: Container(
                  decoration: roundedBoxWithShadowStyle(shadow: false, border: true, borderColor: Color(0xFFB9B9B9), borderWidth: 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: roundedAssetImg(imgPath: 'assets/image/temp_image.jpg'),
                        ),
                        Text(e['name'], style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    ),
  );
}