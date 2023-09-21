import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/util/build_phone_number_form_field.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/util/build_text_form_field.dart';
// import 'package:keeping/util/build_phone_number_form_field.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

Dio dio = Dio();

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
    _userVerificationNumber = TextEditingController();
  }

  @override
  void dispose() {
    _userId.dispose();
    _userPw.dispose();
    _userPwCk.dispose();
    _userName.dispose();
    _userBirth.dispose();
    _userPhoneNumber.dispose();
    _userVerificationNumber.dispose();
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
                text: '회원가입',
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
                    Text(verificationResult),
                    userVerificationField(),
                    //인증번호 넣어주는 로직 - certification
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
        text: '회원가입',
        action: () {
          signUp(context);
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
      hintText: '비밀번호를 입력해주세요. 비밀번호는 숫자, 영문자, 특수문자가 들어가야 합니다.',
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 항목입니다';
        } else if (value.length < 5) {
          return '비밀번호는 5자 이상이 되어야 합니다.';
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
    return BuildPhoneNumberFormField(
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

Future<void> signUp(BuildContext context) async {
  print('회원가입 함수까지 옵니다.');
  String loginId = _userId.text;
  String loginPw = _userPw.text;
  String name = _userName.text;
  String phone = _userPhoneNumber.text;
  String birth = _userBirth.text;
  var data = {
    'loginId': loginId,
    'loginPw': loginPw,
    'name': name,
    'phone': phone,
    'birth': birth
  };
  // String
  if (_signupKey.currentState!.validate()) {
    print('유효성 검사 통과');
    BuildContext currentContext = context;
    print(data);
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/api/join/parent',
        data: data,
      );
      final jsonResponse = json.decode(response.toString());
      print(jsonResponse);
      if (jsonResponse['resultStatus']['successCode'] == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else if (jsonResponse['resultStatus']['resultCode'] == 409) {
        print('이미 가입한 회원입니다.');
      } else {
        print('유효성 검사 실패');
      }
    } catch (err) {
      print(err);
    }
  }
}

Future<void> idDupliCheck(BuildContext context, Function handledupCheck) async {
  String id = _userId.text;
  try {
    var response = await dio.get(
      'http://j9c207.p.ssafy.io:8000/member-service/api/id/${id}',
    );
    var jsonResponse = json.decode(response.toString()); // 문자열로 변환 후 JSON 파싱
    print('${jsonResponse['resultStatus']}, jsonresponse');
    if (jsonResponse['resultStatus']['successCode'] == 0) {
      handledupCheck(jsonResponse['resultBody']);
    } else {
      handledupCheck(jsonResponse['resultStatus']['resultMessage']);
    }
  } catch (err) {
    handledupCheck('아이디 양식을 지켜주세요. \n 아이디는 5~20자 사이로, 영어와 숫자만 입력할 수 있습니다.');
  }
}

// 인증 번호 받기 로직
Future<void> checkVerification(
    BuildContext context, Function handleCheckVerification) async {
  String phone = _userPhoneNumber.text;

  try {
    var response = await dio.post(
      'http://j9c207.p.ssafy.io:8000/member-service/api/phone',
      data: {'phone': phone},
    );
    var jsonResponse = json.decode(response.toString());
    if (jsonResponse['resultStatus']['successCode'] == 0) {
      handleCheckVerification(jsonResponse['resultBody']);
    } else if (response.data.resultStatus.successCode == 409) {
      handleCheckVerification(jsonResponse['resultBody']);
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
  String certification = _userVerificationNumber.text; // 유저가 넣어준 인증번호
  String phone = _userPhoneNumber.text;
  try {
    var response = await dio.post(
      'http://j9c207.p.ssafy.io:8000/member-service/api/phone-check',
      data: {'phone': phone, 'certification': certification},
    );
    var jsonResponse = json.decode(response.toString());
    print(jsonResponse);
    if (jsonResponse['resultStatus']['successCode'] == 0) {
      handleCheckCertification(jsonResponse['resultBody']);
    } else {
      handleCheckCertification(jsonResponse['resultStatus']['resultMessage']);
    }
  } catch (err) {
    print(err);
  }
}
