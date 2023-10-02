import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class ChildManagementPage extends StatefulWidget {
  const ChildManagementPage({Key? key});

  @override
  State<ChildManagementPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<ChildManagementPage> {
  List<Map<String, dynamic>> _childrenList = [];

  @override
  void initState() {
    super.initState();
    _childrenList = context.read<UserInfoProvider>().childrenList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '자녀 관리', elementColor: Colors.black),
      body: Column(
        children: [],
      ),
    );
  }
}
