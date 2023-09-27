import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:keeping/widgets/render_field.dart';

Dio dio = Dio();

final _signupKey = GlobalKey<FormState>();

class SignUpParentPage extends StatefulWidget {
  const SignUpParentPage({Key? key}) : super(key: key);

  @override
  _SignUpParentPageState createState() => _SignUpParentPageState();
}

class _SignUpParentPageState extends State<SignUpParentPage> {
  TextEditingController _userId = TextEditingController();
  TextEditingController _userPw = TextEditingController();
  TextEditingController _userPwCk = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _userBirth = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _userVerificationNumber = TextEditingController();

  String _idDupRes = '';
  String _verificationResult = ''; // 인증번호 송신 확인
  String _certificationResult = ''; // 인증번호 확인
  bool _isButtonDisabled = true;
  bool _isIdDupChecked = false; // 아이디 중복 체크 완료 여부(본인)
  bool _isVerificationChecked = false; //인증 번호 체크 완료 여부(본인)
  @override
  void initState() {
    super.initState();
  }

  handleSignupDisable() {
    if (_isIdDupChecked &&
        _isVerificationChecked &&
        _signupKey.currentState != null &&
        _signupKey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  handleIsIdDupChecked(result) {
    _isIdDupChecked = result;
    print(_isIdDupChecked);
  }

  handleIsVerificationChecked(result) {
    _isVerificationChecked = result;
    print(_isVerificationChecked);
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
      appBar: MyHeader(
        text: '회원가입',
        elementColor: Colors.black,
        icon: Icon(Icons.arrow_circle_up),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _signupKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        renderTextFormField(
                            label: '아이디',
                            hintText: '아이디를 입력해주세요.',
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
                            controller: _userId,
                            width: 220,
                            onChange: handleSignupDisable()),
                        _authenticationBtn(
                          context,
                          '중복 확인',
                          () {
                            idDupliCheck(context, handledupCheck);
                          },
                        ),
                      ],
                    ),
                    Text(_idDupRes),
                    renderTextFormField(
                      label: '비밀번호',
                      hintText: '비밀번호를 입력해주세요.',
                      onChange: handleSignupDisable(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        } else if (value.length < 5) {
                          return '비밀번호는 5자 이상이 되어야 합니다.';
                        } else if (value.length > 25) {
                          return '비밀번호는 25자 이하가 되어야 합니다.';
                        } else if (!value.contains(RegExp(r'[A-Za-z]'))) {
                          return '비밀번호에는 영문자가 포함되어야 합니다.';
                        } else if (!value.contains(RegExp(r'[0-9]'))) {
                          return '비밀번호에는 숫자가 포함되어야 합니다.';
                        } else if (!value
                            .contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                          return '비밀번호에는 특수 문자가 포함되어야 합니다.';
                        }
                        return null;
                      },
                      controller: _userPw,
                      isPassword: true,
                    ),
                    renderTextFormField(
                      label: '비밀번호 확인',
                      hintText: '비밀번호를 한 번 더 입력해주세요.',
                      onChange: handleSignupDisable(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        } else if (value.length < 5) {
                          return '비밀번호는 5자 이상이 되어야 합니다.';
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
                        hintText: '이름을 입력해주세요.',
                        onChange: handleSignupDisable(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '필수 항목입니다';
                          }
                          return null;
                        },
                        controller: _userName),
                    renderBirthdayFormField(
                      label: '생년월일',
                      hintText: '생년월일을 입력해주세요.',
                      onChange: handleSignupDisable(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '필수 항목입니다';
                        } else if (value.length != 10) {
                          return '생년월일을 정확히 입력해주세요.';
                        }
                        return null;
                      },
                      controller: _userBirth,
                    ),
                    Row(
                      children: [
                        renderPhoneNumberFormField(
                            label: '휴대폰 번호',
                            hintText: '휴대폰 번호를 입력해주세요.',
                            onChange: handleSignupDisable(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '필수 항목입니다';
                              } else if (value.length != 13) {
                                return '휴대폰 번호를 정확히 입력해주세요.';
                              }
                              return null;
                            },
                            width: 220,
                            controller: _userPhoneNumber),
                        _authenticationBtn(context, '인증번호 받기', () {
                          checkVerification(
                              _userPhoneNumber, handleCheckVerification);
                        }),
                      ],
                    ),
                    //인증번호 관련 로직 - verification
                    Text(_verificationResult),
                    Row(
                      children: [
                        renderTextFormField(
                          label: '인증번호 입력',
                          hintText: '인증번호를 입력해주세요.',
                          onChange: handleSignupDisable(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '필수 항목입니다';
                            } else if (value.length != 6) {
                              return '인증번호는 정확히 6글자여야 합니다.';
                            }
                            return null;
                          },
                          width: 220,
                          controller: _userVerificationNumber,
                          isNumber: true,
                        ),
                        //인증번호 넣어주는 로직 - certification
                        _authenticationBtn(context, '인증번호 확인', () {
                          checkCertification(
                            _userPhoneNumber,
                            _userVerificationNumber,
                            handleCheckCertification,
                          );
                        }),
                      ],
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
        isDisabled: _isButtonDisabled,
      ),
    );
  }

  Future<void> idDupliCheck(
      BuildContext context, Function handledupCheck) async {
    final id = _userId.text;
    try {
      var response = await dio.get(
        'http://j9c207.p.ssafy.io:8000/member-service/api/id/${id}',
      );
      var jsonResponse = json.decode(response.toString()); // 문자열로 변환 후 JSON 파싱
      print(jsonResponse);
      print('${jsonResponse['resultStatus']}, jsonresponse');
      if (jsonResponse['resultStatus']['successCode'] == 0) {
        handledupCheck(jsonResponse['resultBody']);
        handleIsIdDupChecked(true); // 아이디 중복 아님
      } else {
        handledupCheck(jsonResponse['resultStatus']['resultMessage']);
        handleIsIdDupChecked(false);
      }
    } catch (err) {
      handledupCheck(
          '아이디 양식을 지켜주세요. \n 아이디는 5~20자 사이로, 영어와 숫자가 최소 한 개씩 들어가야 합니다.');
    }
  }

