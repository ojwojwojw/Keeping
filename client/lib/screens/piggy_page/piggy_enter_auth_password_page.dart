import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/piggy_page/piggy_detail_page.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/password_keyboard.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class PiggyEnterAuthPasswordPage extends StatefulWidget {
  final int money;
  final String piggyAccountNumber;

  PiggyEnterAuthPasswordPage({
    super.key,
    required this.money,
    required this.piggyAccountNumber,
  });

  @override
  State<PiggyEnterAuthPasswordPage> createState() => _PiggyEnterAuthPasswordPageState();
}

class _PiggyEnterAuthPasswordPageState extends State<PiggyEnterAuthPasswordPage> {
  String? _accessToken;
  String? _memberKey;
  String? authPassword;

  setAuthPassword(String value) {
    setState(() {
      authPassword = value;
    });
  }

  onNumberPress(val) {
    if (authPassword != null && authPassword!.length >= 6) {
      return;
    } else if (authPassword == null) {
      setState(() {
        authPassword = val;
      });
    } else {
      setState(() {
        authPassword = authPassword! + val;
      });
    }

  }

  onBackspacePress() {
    if (authPassword == null || authPassword!.isEmpty) {
      return;
    }

    setState(() {
      authPassword = authPassword!.substring(0, authPassword!.length - 1);
    });
  }

  onClearPress() {
    setState(() {
      authPassword = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
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
            padding: EdgeInsets.only(top: 60,),
            child: Column(
              children: [
                Text('비밀번호 입력', style: TextStyle(fontSize: 27),),
                SizedBox(height: 7,),
                Text('결제 비밀번호를 입력해 주세요.', style: TextStyle(fontSize: 15, color: Colors.black54),),
                passwordCircles(authPassword != null ? authPassword!.length : 0),
                // Text(authPassword.toString())
              ],
            ),
          ),
          PasswordKeyboard(
            onNumberPress: onNumberPress,
            onBackspacePress: onBackspacePress,
            onClearPress: onClearPress
          ),
        ],
      ),
      bottomSheet: BottomBtn(
        text: '저금하기',
        action: () async {
          final response = savePiggy(
            accessToken: _accessToken,
            memberKey: _memberKey,
            accountNumber: Provider.of<AccountInfoProvider>(context, listen: false).accountNumber, 
            piggyAccountNumber: widget.piggyAccountNumber,
            money: widget.money,
            authPassword: authPassword,
          );
          if (response != null) {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => CompletedPage(
                  text: '저금이\n완료되었습니다.',
                  button: ConfirmBtn(
                    action: PiggyDetailPage(piggyDetailInfo: context.read<PiggyDetailProvider>().selectedPiggyDetailInfo!), 
                  ),
                )
              )
            );
          } else {
            roundedModal(context: context, title: '다시 시도해주세요.');
          }
        },
        isDisabled: (authPassword != null && authPassword!.length == 6) ? false : true,
      ),
    );
  }
}

Future<dynamic> _makePiggy(content, goalMoney, authPassword, imgPath) async {
  final response = await dioPost(
    accessToken: 'accessToken', 
    url: '/bank-service/piggy/yoonyeji',
    data: {
      "content": content,
      "goalMoney": goalMoney,
      "authPassword": authPassword,
      "uploadImage": imgPath
    }
  );
  return response;
}

Widget passwordCircles(int inputLen) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          passwordCircle(1, inputLen),
          passwordCircle(2, inputLen),
          passwordCircle(3, inputLen),
          passwordCircle(4, inputLen),
          passwordCircle(5, inputLen),
          passwordCircle(6, inputLen),
        ],
      ),
    ),
  );
}

Widget passwordCircle(int order, int inputLen) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: order > inputLen ? Colors.black26 : const Color(0xFF8320E7),
      ),
    ),
  );
}