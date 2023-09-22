import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/gradient_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/main_page/widgets/tab_profile.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/widgets/bottom_nav.dart';

class ParentMainPage extends StatefulWidget {
  ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> with TickerProviderStateMixin {
  bool account = false;
  late final TabController _tabController;

  makeAccount() {
    setState(() {
      account = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: bgStyle(),
        child: Column(
          children: [
            SizedBox(height: 50,),
            TabBar(
              controller: _tabController,
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
                // Tab(
                //   height: 110,
                //   child: TabProfile(
                //     imgPath: 'assets/image/temp_image.jpg',
                //     name: '나',
                //   ),
                // ),
                Tab(
                  height: 110,
                  child: TabProfile(
                    imgPath: 'assets/image/temp_image.jpg',
                    name: '김첫째',
                  ),
                ),
                Tab(
                  height: 110,
                  child: TabProfile(
                    imgPath: 'assets/image/temp_image.jpg',
                    name: '김둘째',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  // me(context, account, makeAccount),
                  myChild(context, account, makeAccount),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChildMainPage()));
                      },
                      child: Text('자식 계정 전환'),
                    )
                  ),
                ],
              ),
            ), 
          ]
        )
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

Widget myChild(BuildContext context, bool account, Function makeAccount) {
  return SizedBox(
    width: 350,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        account ? AccountInfo() : MakeAccountBtn(),
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
                text: '온라인 결제\n부탁 목록',
                beginColor: Color(0xFFFF7595),
                endColor: Color(0xFFFA3B68),
                fontSize: 26,
              ),
            ],
          )
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
        SizedBox(height: 20,),
      ],
    )
  );
}

// Widget me(BuildContext context, bool account, Function makeAccount) {
//   return SizedBox(
//     width: 350,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         account ? AccountInfo() : MakeAccountBtn(),
//       ],
//     )
//   );
// }