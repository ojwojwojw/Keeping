import 'package:flutter/material.dart';
import 'package:keeping/screens/my_page/child_management_page.dart';
import 'package:keeping/screens/my_page/util/handle_logout.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/my_page/password_edit_page.dart';
import 'package:keeping/screens/my_page/phonenum_edit_page.dart';

import 'package:keeping/widgets/bottom_modal.dart';

class ChildMyPage extends StatelessWidget {
  const ChildMyPage({Key? key}) : super(key: key);
  final name = 'Child';

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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserManagementPage()));
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
      appBar: MyHeader(text: '마이페이지', elementColor: Colors.black),
      body: Center(
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
                '유저 연결 관리',
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
      bottomNavigationBar: BottomNav(
        myPage: true,
      ),
    );
  }

  Widget userInfoBox() {
    return Center(
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 185, 185, 185), // 테두리 색상
            width: 2.0, // 테두리 두께
          ),
          borderRadius: BorderRadius.circular(10.0), // 모서리 반경
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/image/temp_image.jpg',
              width: 100.0,
              height: 100.0,
            ),
            Text('$name 님'),
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
            Navigator.of(context).pop();
            handlelogout();
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
            handlelogout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7), // 배경색 설정
          ),
          child: Text('확인'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            handlelogout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7), // 배경색 설정
          ),
          child: Text('취소'),
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
          MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )),
      fixedSize: MaterialStateProperty.all<Size>(Size(300, 50)));
}
