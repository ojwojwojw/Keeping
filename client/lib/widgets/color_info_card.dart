import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';

class ColorInfoCard extends StatefulWidget {
  ColorInfoCard({
    super.key,
  });

  @override
  State<ColorInfoCard> createState() => _ColorInfoCardState();
}

class _ColorInfoCardState extends State<ColorInfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          width: 360,
          height: 120,
          decoration: roundedBoxWithShadowStyle(borderRadius: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                _requestStatus(),
                _requestContent(),
              ],
            ),
          ) 
        ),
      ),
    );
  }
}

Widget _requestStatus() {
  return Container(
    width: 360,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFFFDDDD)
    ),
    child: Text('부탁 거절', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
  );
}

Widget _requestContent() {
  return Container();
}