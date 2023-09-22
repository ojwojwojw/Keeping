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
import 'package:keeping/util/render_field.dart';

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
  String _loginId = '';
  String _loginPw = '';
  String _loginPwCk = '';
  String _name = '';
  String _birth = '';
  String _phone = '';
  String _userVerificationNumber = '';
  String _idDupRes = '';
  String _verificationResult = ''; // 인증번호 송신 확인
  String _certificationResult = ''; // 인증번호 확인
  @override
  void initState() {
    super.initState();
    // _userId = TextEditingController();
    // _userPw = TextEditingController();
    // _userPwCk = TextEditingController();
    // _userName = TextEditingController();
    // _userPhoneNumber = TextEditingController();
    // _userBirth = TextEditingController();
    // _userVerificationNumber = TextEditingController();
  }

  // @override
  // void dispose() {

  //   _loginId.dispose();
  //   _loginPw.dispose();
  //   _userPwCk.dispose();
  //   _userName.dispose();
  //   _userBirth.dispose();
  //   _userPhoneNumber.dispose();
  //   // _userVerificationNumber.dispose();
  //   super.dispose();
  // }

  void handleUserId(data) {
    setState(() {
      _loginId = data;
    });
  }

  void handleUserPw(data) {
    setState(() {
      _loginPw = data;
    });
  }

  void handleUserPwCk(data) {
    setState(() {
      _loginPwCk = data;
    });
  }

  void handleUserName(data) {
    setState(() {
      _name = data;
    });
  }

  void handleUserBirth(data) {
    setState(() {
      _birth = data;
    });
  }

  void handleUserPhone(data) {
    setState(() {
      _phone = data;
    });
  }

  void handleUserVerificationNumber(data) {
    setState(() {
      _userVerificationNumber = data;
    });
  }

  handledupCheck(result) {
    setState(() {
      _idDupRes = result;
    });
  }

  //인증번호 송신 확인하는 코드
  handleCheckVerification(result) {
    setState(() {
      _verificationResult = result;
    });
  }

  //인증번호 인증되었는지 확인하는 코드
  handleCheckCertification(result) {
    setState(() {
      _certificationResult = result;
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
                    renderTextFormField(
                        label: '아이디',
                        onChange: (val) {
                          String userId = val;
                          handleUserId(userId);
                        },
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
                        controller: _userId),
                    ConfirmBtn(
                      text: '아이디 중복 확인',
                      action: () {
                        idDupliCheck(context, handledupCheck);
                      },
                    ),
                    // FutureBuilder(future: future, builder: builder)
                    Text(_idDupRes),
                    renderTextFormField(
                      label: '비밀번호',
                      onChange: (val) {
                        String userPw = val;
                        handleUserPw(userPw);
                      },
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
                      controller: _userPw,
                      isPassword: true,
                    ),
                    renderTextFormField(
                      label: '비밀번호확인',
                      onChange: (val) {
                        String userPwCk = val;
                        handleUserPw(userPwCk);
                      },
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
                      controller: _userPwCk,
                      isPassword: true,
                    ),
                    renderTextFormField(
                      label: '이름',
                      onChange: (val) {
                        String userName = val;
                        handleUserName(userName);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                    ),
                    renderTextFormField(
                      label: '생년월일',
                      onChange: (val) {
                        String userBirth = val;
                        handleUserBirth(userBirth);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                    ),
                    renderTextFormField(
                      label: '휴대폰 번호',
                      onChange: (val) {
                        String userPhonenumber = val;
                        handleUserPhone(userPhonenumber);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                    ),
                    //인증번호 관련 로직 - verification
                    ConfirmBtn(
                      text: '인증번호 받기',
                      action: () {
                        checkVerification(context, handleCheckVerification);
                      },
                    ),
                    Text(_verificationResult),
                    renderTextFormField(
                      label: '인증번호 입력',
                      onChange: (val) {
                        String verificationNumber = val;
                        handleUserVerificationNumber(verificationNumber);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        }
                        return null;
                      },
                    ),
                    //인증번호 넣어주는 로직 - certification
                    ConfirmBtn(
                      text: '인증번호 확인',
                      action: () {
                        checkCertification(context, handleCheckCertification);
                      },
                    ),
                    Text(_certificationResult),
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

  Future<void> idDupliCheck(
      BuildContext context, Function handledupCheck) async {
    final id = _loginId;
    print(id);
    try {
      var response = await dio.get(
        'http://j9c207.p.ssafy.io:8000/member-service/api/id/${id}',
      );
      var jsonResponse = json.decode(response.toString()); // 문자열로 변환 후 JSON 파싱
      print(jsonResponse);
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
    final data = {
      'phone': _phone,
    };
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/api/phone',
        data: data,
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
    String certification = _userVerificationNumber; // 유저가 넣어준 인증번호
    String phone = _phone;
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

  Future<void> signUp(BuildContext context) async {
    print('회원가입 함수까지 옵니다.');
    final data = {
      'loginId': _loginId,
      'loginPw': _loginPw,
      'name': _name,
      'phone': _phone,
      'birth': _birth
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
}
