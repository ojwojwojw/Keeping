import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class PhonenumEditPage extends StatefulWidget {
  const PhonenumEditPage({super.key});

  @override
  State<PhonenumEditPage> createState() => _PrivacyEditPageState();
}

class _PrivacyEditPageState extends State<PhonenumEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '휴대폰 번호 변경', elementColor: Colors.black),
        ],
      ),
    );
  }
}
