import 'package:flutter/material.dart';

class TabProfile extends StatelessWidget {
  final String imgPath;
  final String name;

  TabProfile({
    super.key,
    required  this.imgPath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        ClipOval(
          child: SizedBox(
            width: 60,
            height: 60,
            child: Image.asset(
              imgPath,
              fit: BoxFit.cover
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 20),),
      ],
    );
  }
}