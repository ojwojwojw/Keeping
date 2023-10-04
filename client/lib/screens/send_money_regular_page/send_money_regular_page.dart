import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/number_keyboard.dart'; // 새로 추가된 키보드 위젯 임포트
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';

class SendMoneyRegularPage extends StatefulWidget {
  const SendMoneyRegularPage({Key? key});

  @override
  State<SendMoneyRegularPage> createState() => _SendMoneyRegularPageState();
}

class _SendMoneyRegularPageState extends State<SendMoneyRegularPage> {
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

// 첫 페이지
  @override
  Widget build(BuildContext context) {
    String formattedBalance = formattedMoney(_balance ?? 0); // 잔액을 문자열로 포맷팅

    return Scaffold(
      appBar: MyHeader(
        text: '용돈 보내기',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              renderWhoReceiveMoney(),
              SizedBox(height: 70),
              sendMoneyField(),
              SizedBox(height: 30),
              Text(
                validateText,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: roundedBoxWithShadowStyle(
                      shadow: false,
                      bgColor: Color(0xffF0F0F0),
                      borderRadius: 10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '출금 가능 잔액',
                          style:
                              TextStyle(color: Color(0xff757575), fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(formattedBalance),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              NumberKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomBtn(
          text: '다음',
          isDisabled: BtnDisable,
          action: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WhenSendPocketMoneyPage(
                  accessToken: _accessToken,
                  memberKey: _memberKey,
                  childKey: _childKey,
                  amount: amount,
                  childName: _childName,
                  balance: _balance,
                ),
              ),
            );
          }),
    );
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

class WhenSendPocketMoneyPage extends StatefulWidget {
  final String? accessToken;
  final String? memberKey;
  final String amount;
  final String? childKey;
  final String? childName;
  final int? balance;

  const WhenSendPocketMoneyPage({
    Key? key,
    this.accessToken,
    this.memberKey,
    required this.amount,
    required this.balance,
    this.childKey,
    this.childName,
  }) : super(key: key);

  @override
  _WhenSendPocketMoneyPageState createState() =>
      _WhenSendPocketMoneyPageState();
}

class _WhenSendPocketMoneyPageState extends State<WhenSendPocketMoneyPage> {
  late String accessToken;
  late String amount;
  late String memberKey;
  late String childKey;
  late String childName;
  bool BtnDisable = true;
  late String day;
  late String validateText;

  @override
  void initState() {
    super.initState();
    accessToken = widget.accessToken ?? "";
    amount = widget.amount;
    memberKey = widget.memberKey ?? "";
    childKey = widget.childKey ?? "";
    childName = widget.childName ?? "";
    day = '';
    validateText = '';
  }

  void onNumberPress(String val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      day = day + val;
    });
    moneyValidate();
  }

  void onBackspacePress() {
    if (day.isEmpty) {
      setState(() {
        return;
      });
    } else {
      setState(() {
        day = day.substring(0, day.length - 1);
      });
    }
    moneyValidate();
  }

  void moneyValidate() {
    if (day.isEmpty ||
        int.tryParse(day) == null ||
        int.parse(day) > 29 ||
        int.parse(day) < 1) {
      setState(() {
        BtnDisable = true;
        validateText = (day.isEmpty || int.tryParse(day) == null)
            ? ''
            : '1일에서 29일 사이로 입력해주세요!';
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
    // String formattedBalance = formattedMoney(_balance ?? 0); // 잔액을 문자열로 포맷팅

    return Scaffold(
      appBar: MyHeader(
        text: '용돈 보내기',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                sendMoneyInfo(),
                SizedBox(
                  height: 30,
                ),
                MyDateField(day),
                SizedBox(
                  height: 15,
                ),
                Text(validateText),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: roundedBoxWithShadowStyle(
                      shadow: false,
                      bgColor: Color(0xffF0F0F0),
                      borderRadius: 10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '출금 가능 잔액',
                          style:
                              TextStyle(color: Color(0xff757575), fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(formattedMoney(widget.balance)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              NumberKeyboard(
                onNumberPress: onNumberPress,
                onBackspacePress: onBackspacePress,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        isDisabled: BtnDisable,
        action: () async {
          var response = await sendMoney(
            accessToken: accessToken,
            memberKey: memberKey,
            money: int.parse(amount),
            childKey: childKey,
            day: int.parse(day),
          );
          if (response['resultStatus']['successCode'] == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompletedPage(
                          text: "용돈을 보냈어요!",
                          button: ConfirmBtn(
                            action: ParentMainPage(),
                          ),
                        )));
          }
          print(response);
          print('용돈 송금 완');
        },
      ),
    );
  }

  Future<dynamic> sendMoney({
    accessToken,
    memberKey,
    money,
    childKey,
    day,
  }) async {
    dynamic data = {'childKey': childKey, 'money': money, 'day': day};
    final response = await dioPost(
      url: '/bank-service/api/$memberKey/regular-allowance',
      data: data,
      accessToken: accessToken,
    );
    return response;
  }

  Widget sendMoneyInfo() {
    int moneyAmount = int.parse(amount); // amount 변수를 정수로 변환
    String formatMoney = formattedMoney(moneyAmount);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬 추가
            children: [
              Text(
                '$childName',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '에게',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(width: 7),
              Text(
                '$formatMoney',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '을',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          Text('언제 보낼까요?', style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}

Widget MyDateField(day) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬 추가

      children: [
        Text(
          '매달',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(width: 10), // 좌측 여백 조정
        Text(
          '$day',
          style: TextStyle(fontSize: 30),
        ), // day 변수를 Text 위젯에 표시
        SizedBox(width: 10), // 우측 여백 조정
        Text(
          '일마다',
          style: TextStyle(fontSize: 30),
        ),
      ],
    ),
  );
}
