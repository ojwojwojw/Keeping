import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class ParentPushNotification extends StatefulWidget {
  const ParentPushNotification({super.key});

  @override
  State<ParentPushNotification> createState() => _ParentPushNotificationState();
}

class _ParentPushNotificationState extends State<ParentPushNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '부모알림'),
      body: SingleChildScrollView(),
    );
  }
}
