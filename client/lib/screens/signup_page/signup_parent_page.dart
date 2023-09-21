import 'package:flutter/material.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';
// import 'package:keeping/util/build_phone_number_form_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
TextEditingController _userPwCk = TextEditingController();
TextEditingController _userName = TextEditingController();
TextEditingController _userBirth = TextEditingController();
TextEditingController _userPhoneNumber = TextEditingController();
TextEditingController _userVerificationNumber = TextEditingController();
final _signupKey = GlobalKey<FormState>();

class SignUpParentPage extends StatefulWidget {
  const SignUpParentPage({Key? key}) : super(key: key);

  @override
  _SignUpParentPageState createState() => _SignUpParentPageState();
}

class _SignUpParentPageState extends State<SignUpParentPage> {
  String userId = _userId.text;
  String userPw = _userPw.text;
  String userPwCk = _userPwCk.text;
  String userName = _userName.text;
  String userBirth = _userBirth.text;
  String userPhoneNumber = _userPhoneNumber.text;
  String userVerificationNumber = _userVerificationNumber.text;
  // Future<String> idDi
  String idDupRes = '';
  String verificationResult = ''; // 인증번호 송신 확인
  String certificationResult = ''; // 인증번호 확인
  @override
  void initState() {
    super.initState();
    _userId = TextEditingController();
    _userPw = TextEditingController();
    _userPwCk = TextEditingController();
    _userName = TextEditingController();
    _userPhoneNumber = TextEditingController();
    _userBirth = TextEditingController();
  }

  @override
  void dispose() {
    _userId.dispose();
    _userPw.dispose();
    _userPwCk.dispose();
    _userName.dispose();
    _userBirth.dispose();
    _userPhoneNumber.dispose();
    super.dispose();
  }

  handledupCheck(result) {
    setState(() {
      idDupRes = result;
      print(result);
    });
  }

  //인증번호 송신 확인하는 코드
  handleCheckVerification(result) {
    setState(() {
      verificationResult = result;
    });
  }

  //인증번호 인증되었는지 확인하는 코드
  handleCheckCertification(result) {
    setState(() {
      certificationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _signupKey,
          child: Column(
            children: [
              MyHeader(
                text: '부모가 회원 가입 중',
                elementColor: Colors.black,
                icon: Icon(Icons.arrow_circle_up),
                path: SignUpParentPage(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    userIdField(),
                    ConfirmBtn(
                      text: '아이디 중복 확인',
                      action: () {
                        idDupliCheck(context, handledupCheck);
                      },
                    ),
                    // FutureBuilder(future: future, builder: builder)
                    Text(idDupRes),
                    userPwField(),
                    userPwCkField(),
                    usernameField(),
                    userBirthField(),
                    userPhoneNumberField(),
                    //인증번호 관련 로직 - verification
                    ConfirmBtn(
                      text: '인증번호 받기',
                      action: () {
                        checkVerification(context, handleCheckVerification);
                      },
                    ),
                    //인증번호 넣어주는 로직 - certification
                    userVerificationField(),
                    Text(verificationResult),
                    ConfirmBtn(
                      text: '인증번호 확인',
                      action: () {
                        checkCertification(context, handleCheckCertification);
                      },
                    ),
                    Text(certificationResult),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '회원가입부모',
        action: () {
          signUp();
        },
      ),
    );
  }

  Widget userIdField() {
    return BuildTextFormField(
      controller: _userId,
      labelText: '아이디',
      hintText: '아이디를 입력해주세요',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '아이디는 5글자 이상이 되어야 합니다.';
        } else if (value.length > 20) {
          return '아이디는 20글자 이하가 되어야 합니다.';
        } else if (!value.contains(RegExp(r'[a-zA-Z]'))) {
          return '아이디에는 영어가 1자 이상 포함되어야 합니다.';
        }
        return null;
      },
    );
  }

  Widget userPwField() {
    return BuildTextFormField(
      controller: _userPw,
      labelText: '비밀번호',
      hintText: '비밀번호를 입력해주세요',
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '비밀번호는 5자 이상이 되어야 합니다';
        } else if (value.length > 25) {
          return '비밀번호는 25자 이하가 되어야 합니다.';
        }
        return null;
      },
    );
  }

