import 'package:flutter/material.dart';

class ValueInputTest extends StatefulWidget {
  @override
  _ValueInputTestState createState() => _ValueInputTestState();
}

class _ValueInputTestState extends State<ValueInputTest> {
  // final _formKey = GlobalKey<FormState>();

  // TextEditingController amountController = TextEditingController();
  late TextEditingController amountController;
  late ScrollController scrollController;  // 스크롤 컨트롤러 생성

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    scrollController = ScrollController();
  }

  renderInput() {
    String display = '보낼 금액';
    TextStyle style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    );

    return Container(
      width: double.infinity,
      child: Center(
        child: Text(
          display,
          style: style,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            renderInput()
          ],
        ),
      ),
    );
  }
}