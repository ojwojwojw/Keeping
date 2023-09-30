import 'package:flutter/material.dart';
import 'package:keeping/screens/request_pocket_money_page/request_pocket_money_second_page.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_box.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_filter.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_nav.dart';

class ChildRequestMoneyPage extends StatefulWidget {
  const ChildRequestMoneyPage({super.key});

  @override
  State<ChildRequestMoneyPage> createState() => _ChildRequestMoneyPageState();
}

class _ChildRequestMoneyPageState extends State<ChildRequestMoneyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기 모아보기'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestPocketMoneySecondPage()),
                );
              },
              child: requestPocketMoneyBox(),
            ),
            RequestMoneyFilters(),
            Text('용돈 조르기 내역이 없습니다.')
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
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
