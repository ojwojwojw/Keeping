import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key});

  @override
  State<UserManagementPage> createState() => UserManagementPageState();
}

class UserManagementPageState extends State<UserManagementPage> {
  List<Map<String, dynamic>> _childrenList = [];

  @override
  void initState() {
    super.initState();
    _childrenList = context.read<UserInfoProvider>().childrenList;
    print(_childrenList);
    print('칠드런리스트');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '유저 연결 관리', elementColor: Colors.black),
      body: GestureDetector(
        onTap: () {
          // UserLinkPage로 이동하는 코드를 추가합니다.
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BeforeUserLinkPage(), // UserLinkPage로 이동하는 부분
          ));
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration:roundedBoxWithShadowStyle(),
          child: Text('연결 추가하기', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
