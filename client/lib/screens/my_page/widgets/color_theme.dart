import 'package:flutter/material.dart';
import 'package:keeping/screens/my_page/widgets/color_dot.dart';

class ColorTheme extends StatelessWidget {
  final Color backgroundColor;
  final String colorName;
  const ColorTheme(
      {Key? key, required this.backgroundColor, required this.colorName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorDot(dotColor: backgroundColor), // ColorDot 위젯을 추가하여 컬러를 표시
            SizedBox(height: 40),
            Text(
              colorName,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
