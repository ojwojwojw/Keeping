import 'package:flutter/material.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/user_link_page/util/render_my_number.dart';
import 'package:keeping/screens/user_link_page/util/render_who_try_link.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _baseUrl = dotenv.env['BASE_URL'];

TextEditingController _oppCode = TextEditingController();

class BeforeUserLinkPage extends StatefulWidget {
  final String linkcode;

  const BeforeUserLinkPage(this.linkcode, {Key? key}) : super(key: key);

  @override
  State<BeforeUserLinkPage> createState() => _UserLinkPageState();
}

class _UserLinkPageState extends State<BeforeUserLinkPage> {
  String _linkErrMsg = '';
  String _whoLinkMsg = '';
  String? _memberKey;
  String? _accessToken;
  String? oppCode;
  bool _isParent = true;
  Future<String>? _userCode; // 사용자 코드를 가져오는 Future

  @override
  void initState() {
    super.initState();
    _oppCode = TextEditingController(); // 컨트롤러 초기화
    _isParent = Provider.of<UserInfoProvider>(context, listen: false).parent;
    print('Received linkcode: ${widget.linkcode}');
    _userCode = Future.value(widget.linkcode); // 직접 받아온 linkcode 값을 사용
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    // 사용자 코드를 가져온 후 누가 연결을 시도하는지 가져오도록 초기화
    _whoTryLink(context);
  }

  handleLinkErrMsg(result) {
    setState(() {
      _linkErrMsg = result;
    });
  }

  handleOppCode(result) {
    print('상대 코드 변경 중 $result');
    setState(() {
      oppCode = result;
    });
  }

  _whoTryLink(BuildContext context) async {
    final userCode = await _userCode; // 사용자 코드 가져오기 (위젯 상태 변수를 사용)
    print('유저코드 초기화: $userCode');
    final whoTryLink = await renderWhoTryLink(context, userCode);
    print('네가 연결 중일까, 내가 연결 중일까? 결과는? $whoTryLink');
    setState(() {
      _whoLinkMsg = whoTryLink.isNotEmpty ? '$whoTryLink' : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyHeader(text: '연결하기', elementColor: Colors.black),
            MainDescriptionText('서로의 코드를 입력해주세요.'),
            FutureBuilder<String>(
              future: _userCode,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
                } else {
                  final userCode = snapshot.data;
                  if (userCode != null && userCode.isNotEmpty) {
                    return _myCode(userCode);
                  } else {
                    // 데이터가 없는 경우 빈 화면 또는 메시지 표시
                    return Text('사용자 코드를 받아올 수 없습니다.');
                  }
                }
              },
            ),
            _opponentNumber(),
            _whoLinkToUser(),
            _errMsg(),
            ConfirmBtn(
              text: '연결하기',
              action: () => linkUser(context),
            ),
          ],
        ),
      ),
      bottomSheet: BottomNav(),
    );
  }

  Widget _myCode(String userCode) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 60, 40, 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '내 코드',
                style: labelStyle(),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(userCode,
                  style: TextStyle(fontSize: 22, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _whoLinkToUser() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 40, 10),
      child: Text(
        _whoLinkMsg,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 상대방 코드를 넣어주는 필드
  Widget _opponentNumber() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 40, 10),
      child: renderTextFormField(
        label: '상대방 코드 입력',
        hintText: '전달받은 코드를 입력해주세요.',
        controller: _oppCode,
        onChange: (value) {
          handleOppCode(value);
        },
      ),
    );
  }

  Widget _errMsg() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 10, 40, 30),
      child: Text(
        _linkErrMsg,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> linkUser(BuildContext context) async {
    print('$_accessToken, $_memberKey, $oppCode');

    String url = _isParent
        ? '$_baseUrl/member-service/auth/api/$_memberKey/parent/link/$oppCode'
        : '$_baseUrl/member-service/auth/api/$_memberKey/child/link/$oppCode';

    // 비동기 작업 수행
    if (oppCode?.isEmpty ?? true) {
      handleLinkErrMsg('상대방 코드를 입력해주세요.');
    } else {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      print(jsonResponse);
      print('흐흐흐흐흐');

      if (jsonResponse != null) {
        if (jsonResponse['resultStatus']['resultMessage'] ==
            '일치하는 인증번호가 없습니다.') {
          // 인증번호 오류
          handleLinkErrMsg(jsonResponse['resultStatus']['resultMessage']);
        } else if (jsonResponse['resultStatus']['successCode'] == 0) {
          // 연결된 상황
          final partner = jsonResponse['resultBody']['partner'];
          // ignore: use_build_context_synchronously
          bottomModal(
            context: context,
            title: '연결 완료',
            content: Text(
              '$partner님과 연결되었습니다!',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ), // Text 위젯으로 감싸기
            button: linkAcceptedBtn(context, _isParent),
          );
        } else {
          // 다음 단계
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AfterUserLinkPage()),
          // );
          noEffectReplacementTransition(context, AfterUserLinkPage());
        }
      } else {
        // jsonResponse가 null인 경우 처리
        handleLinkErrMsg('서버에서 응답을 받지 못했습니다.');
      }
    }
  }

  Widget linkAcceptedBtn(BuildContext context, bool isParent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (isParent) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ParentMainPage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChildMainPage()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7),
            foregroundColor: Colors.white,
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // 모서리 둥글기 조절
            ),
            minimumSize: Size(200, 50), // 가로로 더 길게 조절
          ),
          child: Text('확인'),
        ),
      ],
    );
  }
}
