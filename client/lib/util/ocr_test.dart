import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class OcrTest extends StatefulWidget {
  const OcrTest({Key? key}) : super(key: key);

  @override
  State<OcrTest> createState() => _OcrTestState();
}

class _OcrTestState extends State<OcrTest> {
  String parsedtext = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _getFromGallery,
            child: Text('Select Image'),
          ),
          SizedBox(height: 16),
          Text(parsedtext), // parsedtext를 화면에 렌더링
        ],
      ),
    );
  }

  Future<void> _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    var bytes = File(pickedFile.path).readAsBytesSync();

    // 이미지를 압축
    final compressedImage = await compressImage(pickedFile.path);
    if (compressedImage == null) return;

    String img64 = base64Encode(compressedImage);
    print(img64);
    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,$img64",
      "language": "kor"
    };
    var header = {"apikey": "K87454900488957"};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);
    print(result);
    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
  }
}

Future<List<int>?> compressImage(String filePath) async {
  final result = await FlutterImageCompress.compressWithFile(
    filePath,
    quality: 85, // 이미지 품질 (0-100)
  );

  return result;
}
