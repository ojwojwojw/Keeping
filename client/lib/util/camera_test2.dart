import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/util/ocr_test.dart';

// 전역변수
late String image64;
String parsedtext = '';
// 전역변수

class CameraTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카메라 앱')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 버튼이 눌릴 때 TakePictureScreen으로 이동합니다.
            _takePhoto();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OcrTest(),
              ),
            );
          },
          child: Text('카메라 열기'),
        ),
      ),
    );
  }
}

void _takePhoto() async {
  ImagePicker().pickImage(source: ImageSource.camera).then((value) {
    if (value != null && value.path != null) {
      print("저장경로 : ${value.path}");

      GallerySaver.saveImage(value.path).then((value) {
        print("사진이 저장되었습니다");
      });
    }
  });
}
