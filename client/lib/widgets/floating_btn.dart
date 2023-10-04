import 'package:flutter/material.dart';

class FloatingBtn extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget path;
  final Color bgColor;
  final Color elementColor;

  FloatingBtn({
    super.key,
    required this.text,
    required this.icon,
    required this.path,
    this.bgColor = const Color(0xFF410083),
    this.elementColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => path));
      },
      label: Text(text, style: textStyle(elementColor),),
      icon: Icon(icon, color: Colors.white,),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0), // 여기서 조절
      ),
    );
  }
}

TextStyle textStyle(Color elementColor) {
  return TextStyle(
    color: elementColor,
    fontSize: 17,
  );
} 