import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

class SelectOCRTextPage extends StatelessWidget {
  List<dynamic>? textList;

  SelectOCRTextPage({
    super.key,
    required this.textList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '상세 내용 입력',
      ),
      body: Container(
        child: Text(textList.toString(), style: TextStyle(fontSize: 10),),
      ),
    );
  }
}