// 애니메이션 효과 없이 다음 페이지로 이동하는 함수
import 'package:flutter/material.dart';

void noEffectTransition(BuildContext context, Widget path) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        return path; //변경 필요
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    )
  );
}