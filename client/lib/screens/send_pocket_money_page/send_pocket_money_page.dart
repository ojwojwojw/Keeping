import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/number_keyboard.dart'; // 새로 추가된 키보드 위젯 임포트
import 'package:provider/provider.dart';

class SendPocketMoneyPage extends StatefulWidget {
  const SendPocketMoneyPage({Key? key});

  @override
  State<SendPocketMoneyPage> createState() => _SendPocketMoneyPageState();
}

class _SendPocketMoneyPageState extends State<SendPocketMoneyPage> {
  String? _accessToken;
  String? _memberKey;
  String _name = '';
  String? _childKey;
  String? _childName;
  int? _balance; // 잔액 변수를 int로 변경
  String validateText = '';
  String amount = '';
  bool BtnDisable = true;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _name = context.read<UserInfoProvider>().name;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    _childName = context.read<ChildInfoProvider>().name;
    _balance = context.read<AccountInfoProvider>().balance;
  }

  void onNumberPress(String val) {
    // 함수 인자 변경
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount + val;
    });
    moneyValidate();
  }

  void onBackspacePress() {
    if (amount.isEmpty) {
      setState(() {
        return;
      });
    } else {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
      });
    }
    moneyValidate();
  }

  void moneyValidate() {
    if (amount.isEmpty || _balance == null || _balance! < int.parse(amount)) {
      setState(() {
        BtnDisable = true;
        validateText = amount.isEmpty ? '' : '잔고가 부족합니다';
      });
    } else {
      setState(() {
        BtnDisable = false;
        validateText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedBalance = formattedMoney(_balance ?? 0); // 잔액을 문자열로 포맷팅

    return Scaffold(
      appBar: MyHeader(
        text: '용돈 보내기',
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            renderWhoReceiveMoney(),
            SizedBox(height: 80),
            sendMoneyField(),
            SizedBox(height: 50),
            Text(
              validateText,
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(
              height: 10,
            ),
            renderAvailableWithdrawalBalance(formattedBalance),
            SizedBox(height: 20),
            NumberKeyboard(
              onNumberPress: onNumberPress,
              onBackspacePress: onBackspacePress,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '확인',
        isDisabled: BtnDisable,
        action: () async {
          var response = await sendMoney(
              accessToken: _accessToken!,
              memberKey: _memberKey!,
              money: amount,
              childKey: _childKey);
          if (response['resultStatus']['successCode'] == 0) {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletedAndGoPage(
                      text: "용돈을 보냈어요!",
                      targetPage: ParentMainPage(),
                    )));
          }
          print('용돈 송금 완');
        },
      ),
    );
  }

  Future<dynamic> sendMoney({accessToken, memberKey, money, childKey}) async {
    dynamic data = {'childKey': childKey, 'money': money};
    final response = await dioPost(
        url: '/bank-service/api/$memberKey/account-history/transfer',
        data: data,
        accessToken: accessToken);
    return response;
  }

  Widget renderWhoReceiveMoney() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 이 부분을 추가
        children: [
          Text(
            '$_childName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '에게 얼마를 보낼까요?',
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget sendMoneyField() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 이 부분을 추가
        children: [
          Text(
            '$amount',
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            '원',
            style: TextStyle(
              fontSize: 40,
            ),
          )
        ],
      ),
    );
  }

  Widget renderAvailableWithdrawalBalance(String balance) {
    return Container(
      color: Colors.grey[200], // 회색 배경색상
      padding: EdgeInsets.all(16), // 내부 여백 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          Text('출금가능 잔액',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(width: 130), // 텍스트 사이의 간격 조정
          Text(
            balance,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
