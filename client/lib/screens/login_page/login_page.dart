import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';

import 'package:dio/dio.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';

TextEditingController _userId = TextEditingController();
TextEditingController _userPw = TextEditingController();
Dio dio = Dio();
final _loginKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _loginResult = '로그인 안 된 상태';
  String _loginId = '';
  String _loginPw = '';

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

  handleLogin(result) {
    setState(() {
      _loginResult = result;
    });
  }

  @override
  //페이지를 초기에 접속하면 input 받는 컨트롤러 초기화
  void initState() {
    super.initState();
    _userId = TextEditingController();
    _userPw = TextEditingController();
  }

  // 페이지가 파기될 때 컨트롤러를 해제
  @override
  void dispose() {
    _userId.dispose();
    _userPw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '로그인',
        elementColor: Colors.black,
        icon: Icon(Icons.arrow_circle_up),
        path: LoginPage(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 20,
                    ),
                    renderTextFormField(
                      label: '아이디',
                      onChange: (val) {
                        String userId = val;
                        handleUserId(userId);
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                      controller: _userId,
                    ),
                    Container(
                      height: 20,
                    ),
                    renderTextFormField(
                      label: '비밀번호',
                      onChange: (val) {
                        String userPw = val;
                        handleUserPw(userPw);
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                      controller: _userPw,
                      isPassword: true,
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(_loginResult),
                  ],
                ),
              ),

              //로그인 버튼
              ConfirmBtn(
                text: '로그인',
                action: () {
                  login(context, handleLogin);
                },
              ),
              Container(
                height: 20,
              ),
              //회원가입 버튼
              ConfirmBtn(
                text: '회원가입',
                action: SignUpPage(),
                textColor: const Color(0xFF8320E7),
                bgColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(context, Function handleLogin) async {
    final data = {
      'loginId': _loginId,
      'loginPw': _loginPw,
    };

    try {
      print(data);
      var response = await dio.post(
        'http://52.79.255.94:8000/member-service/login',
        data: data,
      );
      String fcmToken = Provider.of<UserInfoProvider>(context, listen: false)
          .fcmToken; // fcmToken 가져오기
      print(fcmToken);

      if (response.statusCode == 200) {
        // 로그인에 성공한 경우
        print('로그인에 성공했어요!');

        String? token = response.headers.value('token');
        String? memberKey = response.headers.value('memberKey');
        print('$token, $memberKey');
        // 나머지 처리 코드 추가
        handleLogin('로그인 성공');
        await requestUserInfo(memberKey, token, fcmToken,
            Provider.of<UserInfoProvider>(context, listen: false));
        Provider.of<UserInfoProvider>(context, listen: false)
            .updateTokenMemberKey(
          accessToken: token,
          memberKey: memberKey,
        );
      } else {
        // 로그인에 실패한 경우
        print('로그인에 실패!');
        handleLogin('아이디 및 비밀번호를 확인해주세요.');
      }
    } catch (err) {
      print(err);
      handleLogin('아이디 및 비밀번호를 확인해주세요.');
    }
  }

  Future<void> requestUserInfo(
    memberKey,
    accessToken,
    fcmToken,
    UserInfoProvider userInfoProvider,
  ) async {
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $accessToken', // 토큰 추가
      },
    );
    print('멤버 키: $memberKey, fcm : $fcmToken, aT: $accessToken');
    print('토큰');
    try {
      var response = await dio.get(
        'http://52.79.255.94:8000/member-service/auth/api/$memberKey/login-check/$fcmToken', // fcmToken 사용
        options: options,
      );
      Map<String, dynamic> jsonResponse = json.decode(response.toString());
      print(response);
      String? _name = jsonResponse['resultBody']['name'];
      String? _profileImage = jsonResponse['resultBody']['profileImage'];
      dynamic childrenListData = jsonResponse['resultBody']['childrenList'];
      List<Map<String, dynamic>> _childrenList = [];

      // childrenList가 null이 아니면 파싱하여 _childrenList에 할당
      if (childrenListData != null) {
        if (childrenListData is List<Map<String, dynamic>>) {
          _childrenList = List<Map<String, dynamic>>.from(childrenListData);
        }
      }

      bool? _parent = jsonResponse['resultBody']['parent'];
      print('$_name, $_profileImage, $_childrenList, $_parent');

      userInfoProvider.updateUserInfo(
        name: _name,
        profileImage: _profileImage,
        childrenList: _childrenList,
        parent: _parent,
      );
    } catch (err) {
      print(err);
    }
  }
}
