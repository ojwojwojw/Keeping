import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class ChildManagementPage extends StatefulWidget {
  const ChildManagementPage({super.key});

  @override
  State<ChildManagementPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<ChildManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '자녀 관리', elementColor: Colors.black),
        ],
      ),
    );
  }
}
