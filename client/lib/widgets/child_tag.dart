import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

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
      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$childName $text', style: TextStyle(color: const Color.fromARGB(255, 105, 105, 105)),),
          SizedBox(width: 4,),
          Icon(Icons.arrow_forward_ios_rounded, size: 10, color: const Color.fromARGB(255, 105, 105, 105),)
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 10),
    //   child: Container(
    //     decoration: roundedBoxWithShadowStyle(
    //       shadow: false,
    //       borderRadius: 50,
    //       bgColor: Color.fromARGB(255, 247, 208, 91)
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    //       child: Text('$childName $text', style: TextStyle(fontSize: 18, color: Colors.white),),
    //     )
    //   ),
    // );
  }
}

BoxDecoration _childTagStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(50.0), // 둥근 테두리 반경 설정
    
  );
}