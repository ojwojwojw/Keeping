import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/widgets/account_info.dart';
import 'package:keeping/screens/main_page/widgets/gradient_btn.dart';
import 'package:keeping/screens/main_page/widgets/make_account_btn.dart';
import 'package:keeping/screens/make_account_page/widgets/styles.dart';
import 'package:keeping/screens/mission_page/mission_page.dart';
import 'package:keeping/screens/online_request_payment/online_request_payment.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/question_page/question_page.dart';
import 'package:keeping/widgets/bottom_nav.dart';

class ParentMainPage extends StatefulWidget {
  ParentMainPage({super.key});

  _ParentMainPageState createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> with TickerProviderStateMixin {
  bool account = false;
  late TabController _tabController;

  makeAccount() {
    setState(() {
      account = true;
    });
  }

  deleteAccount() {
    setState(() {
      account = false; 
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: bgStyle(),
        child: SizedBox(
          width: 350,
          child: Column(
            children: [
              SizedBox(height: 100,),
              TabBar(
                tabs: const [
                  Tab(text: '나',),
                  Tab(text: '김첫째',),
                  Tab(text: '김둘째',)
                ],
                indicator: BoxDecoration(
                  
                ),
                controller: _tabController,
              ),
              TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        account ? AccountInfo() : MakeAccountBtn(makeAccount: makeAccount),
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
                                path: OnlineRequestPayment(),
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChildMainPage()));
                          },
                          child: Text('자식 계정 전환'),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        account ? AccountInfo() : MakeAccountBtn(makeAccount: makeAccount),
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
                                path: OnlineRequestPayment(),
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
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        account ? AccountInfo() : MakeAccountBtn(makeAccount: makeAccount),
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
                                path: OnlineRequestPayment(),
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
                  )
                ],
              )
            ],
          )
        )
      ),
      bottomNavigationBar: BottomNav()
    );
  }
}