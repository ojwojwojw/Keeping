import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/util/build_text_form_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

TextEditingController _curUserPw = TextEditingController();
TextEditingController _phoneNumber = TextEditingController();

class PhonenumEditPage extends StatefulWidget {
  const PhonenumEditPage({super.key});

  @override
  State<PhonenumEditPage> createState() => _PhonenumEditPageState();
}

class _PhonenumEditPageState extends State<PhonenumEditPage> {
  @override
  void initState() {
    super.initState();
    _curUserPw = TextEditingController();
    _phoneNumber = TextEditingController();
  }

  @override
  void dispose() {
    _curUserPw.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  String userCurPw = _curUserPw.text;
  String userNewPhonenumber = _phoneNumber.text;
  String accessToken = 'accessToken';
  String result = '';

  Widget authenticationBtn() {
    return ElevatedButton(
      onPressed: () async {
        final response = await httpPost(
            'https://14c6-121-178-98-20.ngrok-free.app/bank-service/account/phone-check/yoonyeji',
            {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json'
            },
            {
              'phone': userNewPhonenumber
            });
        if (response != null) {
          setState(() {
            result = response.toString();
          });
        } else {
          setState(() {
            result = '인증 실패';
          });
        }
      },
      style: authenticationBtnStyle(),
      child: Text('인증번호 받기'),
    );
  }

  Widget editInfoBtn() {
    return ElevatedButton(
        onPressed: () {
          print('휴대폰 번호 수정');
        },
        style: authenticationBtnStyle(),
        child: Text('정보 수정'));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '휴대폰 번호 변경', elementColor: Colors.black),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [Expanded(child: userPwField())],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: userPhoneField(),
                    ),
                    authenticationBtn(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '휴대폰 번호 수정',
        action: () {
          editPhoneNumber();
        },
      ),
    );
  }

  void editPhoneNumber() {
    print('휴대폰 번호 수정');
  }
}

Widget userPwField() {
  return BuildTextFormField(
    controller: _curUserPw,
    labelText: '기존 비밀번호',
    hintText: '기존 비밀번호를 입력해주세요',
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '필수 항목입니다';
      }
      return null;
    },
  );
}

Widget userPhoneField() {
  return BuildTextFormField(
    controller: _phoneNumber,
    labelText: '휴대폰 번호',
    hintText: '숫자만 입력해주세요. (예: 01012345678)',
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '필수 항목입니다';
      }
      return null;
    },
  );
}

Future<dynamic> httpPost(
    String url, Map<String, String>? headers, Map<String, dynamic> body) async {
  try {
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print('HTTP Request Failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during HTTP request: $e');
    return null;
  }
}

ButtonStyle authenticationBtnStyle() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )),
      fixedSize: MaterialStateProperty.all<Size>(Size(120, 40)));
}
