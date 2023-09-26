import 'package:flutter/material.dart';

class ChildTag extends StatelessWidget {
  final String childName;
  final String text;

  ChildTag({
    super.key,
    required this.childName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: _childTagStyle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text('$childName $text', style: TextStyle(fontSize: 18, color: Colors.white),),
        )
      ),
    );
  }
}

BoxDecoration _childTagStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(50.0), // 둥근 테두리 반경 설정
    border: Border.all(
      color: Colors.white, // 테두리 색상 설정
      width: 1.0, // 테두리 두께 설정
    ),
  );
}