// 인증 번호 받기 로직
  Future<void> checkVerification(
      phone, Function handleCheckVerification) async {
    final data = {
      'phone': phone.text,
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

  // 유저가 넣어준 인증번호 판별하기
  Future<void> checkCertification(
      phone, certification, Function handleCheckCertification) async {
    final data = {
      'phone': phone.text,
      'certification': certification.text,
    };
    print(data);
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/api/phone-check',
        data: data,
      );
      var jsonResponse = json.decode(response.toString());
      print(jsonResponse);
      if (jsonResponse['resultStatus']['successCode'] == 0) {
        handleCheckCertification(jsonResponse['resultBody']);

        handleIsVerificationChecked(true);
      } else {
        handleCheckCertification(jsonResponse['resultStatus']['resultMessage']);
        handleIsVerificationChecked(false);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> signUp(BuildContext context) async {
    print('회원가입 함수까지 옵니다.');
    final data = {
      'loginId': _userId.text,
      'loginPw': _userPw.text,
      'name': _userName.text,
      'phone': _userPhoneNumber.text,
      'birth': _userBirth.text
    };
    print('유효성 검사 통과 kk');
    BuildContext currentContext = context;
    print(data);
    try {
      var response = await dio.post(
        'http://j9c207.p.ssafy.io:8000/member-service/api/join/parent',
        data: data,
      );
      print(response);
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
    // }
  }
}

Widget _authenticationBtn(
  BuildContext context,
  String title,
  Function function,
) {
  return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10),
      child: ElevatedButton(
        onPressed: () async {
          function();
        },
        style: _authenticationBtnStyle(),
        child: Text(title),
      ));
}

ButtonStyle _authenticationBtnStyle() {
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
