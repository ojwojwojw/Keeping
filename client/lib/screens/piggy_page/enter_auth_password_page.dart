import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/password_keyboard.dart';
import 'package:provider/provider.dart';

// 임시
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

class EnterAuthPasswordPage extends StatefulWidget {
  EnterAuthPasswordPage({
    super.key,
  });

  @override
  State<EnterAuthPasswordPage> createState() => _EnterAuthPasswordPageState();
}

class _EnterAuthPasswordPageState extends State<EnterAuthPasswordPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통 만들기',
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
                Text(authPassword.toString())
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
        action: () {_makePiggy(
          context.watch<AddPiggyProvider>().content, 
          context.watch<AddPiggyProvider>().goalMoney,
          authPassword,
          context.watch<AddPiggyProvider>().imgPath!,
        );},
        isDisabled: (authPassword != null && authPassword!.length == 6) ? false : true,
      ),
    );
  }
}

Future<dynamic> _makePiggy(content, goalMoney, authPassword, imgPath) async {
  final response = await httpPost(
    'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/piggy/yoonyeji',
    {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data'
    },
    {
      "content": content,
      "goalMoney": goalMoney,
      "authPassword": authPassword,
      "uploadImage": imgPath
    }
  );
  if (response != null) {
    return response;
  } else {
    return null;
  }
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