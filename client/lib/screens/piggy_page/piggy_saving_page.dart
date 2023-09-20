import 'package:flutter/material.dart';
import 'package:keeping/screens/piggy_page/enter_auth_password_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/number_keyboard.dart';

class PiggySavingPage extends StatefulWidget {
  PiggySavingPage({
    super.key,
  });

  @override
  State<PiggySavingPage> createState() => _PiggySavingPageState();
}

class _PiggySavingPageState extends State<PiggySavingPage> {
  @override
  void initState() {
    super.initState();
    amount = '';
  }

  String amount = '';

  onNumberPress(val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount + val;
    });
  }

  onBackspacePress() {
    if (amount.isEmpty) {
      return;
    }
    setState(() {
      amount = amount.substring(0, amount.length - 1);
    });
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
          Column(
            children: [
              Text(amount),
            ],
          ),
          NumberKeyboard(onNumberPress: onNumberPress, onBackspacePress: onBackspacePress,)
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () async {
          Navigator.push(context, MaterialPageRoute(builder: (_) => EnterAuthPasswordPage()));
        },
      ),
    );
  }
}