import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/gradient_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
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

  bool account = false;

  makeAccount() {
    setState(() {
      account = !account;
    });
  }

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: bgStyle(),
          child: SizedBox(
            width: 350,
            child: Column(
              children: [
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
                SizedBox(
                  height: 100,
                ),
                FutureBuilder(
                  future: getAccountInfo(
                      accessToken: _accessToken,
                      memberKey: _memberKey,
                      targetKey: _targetKey ?? _memberKey),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      if (response['resultStatus']['resultCode'] == '404') {
                        return MakeAccountBtn();
                      } else {
                        Provider.of<AccountInfoProvider>(context, listen: false)
                            .setAccountInfo(response['resultBody']);
                        return AccountInfo(
                          balance: response['resultBody']['balance'],
                        );
                      }
                    } else {
                      return Text('로딩중');
                    }
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientBtn(
                        path: PiggyPage(),
                        text: '저금통',
                        beginColor: Color(0xFF9271C8),
                        endColor: Color(0xFF6E2FD5),
                      ),
                      GradientBtn(
                        path: OnlinePaymentRequestPage(),
                        text: '온라인 결제\n부탁하기',
                        beginColor: Color(0xFFFF7595),
                        endColor: Color(0xFFFA3B68),
                        fontSize: 26,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientBtn(
                        path: MissionPage(),
                        text: '미션',
                        beginColor: Color(0xFF07B399),
                        endColor: Color(0xFF068572),
                      ),
                      GradientBtn(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ParentMainPage()));
                  },
                  child: Text('부모 계정 전환'),
                ),
                ElevatedButton(
                  onPressed: () {
                    makeAccount();
                  },
                  child: Text('계좌 유무'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChildRequestMoneyPage()));
                  },
                  child: Text('용돈 조르기'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
