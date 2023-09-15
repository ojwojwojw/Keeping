import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';

class MakeAccountBtn extends StatelessWidget {
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
        children: const [
          Icon(Icons.plus_one),
          Text('계좌 만들기'),
        ],
      ),
    );
  }
}

// axiosPost();

// Future<List<dynamic>?> axiosPost(String url, Map<String, String>? headers) async {
//   try {
//     var response = await http.post(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body);
//       return result;
//     } else {
//       print('HTTP Request Failed with status code: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error during HTTP request: $e');
//     return null;
//   }
// }