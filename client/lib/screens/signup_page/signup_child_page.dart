import 'package:flutter/material.dart';
import 'package:keeping/screens/login_page/login_page.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:keeping/widgets/render_field.dart';

Dio dio = Dio();

final _signupKey = GlobalKey<FormState>();

class SignUpChildPage extends StatefulWidget {
  const SignUpChildPage({Key? key}) : super(key: key);

  @override
  _SignUpChildPageState createState() => _SignUpChildPageState();
}

class _SignUpChildPageState extends State<SignUpChildPage> {
  TextEditingController _userId = TextEditingController();
  TextEditingController _userPw = TextEditingController();
  TextEditingController _userPwCk = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _userBirth = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();
  TextEditingController _userVerificationNumber = TextEditingController();
  TextEditingController _parentPhone = TextEditingController();
  TextEditingController _parentVerificationNumber = TextEditingController();

  String _idDupRes = '';
  String _verificationResult = ''; // 인증번호 송신 확인
  String _parentVerificationResult = '';
  String _certificationResult = ''; // 인증번호 확인
  String _parentCertificationResult = '';
  bool _isButtonDisabled = true;
  bool _isIdDupChecked = false; // 아이디 중복 체크 완료 여부(본인)
  bool _isVerificationChecked = false; //인증 번호 체크 완료 여부(본인)
  bool _isParentVerificationChecked = false; //인증 번호 체크 완료 여부(부모)
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
    _parentPhone = TextEditingController();
    _parentVerificationNumber = TextEditingController();
  }

  handleSignupDisable() {
    if (_isIdDupChecked &&
        _isVerificationChecked &&
        _isParentVerificationChecked &&
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
    print(result);
  }

  handleIsVerificationChecked(result) {
    _isVerificationChecked = result;
  }

  handleIsParentVerificationChecked(result) {
    _isParentVerificationChecked = result;
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

  handleCheckParentVerification(result) {
    setState(() {
      _parentVerificationResult = result;
    });
  }

  //인증번호 인증되었는지 확인하는 코드
  handleCheckCertification(result) {
    setState(() {
      _certificationResult = result;
    });
  }

  handleCheckParentCertification(result) {
    setState(() {
      _parentCertificationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '회원가입',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                            width: 210,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                            width: 200,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                          width: 200,
                          controller: _userVerificationNumber,
                        ),
                        //인증번호 넣어주는 로직 - certification
                        _authenticationBtn(context, '인증번호 확인', () {
                          checkCertification(
                            _userPhoneNumber,
                            _userVerificationNumber,
                            'child',
                            handleCheckCertification,
                          );
                        }),
                      ],
                    ),
                    Text(_certificationResult),
                    //부모님 인증
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        renderPhoneNumberFormField(
                          label: '부모님 휴대폰 번호',
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
                          width: 200,
                          controller: _parentPhone,
                        ),
                        _authenticationBtn(context, '인증번호 받기', () {
                          checkVerification(
                            _parentPhone,
                            handleCheckParentVerification,
                          );
                        }),
                      ],
                    ),
                    Text(_parentVerificationResult),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        renderTextFormField(
                          label: '부모님 인증번호 입력',
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
                          width: 200,
                          controller: _parentVerificationNumber,
                        ),
                        //인증번호 넣어주는 로직 - certification
                        _authenticationBtn(context, '인증번호 확인', () {
                          checkCertification(
                            _parentPhone,
                            _parentVerificationNumber,
                            'parent',
                            handleCheckParentCertification,
                          );
                        }),
                      ],
                    ),
                    Text(_parentCertificationResult),
                  ],
                ),
              ),
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
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
    print(id);
    final response = await dioGet(url: '/member-service/api/id/$id');
    print(response);
    if (id != '') {
      if (response['resultStatus']['successCode'] == 0) {
        handledupCheck(response['resultBody']);
        handleIsIdDupChecked(true); // 아이디 중복 아님
      } else {
        handledupCheck(response['resultStatus']['resultMessage']);
        handleIsIdDupChecked(false);
      }
    } else {
      handledupCheck('아이디는 5~20자 사이로,\n영어와 숫자가 최소 한 개씩 들어가야 합니다.');
    }
  }

// 인증 번호 받기 로직
  Future<void> checkVerification(
      phone, Function handleCheckVerification) async {
    final phoneText = phone.text;

    // 휴대폰 번호의 길이가 11자가 아닌 경우 에러 처리
    if (phoneText.length != 13) {
      handleCheckVerification('휴대폰 번호는 13자여야 합니다.');
      return; // 함수 종료
    }

    final data = {
      'phone': phoneText,
    };
    final response = await dioPost(
      url: '/member-service/api/phone',
      data: data,
    );
    print(response);
    if (response['resultStatus']['successCode'] == 0) {
      handleCheckVerification(response['resultBody']);
    } else if (response.data.resultStatus.successCode == 409) {
      handleCheckVerification(response['resultBody']);
    } else {
      handleCheckVerification('휴대폰 번호를 다시 확인해주세요');
    }
  }

  // 유저가 넣어준 인증번호 판별하기
  Future<void> checkCertification(
      phone, certification, userType, Function handleCheckCertification) async {
    final data = {
      'phone': phone.text,
      'certification': certification.text,
    };
    final certificationText = certification.text;
    final response = await dioPost(
      url: '/member-service/api/phone-check',
      data: data,
    );
    print('$response, $userType');
    if (certificationText.length != 6 || phone.text.length != 13) {
      if (userType == 'child') {
        handleIsVerificationChecked(false);
      } else {
        handleIsParentVerificationChecked(false);
      }
      handleCheckCertification('휴대폰 번호와 인증번호를 모두 입력해주세요.');
    } else {
      if (response['resultStatus']['successCode'] == 0) {
        handleCheckCertification(response['resultBody']);
        if (userType == 'child') {
          handleIsVerificationChecked(true);
        } else {
          handleIsParentVerificationChecked(true);
        }
        handleIsVerificationChecked(true);
      } else {
        handleCheckCertification(response['resultStatus']['resultMessage']);
        if (userType == 'child') {
          handleIsVerificationChecked(false);
        } else {
          handleIsParentVerificationChecked(false);
        }
      }
    }
  }

  Future<void> signUp(BuildContext context) async {
    final data = {
      'loginId': _userId.text,
      'loginPw': _userPw.text,
      'name': _userName.text,
      'phone': _userPhoneNumber.text,
      'parentPhone': _parentPhone.text,
      'birth': _userBirth.text
    };
    BuildContext currentContext = context;

    final response = await dioPost(
      url: '/member-service/api/join/child',
      data: data,
    );
    
    if (response['resultStatus']['successCode'] == 0) {
      handleIsParentVerificationChecked(true);
      noEffectTransition(context, LoginPage());
    } else if (response['resultStatus']['resultCode'] == 409) {
      print('이미 가입한 회원입니다.');
    } else {
      print('유효성 검사 실패');
    }
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
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )),
      minimumSize: MaterialStateProperty.all<Size>(Size(120, 40)));
}
