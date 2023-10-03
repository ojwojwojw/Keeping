import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/screens/allowance_ledger_page/select_ocr_text_page.dart';
import 'package:keeping/screens/receipt_ocr_page/receipt_ocr_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_double_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:path/path.dart' as path;

class SelectOCRImgPage extends StatelessWidget {
  final String imgPath;

  SelectOCRImgPage({
    super.key,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '영수증 등록하기',
      ),
      body: Container(
        child: Image.file(File(imgPath)),
      ),
      bottomNavigationBar: BottomDoubleBtn(
        firstText: '등록하기',
        firstAction: () async {
          final response = await _getOCRData(imgPath: imgPath);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SelectOCRTextPage(textList: textList)));
        },
        secondText: '다시하기',
        secondAction: () async {
          final imgPath = await _getFromGallery();
          if (imgPath == null) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SelectOCRImgPage(imgPath: imgPath)));
        },
        isDisabled: false,
      ),
    );
  }
}

Future<dynamic> _getOCRData({
  required String imgPath
}) async {
  try {
    final uploadImageFile = await MultipartFile.fromFile(imgPath);
    final response = await dioPostForCLOVA(
      url: '/general',
      // url: '/document/receipt',
      data: {
        "version": "V1",
        "requestId": "test",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "lang": "ko",
        "images": [
          {
            "format": "jpg",
            "url": null,
            "data": base64Encode(File(imgPath).readAsBytesSync()),
            "name": "test",
          }
        ],
        "enableTableDetection": false
      }
    );
    print('OCR 요청 응답 $response');
    if (response.statusCode == 200) {
      OCRResponse ocrResponse = OCRResponse.fromJson(response.data);
      // OCRResponse를 이용하여 원하는 데이터에 접근할 수 있습니다.
      print("Parsed Text:");
      ocrResponse.images.forEach((image) {
        image.fields.forEach((field) {
          print("Value Type: ${field.valueType}");
          print("Infer Text: ${field.inferText}");
          // 여기에 \field.inferText 를 전역변수 리스트인 textList에 push 하는 로직 \\\
          textList.add(field.inferText);
          print("Infer Confidence: ${field.inferConfidence}");
        });
      });
      print("parsedtext:");
      print(ocrResponse);
      return textList;
    } else {
      print("Error: ${response.statusCode}");
      // 오류 처리 코드 추가
    }
    return response;
  } catch (e) {
    print('OCR 요청 에러 $e');
  }
}

// Future<dynamic> _getOCRData({
//   required String imgPath
// }) async {
//   try {
//     final uploadImageFile = await MultipartFile.fromFile(imgPath);
//     final response = await dioPostForCLOVA(
//       url: '/general',
//       // url: '/document/receipt',
//       data: FormData.fromMap({
//         'message': {
//           'version': 'V2',
//           'requestId': '영수증찍기',
//           'timestamp': DateTime.now().millisecondsSinceEpoch,
//           'images': [
//             {
//               'format': path.extension(imgPath),
//               'name': '영수증찍기',
//             },
//           ],
//         },
//         'file': uploadImageFile,
//       })
//     );
//     print('OCR 요청 응답 $response');
//     return response;
//   } catch (e) {
//     print('OCR 요청 에러 $e');
//   }
// }

Future<dynamic> _getFromGallery() async {
  final pickedFile =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
  if (pickedFile == null) {
    return null;
  }
  dynamic imgPath = pickedFile.path;

  return imgPath;
}