import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class ChildPushNotificationPage extends StatefulWidget {
  const ChildPushNotificationPage({super.key});

  @override
  State<ChildPushNotificationPage> createState() =>
      _ChildPushNotificationPageState();
}

class _ChildPushNotificationPageState extends State<ChildPushNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '알림'),
      body: SingleChildScrollView(),
    );
    // return const Placeholder();
  }
}
