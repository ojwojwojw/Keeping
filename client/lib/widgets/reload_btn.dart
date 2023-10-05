import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

Widget reloadBtn(reload) {
  return SizedBox(
    width: 35,
    height: 35,
    child: InkWell(
      onTap: () {
        reload();
      },
      child: Center(
        child: Container(
          width: 25,
          height: 25,
          decoration: roundedBoxWithShadowStyle(
            borderRadius: 100,
            blurRadius: 1,
          ),
          child: Icon(Icons.refresh_rounded, size: 20, color: Color.fromARGB(255, 192, 192, 192),),
        ),
      ),
    ),
  );
}