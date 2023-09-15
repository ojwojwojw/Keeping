import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';

class MakeAccountBtn extends StatelessWidget {
  MakeAccountBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(fontSize: 18,)
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기 반지름 설정
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(350.0, 100.0), // 퍼센트로 바꿀 수 있으면 바꾸기. 버튼의 최소 높이와 너비 설정
        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MakeAccountPage()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.add),
          Text(
            '계좌 만들기',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25
            ),
          ),
        ],
      ),
    );
  }
}