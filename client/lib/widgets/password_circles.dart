import 'package:flutter/material.dart';

Widget passwordCircles(int inputLen) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _passwordCircle(1, inputLen),
          _passwordCircle(2, inputLen),
          _passwordCircle(3, inputLen),
          _passwordCircle(4, inputLen),
          _passwordCircle(5, inputLen),
          _passwordCircle(6, inputLen),
        ],
      ),
    ),
  );
}

Widget _passwordCircle(int order, int inputLen) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: order > inputLen ? Colors.black26 : const Color(0xFF8320E7),
      ),
    ),
  );
}