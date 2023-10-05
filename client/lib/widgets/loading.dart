import 'package:flutter/material.dart';

Widget empty({required String text, double size = 200}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/main/empty.png', width: size,),
          Text(text),
        ],
      ),
    ),
  );
}

Widget loading() {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        CircularProgressIndicator()
      ],
    ),
  );
}