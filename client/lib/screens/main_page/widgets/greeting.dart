import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

class ChildGreeting extends StatelessWidget {
  final String name;

  ChildGreeting({
    super.key,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          roundedAssetImg(imgPath: 'assets/image/temp_image.jpg', size: 64),
          SizedBox(width: 12,),
          Row(
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text('님, 안녕하세요!', style: TextStyle(fontSize: 20),)
            ],
          )
        ],
      ),
    );
  }
}

class ParentGreeting extends StatelessWidget {
  final String name;
  final String? childName;

  ParentGreeting({
    super.key,
    required this.name,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          roundedAssetImg(imgPath: 'assets/image/temp_image.jpg', size: 64),
          SizedBox(width: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('안녕하세요, ', style: TextStyle(fontSize: 20),),
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Text('님', style: TextStyle(fontSize: 20),),
                ],
              ),
              childName == null ?
                Text('자녀와 연결 후 이용가능합니다.', style: TextStyle(fontSize: 20),)
                : Row(
                  children: [
                    Text(childName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Text('의 홈입니다.', style: TextStyle(fontSize: 20),)
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }
}