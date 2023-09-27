import 'package:flutter/material.dart';
import 'package:keeping/screens/user_link_page/util/render_my_number.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
import 'package:keeping/screens/user_link_page/widgets/main_description_text.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

TextEditingController _oppCode = TextEditingController();

class BeforeUserLinkPage extends StatefulWidget {
  const BeforeUserLinkPage({super.key});

  @override
  State<BeforeUserLinkPage> createState() => _UserLinkPageState();
}

class _UserLinkPageState extends State<BeforeUserLinkPage> {
  Future<String>? _userCode; // 사용자 코드를 가져오는 Future

  @override
  void initState() {
    super.initState();
    // 페이지가 생성될 때 사용자 코드를 가져오는 Future를 초기화
    bool _isParent =
        Provider.of<UserInfoProvider>(context, listen: false).parent;
    _userCode = renderMyNumber(context, _isParent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyHeader(text: '연결하기', elementColor: Colors.black),
            MainDescriptionText('서로의 코드를 입력해주세요!'),
            Text('내 코드'),
            // FutureBuilder를 사용하여 사용자 코드를 화면에 표시
            FutureBuilder<String>(
              future: _userCode,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // 데이터를 기다리는 동안 표시할 내용
                } else if (snapshot.hasError) {
                  return Text('데이터를 가져오지 못했어요'); // 오류가 발생한 경우
                } else {
                  final userCode = snapshot.data;
                  if (userCode != null && userCode.isNotEmpty) {
                    // 사용자 코드를 가져온 경우 표시

                    return Text(userCode);
                  } else {
                    // 데이터가 없는 경우 빈 화면 또는 메시지 표시
                    return Text('사용자 코드가 없어요');
                  }
                }
              },
            ),
            Text('api로 받아올 코드'),
            Text('상대방 코드'),
            _opponentNumber(),
            ConfirmBtn(text: '연결하기', action: linkUser),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }

  // 상대방 코드를 넣어주는 필드
  _opponentNumber() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20), // 좌우 마진 설정
      child: renderTextFormField(
        label: '코드 입력',
        hintText: '전달받은 코드를 입력해주세요.',
        controller: _oppCode,
      ),
    );
  }

  void linkUser(BuildContext context) {
    print('유저 연결... $_oppCode');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AfterUserLinkPage()));
  }
}
