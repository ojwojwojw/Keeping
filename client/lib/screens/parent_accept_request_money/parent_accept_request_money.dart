import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/parent_accept_request_money/parent_request_money_detail_page.dart';
import 'package:keeping/screens/request_pocket_money_page/request_pocket_money_second_page.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_box.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_filter.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/request_info_card.dart';
import 'package:provider/provider.dart';

class ParentRequestMoneyPage extends StatefulWidget {
  const ParentRequestMoneyPage({super.key});
  @override
  State<ParentRequestMoneyPage> createState() => _ParentRequestMoneyPageState();
}

class _ParentRequestMoneyPageState extends State<ParentRequestMoneyPage> {
  List<Map<String, dynamic>> _result = []; // 데이터를 저장할 변수

  int selectedBtnIdx = 0;
  // String? _childKey;
  // String? _myKey;
  // String? _accessToken;
  late Future<List<Map<String, dynamic>>> _dataFuture;
  bool _isParent = true;
  String? _childName;

  @override
  void initState() {
    super.initState();
    _dataFuture = renderTotalRequestMoney(context, selectedBtnIdx);
    _isParent = context.read<UserInfoProvider>().parent;
  }

  final DateFormat dateFormat = DateFormat('MM월 dd일');

  Future<List<Map<String, dynamic>>> renderTotalRequestMoney(
      BuildContext context, selectedBtnIdx) async {
    String _myKey = context.read<UserInfoProvider>().memberKey;
    String? _childKey = context.read<ChildInfoProvider>().memberKey;
    String _accessToken = context.read<UserInfoProvider>().accessToken;
    String? _childName = context.read<ChildInfoProvider>().name;

    var _url = '';
    if (selectedBtnIdx == 0) {
      _url = '/bank-service/api/$_myKey/allowance/$_childKey';
    } else if (selectedBtnIdx == 1) {
      _url = '/bank-service/api/$_myKey/allowance/$_childKey/WAIT';
    } else if (selectedBtnIdx == 2) {
      _url = '/bank-service/api/$_myKey/allowance/$_childKey/APPROVE';
    } else {
      _url = '/bank-service/api/$_myKey/allowance/$_childKey/REJECT';
    }
    print(_url);
    final response = await dioGet(
      accessToken: _accessToken,
      url: _url,
    );
    print(response);
    if (response != null) {
      final dynamic resultBody = response['resultBody'];
      if (resultBody != null) {
        final List<dynamic> requestResponseList = resultBody as List<dynamic>;
        handleResult(requestResponseList);
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
    totalRequestPockeyMoney(_result);
  }

  renderRequestCount() async {
    String memberKey =
        Provider.of<UserInfoProvider>(context, listen: false).memberKey;
    String? childKey =
        Provider.of<ChildInfoProvider>(context, listen: false).memberKey;
    String accessToken =
        Provider.of<UserInfoProvider>(context, listen: false).accessToken;

    var response = await dioGet(
      url: '/bank-service/api/$memberKey/allowance/$childKey/count',
      accessToken: accessToken,
    );
    if (response['resultStatus']['successCode'] == 0) {
      return response['resultBody'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기 모아보기'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: renderRequestCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return emptyBox();
                  } else if (snapshot.hasError) {
                    return Text('에러 발생: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    var responseData = snapshot.data;
                    // responseData를 이용하여 필요한 UI 작업 수행
                    return InkWell(
                      child: requestPocketMoneyBox(responseData, _isParent,
                          childName: _childName),
                    );
                  } else {
                    return Text('용돈 조르기 내역이 없습니다.');
                  }
                }),
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
      bottomSheet: BottomNav(),
    );
  }

  void _updateData() {
    setState(() {
      _dataFuture = renderTotalRequestMoney(context, selectedBtnIdx);
    });
  }

  // 용돈 조회 필드
  Widget totalRequestPockeyMoney(List<Map<String, dynamic>> requests) {
    if (requests.isEmpty) {
      return Column(
        children: [
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
        ],
      );
    }

    return Container(
      decoration: lightGreyBgStyle(),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: requests.map((req) {
            print(req);
            final DateTime createdDate = DateTime.parse(req['createdDate']);
            final String status = req['approve'];
            final int money = req['money'];

            return RequestInfoCard(
              money: money,
              status: status,
              createdDate: createdDate,
              path: ParentRequestMoneyDetailPage(data: req), // req 데이터 전달
            );
          }).toList(),
        ),
      ),
    );
  }
}
