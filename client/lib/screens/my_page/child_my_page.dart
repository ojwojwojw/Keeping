import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/login_page/login_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/my_page/password_edit_page.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';

import 'package:keeping/widgets/bottom_modal.dart';
import 'package:provider/provider.dart';

class ChildMyPage extends StatefulWidget {
  const ChildMyPage({Key? key}) : super(key: key);

  @override
  _ChildMyPageState createState() => _ChildMyPageState();
}

class _ChildMyPageState extends State<ChildMyPage> {
  String? _name;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _name = context.read<UserInfoProvider>().name;
    profileImage = context.read<UserInfoProvider>().profileImage;
  }

  void gotoEditPwd(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PasswordEditPage()));
  }

  void gotoEditPhone(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhonenumEditPage()));
  }

  void logout(BuildContext context) {
    showLogoutConfirmationDialog(context);
  }

  void handleUserLink(BuildContext context) {
    
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BeforeUserLinkPage(), // UserLinkPage로 이동하는 부분
    ));
  }

// 로그아웃 모달 다이얼로그
  void showLogoutConfirmationDialog(BuildContext context) {
    bottomModal(
      context: context,
      title: '로그아웃',
      content: logoutDescription(),
      button: logoutBtn(context),
    );
  }

  void showDeleteAccountConfirmationDialog(BuildContext context) {
    bottomModal(
      context: context,
      title: '회원 탈퇴',
      content: deleteAccountDescription(),
      button: deleteAccountBtn(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '마이페이지',
        elementColor: Colors.black,
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView 추가
        child: Center(
          // 화면 가운데 정렬
          child: Container(
            width: 300,
            child: Column(
              children: [
                userInfoBox(),
                _MyPageDetailedFunctionPage(
                  context,
                  '비밀번호 변경',
                  () => gotoEditPwd(context),
                ),
                _MyPageDetailedFunctionPage(
                  context,
                  '휴대폰 번호 변경',
                  () => gotoEditPhone(context),
                ),
                _MyPageDetailedFunctionPage(
                  context,
                  '유저 연결하기',
                  () => handleUserLink(context),
                ),
                _MyPageDetailedFunctionPage(
                  context,
                  '로그아웃',
                  () => logout(context),
                ),
                SizedBox(
                  height: 10,
                ),
                _deleteAccount(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        myPage: true,
      ),
    );
  }

  Widget userInfoBox() {
    return Center(
      child: Container(
        width: 300,
        height: 120,
        decoration: roundedBoxWithShadowStyle(),
        padding: EdgeInsets.all(15.0), // 모든 방향에 간격을 줍니다.
        child: Row(
          children: [
            roundedAssetImg(
                imgPath: profileImage ?? 'assets/image/profile/child1.png',
                size: 64),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                Row(children: [
                  Text('$_name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('님,', style: TextStyle(fontSize: 20)),
                ]),
                Text('안녕하세요💞', style: TextStyle(fontSize: 17))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget logoutBtnModal(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          bottomModal(
            context: context,
            title: '로그아웃',
            content: logoutDescription(),
            button: logoutBtn(context),
          );
        },
        child: Text('로그아웃'));
  }

  Row logoutBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7), // 배경색 설정
          ),
          child: Text('네'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7),
          ),
          child: Text('아니오'),
        ),
      ],
    );
  }

  Widget logoutDescription() {
    return Text('정말 로그아웃 하시겠어요?');
  }

  Widget _deleteAccount(BuildContext buildContext) {
    return Row(
      // Row로 감싸서 좌측 정렬
      children: [
        TextButton(
          onPressed: () {
            showDeleteAccountConfirmationDialog(buildContext);
          },
          child: Text(
            '회원 탈퇴',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 20), // 좌측 버튼과 간격 추가
      ],
    );
  }

  Widget deleteAccountDescription() {
    return Text('정말 회원 탈퇴 하시겠어요?');
  }

  Row deleteAccountBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7), // 배경색 설정
          ),
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            noEffectTransition(context, LoginPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7), // 배경색 설정
          ),
          child: Text(
            '취소',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

Widget _MyPageDetailedFunctionPage(
  BuildContext context,
  String title,
  Function function,
) {
  return Padding(
      padding: EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () async {
          function();
        },
        style: _detailFunctionBtnStyle(),
        child: Text(title),
      ));
}

ButtonStyle _detailFunctionBtnStyle() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 39, 39, 39)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Color.fromARGB(255, 207, 207, 207), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )),
      fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)));
}
