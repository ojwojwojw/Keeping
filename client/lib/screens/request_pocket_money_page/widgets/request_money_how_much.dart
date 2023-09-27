import 'package:flutter/material.dart';
import 'package:keeping/widgets/render_field.dart';

Widget requestMoneyHowMuch() {
  return Container(
    child: Column(
      children: [
        // Text('얼마를 조를까요?'),
        renderTextFormField(label: '얼마를 조를까요?')
      ],
    ),
  );
}
