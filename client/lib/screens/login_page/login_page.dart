import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/signup_page/signup_user_type_select_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';

import 'package:dio/dio.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _baseUrl = dotenv.env['BASE_URL'];
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
  String _loginResult = '';
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
    _loginResult = '';
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
      backgroundColor: Colors.white,  // 이 부분에 원하는 색상을 설정하세요.

      appBar: MyHeader(
        text: '로그인',
        elementColor: Colors.black,
        // icon: Icon(Icons.arrow_circle_up),
        // path: LoginPage(),
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
                      width: 300,
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
                      width: 300,
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
      var response = await dio.post(
        '$_baseUrl/member-service/login',
        data: data,
      );
      String fcmToken = Provider.of<UserInfoProvider>(context, listen: false)
          .fcmToken; // fcmToken 가져오기
      print(fcmToken);

      if (response.statusCode == 200) {
        // 로그인에 성공한 경우
        print('로그인에 성공했어요!');
        handleLogin('');
        String? token = response.headers.value('token');
        print(token);
        String? memberKey = response.headers.value('memberKey');
        print(memberKey);
        // 나머지 처리 코드 추가
        await requestUserInfo(memberKey, token, fcmToken,
            Provider.of<UserInfoProvider>(context, listen: false));
        Provider.of<UserInfoProvider>(context, listen: false)
            .updateTokenMemberKey(
          accessToken: token,
          memberKey: memberKey,
        );
        await renderingUserAccount(
          token,
          memberKey,
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

    try {
      var response = await dio.get(
        '$_baseUrl/member-service/auth/api/$memberKey/login-check/$fcmToken', // fcmToken 사용
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
        _childrenList = List<Map<String, dynamic>>.from(childrenListData);
      }

      bool? _parent = jsonResponse['resultBody']['parent'];

      if (_profileImage == null) {
        if (_parent != null) {
          if (_parent) {
            _profileImage = 'assets/image/profile/parent1.png';
          } else {
            _profileImage = 'assets/image/profile/child1.png';
          }
        } else {
          _profileImage = 'assets/image/profile/parent2';
        }
      }

      userInfoProvider.updateUserInfo(
        name: _name,
        profileImage: _profileImage,
        childrenList: _childrenList,
        parent: _parent,
      );
      print('Parent $_parent');
      if (_parent == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ParentMainPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ChildMainPage()));
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> renderingUserAccount(accessToken, memberKey) async {
    print('계좌정보, $memberKey, $accessToken');
    final response = await dioGet(
      url: '/bank-service/api/$memberKey/account/$memberKey',
      accessToken: accessToken,
    );
    print('로그인 후 저장할래요 $response');
    if (response != null) {
      // 계좌 있는 경우
      print(response['resultBody']);
      if (response['resultStatus']['successCode'] == 0) {
        String accountNumber = response['resultBody']['accountNumber'];
        int balance = response['resultBody']['balance'];

        dynamic accountInfo = {
          'accountNumber': accountNumber,
          'balance': balance,
        };
        print('프로바이더에 넣어볼 것 $accountInfo');
        Provider.of<AccountInfoProvider>(context, listen: false)
            .setAccountInfo(accountInfo);
      }
    }
  }
}
