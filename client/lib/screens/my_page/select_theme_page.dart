import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/screens/my_page/widgets/color_theme.dart';

class SelectThemePage extends StatelessWidget {
  const SelectThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(text: '테마 변경', elementColor: Colors.black),
          Row(
            children: [
              ColorTheme(
                colorName: '핑크',
                backgroundColor: Colors.pink[100]!,
              ),
              ColorTheme(
                colorName: '하늘',
                backgroundColor: Colors.blue[100]!,
              ),
            ],
          ),
          Row(
            children: [
              ColorTheme(
                colorName: '노랑',
                backgroundColor: Colors.yellow[100]!,
              ),
              ColorTheme(
                colorName: '연두',
                backgroundColor: Colors.green[100]!,
              ),
            ],
          )
        ],
      ),
    );
  }
}
