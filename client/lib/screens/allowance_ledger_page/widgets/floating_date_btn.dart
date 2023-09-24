import 'package:flutter/material.dart';

// 자녀 소비경로 페이지에서 날짜를 넘길 수 있는 버튼
class FloatingDateBtn extends StatelessWidget {

  FloatingDateBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      child: Container(
        width: 170,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 그림자 색상
              spreadRadius: 2, // 그림자 전파 반경
              blurRadius: 5, // 그림자 흐림 반경
              offset: Offset(0, 2), // 그림자의 X, Y 오프셋
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.arrow_left, size: 35),
            Text('12월 23일', style: TextStyle(fontSize: 20)),
            Icon(Icons.arrow_right, size: 35,),
          ],
        ),
      ),
    );
  }
}