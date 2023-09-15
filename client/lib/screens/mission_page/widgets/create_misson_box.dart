import 'package:flutter/material.dart';

class CreateMissonBox extends StatelessWidget {
  const CreateMissonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        width: 400,
        height: 200,
        color: Colors.blue,
        child: (Center(
          child: Text('미션생성하기!!',
              style: TextStyle(color: Colors.white, fontSize: 24)),
        )));
  }
}
