import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({super.key});

  @override
  State<PasswordEditPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<PasswordEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '비밀번호 변경', elementColor: Colors.black),
        ],
      ),
    );
  }
}
