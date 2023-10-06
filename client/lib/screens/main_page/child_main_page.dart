import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/greeting.dart';
import 'package:keeping/screens/main_page/widgets/main_service_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class ChildMainPage extends StatefulWidget {
  ChildMainPage({super.key});

  @override
  State<ChildMainPage> createState() => _ChildMainPageState();
}

class _ChildMainPageState extends State<ChildMainPage> {
  String? _accessToken;
  String? _memberKey;
  String? _targetKey;
  String _name = '';
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _name = context.read<UserInfoProvider>().name;
    _profileImage = context.read<UserInfoProvider>().profileImage;
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
                ChildGreeting(name: _name, profileImage: _profileImage),
                FutureBuilder(
                  future: getAccountInfo(
                    accessToken: _accessToken,
                    memberKey: _memberKey,
                    targetKey: _targetKey ?? _memberKey
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      if (response['resultStatus']['resultCode'] == '404') {
                        return MakeAccountBtn();
                      } else if (response == false) {
                        return disabledAccount();
                      } else if (response['resultStatus']['resultCode'] == '503') {
                        return AccountInfo(balance: 0);
                      } else {
                        Provider.of<AccountInfoProvider>(context, listen: false).setAccountInfo(response['resultBody']);
                        return AccountInfo(
                          balance: response['resultBody']['balance'],
                        );
                      }
                    } else {
                      return disabledAccount();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainServiceBtn(
                      hasAccount: context.read<AccountInfoProvider>().accountNumber.isNotEmpty ? true : false,
                      path: MissionPage(),
                      name: '미션',
                      text: '부모님도 돕고\n용돈도 받고!',
                      service: 'mission',
                    ),
                    SizedBox(width: 12,),
                    MainServiceBtn(
                      hasAccount: context.read<AccountInfoProvider>().accountNumber.isNotEmpty ? true : false,
                      path: PiggyPage(),
                      name: '저금통',
                      text: '티끌 모아 태산!',
                      service: 'piggy',
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainServiceBtn(
                      hasAccount: context.read<AccountInfoProvider>().accountNumber.isNotEmpty ? true : false,
                      path: QuestionPage(),
                      name: '질문',
                      text: '질문에 답하고\n부모님과 소통해요',
                      service: 'question',
                    ),
                    SizedBox(width: 12,),
                    MainServiceBtn(
                      hasAccount: context.read<AccountInfoProvider>().accountNumber.isNotEmpty ? true : false,
                      path: OnlinePaymentRequestPage(),
                      name: '결제 부탁하기',
                      text: '결제가 힘들면\n부모님에게 부탁해요',
                      service: 'onlineRequest',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(home: true,),
    );
  }
}
