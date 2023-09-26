import 'package:flutter/material.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/tab_request_money.dart';
import 'package:keeping/widgets/header.dart';
import 'package:flutter/scheduler.dart';

class ChildRequestMoneyPage extends StatefulWidget {
  const ChildRequestMoneyPage({super.key});

  @override
  State<ChildRequestMoneyPage> createState() => _ChildRequestMoneyPageState();
}

class _ChildRequestMoneyPageState extends State<ChildRequestMoneyPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기'),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            requestPocketMoneyBox(),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xFFFFD600).withOpacity(0.2),
                backgroundBlendMode: BlendMode.srcATop,
                border: Border.all(
                  color: const Color(0xFFFFD600),
                  width: 2.0,
                ),
              ),
              tabs: <Widget>[
                Tab(
                  height: 110,
                  child: TabRequestMoney(name: '전체'),
                ),
                Tab(
                  height: 110,
                  child: TabRequestMoney(name: '대기중'),
                ),
                Tab(
                  height: 110,
                  child: TabRequestMoney(name: '승인'),
                ),
                Tab(
                  height: 110,
                  child: TabRequestMoney(name: '거부'),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      totalRequestPockeyMoney(),
                      waitingRequestPockeyMoney(),
                      acceptRequestPockeyMoney(),
                      denyRequestPockeyMoney(),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget requestPocketMoneyBox() {
    return Container(
      width: 300,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '용돈을 요청하시겠어요?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                backgroundColor: Color(0xFF8320E7),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '남은 횟수 : 10번',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                backgroundColor: Color(0xFF8320E7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // "전체" 탭에 대한 컨텐츠를 생성하는 함수
  Widget totalRequestPockeyMoney() {
    return Center(
      child: Text(
        '전체 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "대기중" 탭에 대한 컨텐츠를 생성하는 함수
  Widget waitingRequestPockeyMoney() {
    return Center(
      child: Text(
        '대기 중인 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "승인" 탭에 대한 컨텐츠를 생성하는 함수
  Widget acceptRequestPockeyMoney() {
    return Center(
      child: Text(
        '승인된 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "거부" 탭에 대한 컨텐츠를 생성하는 함수
  Widget denyRequestPockeyMoney() {
    return Center(
      child: Text(
        '거부된 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
