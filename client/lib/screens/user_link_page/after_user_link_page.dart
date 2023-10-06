import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/files.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/main_page/child_main_page.dart';
import 'package:keeping/screens/main_page/main_page.dart';
import 'package:keeping/screens/main_page/parent_main_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _baseUrl = dotenv.env['BASE_URL'];

class AfterUserLinkPage extends StatefulWidget {
  const AfterUserLinkPage({super.key});

  @override
  State<AfterUserLinkPage> createState() => _AfterUserLinkPageState();
}

class _AfterUserLinkPageState extends State<AfterUserLinkPage> {
  int _remainingTime = 0; // 초기 남은 시간을 null로 설정
  late Timer _timer; // 타이머 변수
  String? _myCode;
  String? _memberKey;
  String? _accessToken;
  bool _parent = true;

  @override
  void initState() {
    super.initState();
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _parent = context.read<UserInfoProvider>().parent;
    renderExpireTime(context).then((expireTime) {
      setState(() {
        _remainingTime = expireTime;
      });
      _startTimer(); // 타이머 시작
    });
  }

  // renderExpireTime 메서드 수정 예
  Future<int> renderExpireTime(BuildContext context) async {
    String _url = _parent
        ? '$_baseUrl/member-service/auth/api/$_memberKey/parent/linkcode'
        : '$_baseUrl/member-service/auth/api/$_memberKey/child/linkcode';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };
    try {
      final response = await http.get(Uri.parse(_url), headers: headers);
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      print(jsonResponse);
      if (jsonResponse['resultStatus']['successCode'] == 0) {
        print('코드가 유효합니다. 시간을 조회해봅시다.');
        _myCode = jsonResponse['resultBody']['linkcode'];
        _remainingTime = jsonResponse['resultBody']['expire'];
        return _remainingTime;
      } else {
        roundedModal(
            context: context,
            title: '코드가 만료되었습니다.\n코드를 재생성합니다.',
            firstAction: () {
              _handleUserLink(
                  accessToken: _accessToken,
                  memberKey: _memberKey,
                  context: context,
                  parent: _parent);
            });
        // noEffectTransition(context, path)

        return 0; // 예를 들어, 0을 반환한다고 가정하면:
      }
    } catch (err) {
      roundedModal(context: context, title: '잠시 후 다시 시도해주세요.');
      print(err);
      return 0; // 예를 들어, 0을 반환한다고 가정하면:
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // 페이지가 dispose될 때 타이머를 취소합니다.
    super.dispose();
  }

  // 타이머 시작 메서드
  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      // 1초마다 실행되는 코드
      if (_remainingTime! > 0) {
        setState(() {
          _remainingTime = _remainingTime! - 1;
        });
      } else {
        timer.cancel(); // 남은 시간이 0 이하로 떨어지면 타이머를 취소합니다.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isParent = _parent ?? false;
    return Scaffold(
      appBar: MyHeader(
        text: '연결하기',
        elementColor: Colors.black,
        backPath: isParent ? ParentMainPage() : ChildMainPage(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainDescriptionText('상대방의 연결을 기다리는 중입니다!'),
            Column(
              children: [
                watingOpponent(),
                timer(),
                if (_myCode != null) myCodeWidget(),
                ConfirmBtn(
                  text: '상대방에게 알려주기',
                  action: () => noticeToUser(_myCode),
                ),
                doNotice(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myCodeWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        '내 연결 코드 $_myCode',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timer() {
    if (_remainingTime == null) {
      // _remainingTime이 null인 경우 처리
      return CircularProgressIndicator();
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
        child: Text(
          formatSecondsToHHMMSS(_remainingTime!),
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8320E7)),
        ),
      );
    }
  }
}

String formatSecondsToHHMMSS(int seconds) {
  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$remainingSeconds';
}

watingOpponent() {
  return Container(
    margin: EdgeInsets.all(16),
    child: Text(
      '연결까지 남은 시간',
      style: TextStyle(color: const Color(0xFF8320E7), fontSize: 20),
    ),
  );
}

doNotice() {
  return Container(
    margin: EdgeInsets.only(top: 25.0),
    child: Text(
      '남은 시간 안에 상대방도 연결을 완료해야 \n 계정 연결이 완료됩니다. \n 연결 신청한 사실을 상대방에게 알려주세요!',
      textAlign: TextAlign.center, // 가운데 정렬 설정
      style: TextStyle(color: Colors.grey[700]),
    ),
  );
}

noticeToUser(String? content) {
  print('알려주는 중');
  if (content != null) {
    Clipboard.setData(ClipboardData(text: content));
    Fluttertoast.showToast(
      msg: '복사되었습니다.',
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

void _handleUserLink(
    {required BuildContext context,
    required String? accessToken,
    required String? memberKey,
    required bool parent}) async {
  print('생성하시오');
  if (accessToken == null || memberKey == null) return;

  String _url = parent?
      '$_baseUrl/member-service/auth/api/$memberKey/parent/linkcode':
      '$_baseUrl/member-service/auth/api/$memberKey/child/linkcode';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken'
  };
  try {
    final response = await http.post(Uri.parse(_url), headers: headers);
    Map<String, dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
    print(jsonResponse);
    // 코드를 생성한 후 이동합니다.
    if (jsonResponse['resultStatus']['successCode'] == 0) {
      String linkcode = jsonResponse['resultBody']['linkcode'];
      noEffectTransition(context, BeforeUserLinkPage(linkcode));
    } else if (jsonResponse['resultStatus']['resultCode'] == "400") {
      String returnMsg = jsonResponse['resultStatus']['resultMessage'];
      roundedModal(context: context, title: returnMsg);
      print('Request failed with status: ${response.statusCode}.');
    } else if (jsonResponse['resultStatus']['resultCode'] == "404") {
      String returnMsg = jsonResponse['resultStatus']['resultMessage'];
      roundedModal(context: context, title: returnMsg);
    } else {
      roundedModal(context: context, title: '잠시 후 시도해주세요.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
