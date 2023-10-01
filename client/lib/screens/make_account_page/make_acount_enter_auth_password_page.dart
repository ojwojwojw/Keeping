import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/make_account_page/utils/make_account_future_methods.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/password_circles.dart';
import 'package:keeping/widgets/password_keyboard.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class MakeAccountEnterAuthPasswordPage extends StatefulWidget {
  MakeAccountEnterAuthPasswordPage({
    super.key,
  });

  @override
  State<MakeAccountEnterAuthPasswordPage> createState() =>
      _MakeAccountEnterAuthPasswordPageState();
}

class _MakeAccountEnterAuthPasswordPageState
    extends State<MakeAccountEnterAuthPasswordPage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _authPassword;

  setAuthPassword(String value) {
    setState(() {
      _authPassword = value;
    });
  }

  onNumberPress(val) {
    if (_authPassword != null && _authPassword!.length >= 6) {
      return;
    } else if (_authPassword == null) {
      setState(() {
        _authPassword = val;
      });
    } else {
      setState(() {
        _authPassword = _authPassword! + val;
      });
    }
  }

  onBackspacePress() {
    if (_authPassword == null || _authPassword!.isEmpty) {
      return;
    }

    setState(() {
      _authPassword = _authPassword!.substring(0, _authPassword!.length - 1);
    });
  }

  onClearPress() {
    setState(() {
      _authPassword = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '계좌 만들기',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 60,
            ),
            child: Column(
              children: [
                Text(
                  '비밀번호 입력',
                  style: TextStyle(fontSize: 27),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  '결제 비밀번호를 입력해 주세요.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                passwordCircles(
                    _authPassword != null ? _authPassword!.length : 0),
                Text(_authPassword.toString())
              ],
            ),
          ),
          PasswordKeyboard(
              onNumberPress: onNumberPress,
              onBackspacePress: onBackspacePress,
              onClearPress: onClearPress),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '만들기',
        action: () async {
          var response = await makeAccount(
              accessToken: _accessToken!,
              memberKey: _memberKey!,
              authPassword: _authPassword!);
          if (response == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CompletedPage(
                          text: '계좌가\n개설되었습니다.',
                          button: ConfirmBtn(
                            action: _parent != null && _parent == true
                                ? ParentMainPage()
                                : ChildMainPage(),
                          ),
                        )));
          } else if (response == 1) {
            roundedModal(context: context, title: '핸드폰 번호가 인증되지 않았습니다.');
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
        },
        isDisabled: (_authPassword != null && _authPassword!.length == 6)
            ? false
            : true,
      ),
    );
  }
}
