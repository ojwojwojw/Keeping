import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통 만들기',
      ),
      body: Column(
        children: [
          Text(context.watch<AddPiggyProvider>().content!),
          Text(context.watch<AddPiggyProvider>().goalMoney!.toString()),
          Text(context.watch<AddPiggyProvider>().imgPath!),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '만들기',
        // action: () {_makePiggy(content, goalMoney, imgPath);},
      ),
    );
  }
}

Future<dynamic> _makePiggy(content, goalMoney, imgPath) async {
  final response = await httpPost(
    'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/piggy/yoonyeji',
    {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data'
    },
    {
      "content": "아디다스 삼바 내꺼야",
      "goalMoney": 140000,
      "authPassword": "123456",
      // "uploadImage": adidas.png
    }
  );
  if (response != null) {
    return response;
  } else {
    return null;
  }
}