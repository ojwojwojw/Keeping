import 'package:flutter/material.dart';
import 'package:keeping/screens/user_link_page/util/render_my_number.dart';
import 'package:keeping/screens/user_link_page/util/render_who_try_link.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/provider/user_link.dart';

TextEditingController _oppCode = TextEditingController();

class BeforeUserLinkPage extends StatefulWidget {
  const BeforeUserLinkPage({super.key});

  @override
  State<BeforeUserLinkPage> createState() => _UserLinkPageState();
}

class _UserLinkPageState extends State<BeforeUserLinkPage> {
  String _linkErrMsg = '';
  String _whoLinkMsg = '';
  Future<String>? _userCode; // 사용자 코드를 가져오는 Future

  @override
  void initState() {
    super.initState();
    _oppCode = TextEditingController(); // 컨트롤러 초기화

    // 페이지가 생성될 때 사용자 코드를 가져오는 Future를 초기화
    bool isParent =
        Provider.of<UserInfoProvider>(context, listen: false).parent;
    _userCode = renderMyNumber(context, isParent);

    // 사용자 코드를 가져온 후 누가 연결을 시도하는지 가져오도록 초기화
    _whoTryLink(context);
  }

  handleLinkErrMsg(result) {
    setState(() {
      _linkErrMsg = result;
    });
  }

  _whoTryLink(BuildContext context) async {
    final userCode = await _userCode; // 사용자 코드 가져오기 (위젯 상태 변수를 사용)

    // 데이터 가져오기 (예시: renderWhoTryLink 함수)
    final whoTryLink = await renderWhoTryLink(context, userCode);

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
                  return CircularProgressIndicator(); // 데이터를 기다리는 동안 표시할 내용 (로딩 스피너 예시)
                } else if (snapshot.hasError) {
                  return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
                } else {
                  final userCode = snapshot.data;
                  if (userCode != null && userCode.isNotEmpty) {
                    // 사용자 코드를 가져온 경우 표시
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
      bottomNavigationBar: BottomAppBar(),
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
        onChange: (dynamic newValue) {
          Provider.of<UserLinkProvider>(context, listen: false)
              .updateUserCode(oppCode: _oppCode.text);
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
    String accessToken =
        Provider.of<UserInfoProvider>(context, listen: false).accessToken;
    String memberKey =
        Provider.of<UserInfoProvider>(context, listen: false).memberKey;
    bool isParent =
        Provider.of<UserInfoProvider>(context, listen: false).parent;
    String oppCode =
        Provider.of<UserLinkProvider>(context, listen: false).oppCode;
    print('$accessToken, $memberKey, $oppCode');
    String url = isParent
        ? '/member-service/auth/api/$memberKey/parent/link/$oppCode'
        : '/member-service/auth/api/$memberKey/child/link/$oppCode';
    // 비동기 작업 수행
    if (oppCode == '' || oppCode.isEmpty) {
      handleLinkErrMsg('상대방 코드를 입력해주세요.');
    } else {
      final response = await dioPost(
        accessToken: accessToken,
        url: url,
      );
      print(response);

      if (response != null) {
        if (response['resultStatus']['resultMessage'] == '일치하는 인증번호가 없습니다.') {
          // 인증번호 오류
          handleLinkErrMsg(response['resultStatus']['resultMessage']);
        } else if (response['resultStatus']['successCode'] == 0) {
          // 연결된 상황
          final partner = response['resultBody']['partner'];
          // ignore: use_build_context_synchronously
          bottomModal(
            context: context,
            title: '연결 완료',
            content: Text('$partner님과 연결되었습니다!'), // Text 위젯으로 감싸기
            // ignore: use_build_context_synchronously
            button: linkAcceptedBtn(context),
          );
        } else {
          // 다음 단계
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AfterUserLinkPage()),
          );
        }
      } else {
        // response가 null인 경우 처리
        handleLinkErrMsg('서버에서 응답을 받지 못했습니다.');
      }
    }
  }

  Widget linkAcceptedBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7),
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
