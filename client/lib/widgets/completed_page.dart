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
  final String? routeNameToBeRemovedUntil; // 라우트 이름을 저장하는 변수 추가

  CompletedAndGoPage({
    super.key,
    this.image = 'assets/image/temp_image.jpg',
    required this.text,
    this.content,
    required this.targetPage,
    this.routeNameToBeRemovedUntil, // 생성자에서 라우트 이름을 받을 수 있도록 수정
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
                if (routeNameToBeRemovedUntil != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                    ModalRoute.withName(routeNameToBeRemovedUntil!),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "확인",
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
