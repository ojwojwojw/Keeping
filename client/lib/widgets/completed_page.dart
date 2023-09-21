import 'package:flutter/material.dart';
import 'package:keeping/widgets/confirm_btn.dart';

class CompletedPage extends StatelessWidget {
  final String image;
  final String text;
  final Widget? content;
  final Widget button;

  CompletedPage({
    super.key,
    required this.image,
    required this.text,
    this.content,
    this.button = const ConfirmBtn(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (content != null) SizedBox(height: 20,),
            if (content != null) content!,
            SizedBox(height: 30,),
            Text(
              text,
              style: textStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50,),
            button 
          ],
        ),
      )
    );
  }
}

TextStyle textStyle() {
  return TextStyle(
    fontSize: 30,
    
  );
}