import 'package:flutter/material.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/bottom_btn.dart';

class CompletedPage extends StatelessWidget {
  final String image;
  final String text;
  final Widget? content;
  final Widget button;

  CompletedPage({
    super.key,
    this.image = 'assets/image/temp_image.jpg',
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
          if (content != null)
            SizedBox(
              height: 20,
            ),
          if (content != null) content!,
          SizedBox(
            height: 30,
          ),
          Text(
            text,
            style: textStyle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          button
        ],
      ),
    ));
  }
}

TextStyle textStyle() {
  return TextStyle(
    fontSize: 30,
  );
}

//어떤 동작을 완료하고, 내가 원하는 페이지로 이동하게 하는 기능을 가진 위젯//
//예지야 잘만들었지?//
class CompletedAndGoPage extends StatelessWidget {
  final String image;
  final String text;
  final Widget? content;
  final Widget targetPage;

  CompletedAndGoPage({
    super.key,
    this.image = 'assets/image/temp_image.jpg',
    required this.text,
    this.content,
    required this.targetPage,
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
            if (content != null) SizedBox(height: 20),
            if (content != null) content!,
            SizedBox(height: 30),
            Text(
              text,
              style: textStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "확인", // 원하는 텍스트로 변경하세요.
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
