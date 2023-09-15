import 'package:flutter/material.dart';

class NicknameDuplicateButton extends StatelessWidget {
  final VoidCallback onPressed; // 클릭 이벤트를 위한 콜백 함수

  const NicknameDuplicateButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // 클릭 이벤트 콜백을 연결
      child: Container(
        width: 150,
        height: 70,
        color: const Color.fromARGB(255, 159, 33, 243),
        child: Center(
          child: Text(
            '중복 확인',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