  Widget userPwCkField() {
    return BuildTextFormField(
      controller: _userPwCk,
      labelText: '비밀번호확인',
      hintText: '비밀번호를 한 번 더 입력해주세요.',
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '비밀번호는 5자 이상이 되어야 합니다';
        } else if (value.length > 25) {
          return '비밀번호는 25자 이하가 되어야 합니다.';
        } else if (value != _userPw.text) {
          return '비밀번호와 일치하지 않습니다.';
        }
        return null;
      },
    );
  }

  Widget usernameField() {
    return BuildTextFormField(
      controller: _userName,
      labelText: '이름',
      hintText: '이름을 입력해주세요.',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget userBirthField() {
    return BuildTextFormField(
      controller: _userBirth,
      labelText: '생년월일',
      hintText: 'YYYY-MM-DD',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget userPhoneNumberField() {
    return BuildTextFormField(
      controller: _userPhoneNumber,
      labelText: '휴대폰 번호',
      hintText: '- 없이 숫자만 입력해주세요. (예:01012345678)',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }

  Widget userVerificationField() {
    return BuildTextFormField(
      controller: _userVerificationNumber,
      labelText: '인증번호',
      hintText: '휴대폰으로 받은 인증번호를 입력해주세요.',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        }
        return null;
      },
    );
  }
}

Future<void> signUp() async {
  print('회원가입 함수까지 옵니다.');
  String userId = _userId.text;
  String userPw = _userPw.text;
  String userName = _userName.text;
  String tmpPhone = _userName.text;
  String userBirth = _userBirth.text;
  // String
  if (_signupKey.currentState!.validate()) {
    print('유효성 검사 통과');
    final response = await httpPost(
      'http://j9c207.p.ssafy.io:8000/member-service/api/join/parent',
      null,
      {
        'loginId': userId,
        'loginPw': userPw,
        'name': userName,
        'phone': tmpPhone,
        'birth': userBirth
      },
    );
    if (response != null) {
      print('회원 가입 완료');
    } else {
      print('회원가입실패');
    }
  }

  // 여기서 회원가입 로직을 수행하세요.
}

Future<void> idDupliCheck(BuildContext context, Function handledupCheck) async {
  Dio dio = Dio();
  String id = _userId.text;
  print(id);
  try {
    var response = await dio
        .get('http://j9c207.p.ssafy.io:8000/member-service/api/id/${id}');
    print(response);
    if (response.data.resultStatus.successCode == 0) {
      handledupCheck(response.data.resultBody);
    } else {
      handledupCheck(response.data.resultMessage);
    }
  } catch (err) {
    print(err);
  }
}

// 인증 번호 받기 로직
Future<void> checkVerification(
    BuildContext context, Function handleCheckVerification) async {
  Dio dio = Dio();

  String tmpNumber = _userPhoneNumber.text;

  // 전화 번호를 하이픈 형식으로 변환
  String formattedNumber = formatPhoneNumber(tmpNumber);

  print(formattedNumber);
  try {
    var response = await dio.post(
      'http://j9c207.p.ssafy.io:8000/member-service/api/phone',
      data: {'phone': formattedNumber},
    );
    if (response.data.resultStatus.successCode == 0) {
      handleCheckVerification(response.data.resultBody);
    } else if (response.data.resultStatus.successCode == 409) {
      handleCheckVerification(response.data.resultMessage);
    } else {
      handleCheckVerification('휴대폰 번호를 다시 확인해주세요');
    }
    print(response);
  } catch (err) {
    print(err);
  }
}

Future<void> checkCertification(
    BuildContext context, Function handleCheckCertification) async {
  String certificationNumber = _userVerificationNumber.text;
  String tmpNumber = _userPhoneNumber.text;
  String formattedNumber = formatPhoneNumber(tmpNumber);
  print('여기까진 오네요 ${formattedNumber} ${certificationNumber}');
  final response = await httpPost(
    'http://j9c207.p.ssafy.io:8000/member-service/api/phone-check',
    null,
    {'phone': formattedNumber, 'certification': certificationNumber},
  );
  print('흠');
  if (response != null) {
    handleCheckCertification('인증이 완료되었습니다.');
  } else {
    handleCheckCertification('인증에 실패했습니다. 다시 확인해주세요.');
  }
}

String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length == 11) {
    return phoneNumber.replaceFirstMapped(RegExp(r'(\d{3})(\d{4})(\d{4})'),
        (match) {
      return '${match[1]}-${match[2]}-${match[3]}';
    });
  } else {
    return phoneNumber; // 형식에 맞지 않는 경우 그대로 반환
  }
}

Future<List<dynamic>?> httpGet(String url, Map<String, String>? headers) async {
  try {
    var response = await http.get(Uri.parse(url), headers: headers);
    print('blah');
    print(response);
    print('1');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print('HTTP Request Failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print(2);
    print('Error during HTTP request: $e');
    return null;
  }
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
