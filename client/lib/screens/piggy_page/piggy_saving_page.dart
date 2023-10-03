import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/screens/piggy_page/piggy_enter_auth_password_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/number_keyboard.dart';
import 'package:provider/provider.dart';

class PiggySavingPage extends StatefulWidget {
  final Map<String, dynamic> piggyDetailInfo;

  PiggySavingPage({
    super.key,
    required this.piggyDetailInfo,
  });

  @override
  State<PiggySavingPage> createState() => _PiggySavingPageState();
}

class _PiggySavingPageState extends State<PiggySavingPage> {
  int? _balance;
  String validateText = '';

  @override
  void initState() {
    super.initState();
    _balance = context.read<AccountInfoProvider>().balance;
  }

  String amount = '';

  onNumberPress(val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount + val;
    });
    moneyValidate();
  }

  onBackspacePress() {
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

  moneyValidate() {
    if (amount.isNotEmpty &&
        _balance != null &&
        _balance! < int.parse(amount)) {
      setState(() {
        validateText = '잔고가 부족합니다';
      });
    } else {
      setState(() {
        validateText = '';
      });
    }
    if (amount.isNotEmpty &&
        widget.piggyDetailInfo['goalMoney'] -
                widget.piggyDetailInfo['balance'] <
            int.parse(amount)) {
      setState(() {
        validateText = '목표 금액을 초과했습니다.';
      });
    } else {
      setState(() {
        validateText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금하기',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                Text(widget.piggyDetailInfo['content'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: roundedMemoryImg(img: widget.piggyDetailInfo['savedImage'], size: 150),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      amount != '' ? formattedMoney(int.parse(amount)) : '원',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: validateText != '' ? Colors.red : Colors.black),
                    ),
                  ],
                ),
                Text(
                  validateText,
                  style: TextStyle(color: Colors.red),
                )
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
                    shadow: false, bgColor: Color(0xffF0F0F0), borderRadius: 10
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('남은 목표 금액', style: TextStyle(color: Color(0xff757575), fontSize: 16),),
                        Row(
                          children: [
                            Text(formattedMoney(widget.piggyDetailInfo['balance']).toString()),
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
        action: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PiggyEnterAuthPasswordPage(
                        money: int.parse(amount),
                        piggyAccountNumber:
                            widget.piggyDetailInfo['accountNumber'],
                      )));
        },
        isDisabled: (amount.isNotEmpty &&
                _balance != null &&
                _balance! >= int.parse(amount))
            ? false
            : true,
      ),
    );
  }
}
