import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/request_pocket_money_page/request_pocket_money_second_page.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_box.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_filter.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class ChildRequestMoneyPage extends StatefulWidget {
  const ChildRequestMoneyPage({super.key});
  @override
  State<ChildRequestMoneyPage> createState() => _ChildRequestMoneyPageState();
}

class _ChildRequestMoneyPageState extends State<ChildRequestMoneyPage> {
  List<Map<String, dynamic>> _result = []; // 데이터를 저장할 변수
  int selectedBtnIdx = 0;
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = renderTotalRequestMoney(context, selectedBtnIdx);
  }

  final DateFormat dateFormat = DateFormat('MM월 dd일');

  Future<List<Map<String, dynamic>>> renderTotalRequestMoney(
      BuildContext context, selectedBtnIdx) async {
    String memberKey =
        Provider.of<UserInfoProvider>(context, listen: false).memberKey;
    String accessToken =
        Provider.of<UserInfoProvider>(context, listen: false).accessToken;
    var _url = '';
    if (selectedBtnIdx == 0) {
      _url =
          'http://j9c207.p.ssafy.io:8000/bank-service/api/$memberKey/allowance/$memberKey';
    } else if (selectedBtnIdx == 1) {
      _url =
          'http://j9c207.p.ssafy.io:8000/bank-service/api/$memberKey/allowance/$memberKey/WAIT';
    } else if (selectedBtnIdx == 2) {
      _url =
          'http://j9c207.p.ssafy.io:8000/bank-service/api/$memberKey/allowance/$memberKey/APPROVE';
    } else {
      _url =
          'http://j9c207.p.ssafy.io:8000/bank-service/api/$memberKey/allowance/$memberKey/REJECT';
    }
    final response = await dioGet(
      accessToken: accessToken,
      url: _url,
    );
    handleResult(response['resultBody']);
    if (response != null) {
      final dynamic resultBody = response['resultBody'];
      if (resultBody != null) {
        final List<dynamic> requestResponseList = resultBody as List<dynamic>;
        handleResult(requestResponseList);
        print('뭘 렌더링할래? $requestResponseList');
        return requestResponseList.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  handleResult(res) {
    if (res != null) {
      _result = List<Map<String, dynamic>>.from(res);
    }
    print(_result);
    print('변경 중~~');
    totalRequestPockeyMoney(_result);
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
            RequestMoneyFilters(
              onPressed: (int idx) {
                setState(() {
                  selectedBtnIdx = idx;
                });
                _updateData();
              },
            ),
            FutureBuilder(
              future: renderTotalRequestMoney(context, selectedBtnIdx),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200, // 원하는 높이로 조정하세요
                    child: Container(
                      child: Center(
                        child: Text(
                          '잠시 기다려주세요...',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 77, 19, 135)),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('에러 발생: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // 용돈 조르기 내역을 표시하는 위젯을 반환
                  return totalRequestPockeyMoney(_result);
                } else {
                  return Text('용돈 조르기 내역이 없습니다.');
                }
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  void _updateData() {
    setState(() {
      _dataFuture = renderTotalRequestMoney(context, selectedBtnIdx);
    });
  }

  // 용돈 조회 필드
  Widget totalRequestPockeyMoney(List<Map<String, dynamic>> requests) {
    print('req : $requests');
    if (requests.isEmpty) {
      return Column(children: [
        SizedBox(
          height: 50,
        ),
        Text(
          '내역이 없습니다.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        )
      ]);
    }
    return Column(
      children: requests.map((req) {
        final DateTime date = DateTime.parse(req['createdDate']);
        final String formattedDate = dateFormat.format(date);
        Color statusBackgroundColor = Colors.white;
        Color statusTextColor = const Color.fromARGB(255, 0, 0, 0);
        String statusText = '';

        if (req['approve'] == 'WAIT') {
          statusText = '조르기 대기 중';
          statusBackgroundColor = Color.fromARGB(255, 187, 187, 187);
          statusTextColor = Color.fromARGB(255, 60, 60, 60);
        } else if (req['approve'] == 'REJECT') {
          statusText = '조르기 거부';
          statusBackgroundColor = Colors.red;
          statusTextColor = Colors.red;
        } else {
          statusText = '조르기 승인';
          statusBackgroundColor = Colors.green;
          statusTextColor = Colors.green;
        }

        return Container(
          width: 330,
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$formattedDate'),
              SizedBox(height: 10),
              Container(
                width: 330,
                height: 80,
                decoration: roundedBoxWithShadowStyle(),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: Container(
                        color: statusBackgroundColor,
                        width: 330,
                        height: 30,
                        child: Center(
                          child: Text(
                            '$statusText',
                            style: TextStyle(
                              color: statusTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '용돈 ${req['money']}원을 졸랐어요!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
