import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';
import 'package:keeping/screens/piggy_page/enter_auth_password_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/password_keyboard.dart';
import 'package:provider/provider.dart';

// 임시
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

class MakeAccountEnterAuthPasswordPage extends StatefulWidget {
  MakeAccountEnterAuthPasswordPage({
    super.key,
  });

  @override
  State<MakeAccountEnterAuthPasswordPage> createState() => _MakeAccountEnterAuthPasswordPageState();
}

class _MakeAccountEnterAuthPasswordPageState extends State<MakeAccountEnterAuthPasswordPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '계좌 만들기',
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
                passwordCircles(_authPassword != null ? _authPassword!.length : 0),
                Text(_authPassword.toString())
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
      bottomNavigationBar: BottomBtn(
        text: '만들기',
        action: () {
          _makeAccount(_authPassword!);  
        },
        isDisabled: (_authPassword != null && _authPassword!.length == 6) ? false : true,
      ),
    );
  }
}

Future<dynamic> _makeAccount(String authPassword) async {
  final response = await dioPost(
    accessToken: accessToken, 
    url: '/bank-service/account/yoonyeji',
    data: {
      'authPassword': '123456'
    }
  );
  if (response != null) {
    return response;
  } else {
    return null;
  }
}