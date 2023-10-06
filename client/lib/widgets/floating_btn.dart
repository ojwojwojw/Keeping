import 'package:flutter/material.dart';

class FloatingBtn extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget? path;
  final Color bgColor;
  final Color elementColor;
  final dynamic action;

  FloatingBtn({
    super.key,
    required this.text,
    required this.icon,
    this.path,
    this.action,
    this.bgColor = const Color(0xFF410083),
    this.elementColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (path != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => path!));
        } else if (action != null) {
          action();
        }
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