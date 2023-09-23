import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/piggy_page/enter_auth_password_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/number_keyboard.dart';
import 'package:provider/provider.dart';

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
      setState(() {
        return;
      });
    } else {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
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
          Column(
            children: [
              Text(context.watch<PiggyDetailProvider>().content!),
              Text(context.watch<PiggyDetailProvider>().balance!.toString()),
              Text(
                amount,
                style: TextStyle(
                    color:
                        context.watch<PiggyDetailProvider>().balance != null &&
                                amount.isNotEmpty &&
                                context.watch<PiggyDetailProvider>().balance! <
                                    int.parse(amount)
                            ? Colors.red
                            : Colors.black),
              ),
              if (context.watch<PiggyDetailProvider>().balance != null &&
                  amount.isNotEmpty &&
                  context.watch<PiggyDetailProvider>().balance! <
                      int.parse(amount))
                Text(
                  '잔고가 부족합니다.',
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
          NumberKeyboard(
            onNumberPress: onNumberPress,
            onBackspacePress: onBackspacePress,
          )
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => EnterAuthPasswordPage()));
        },
        isDisabled: (amount.isNotEmpty &&
                context.watch<PiggyDetailProvider>().balance! >=
                    int.parse(amount))
            ? false
            : true,
      ),
    );
  }
}
