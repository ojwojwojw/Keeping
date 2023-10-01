import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';

// 저장된 사진을 불러오는 기본 OCR
class OcrTest extends StatefulWidget {
  const OcrTest({Key? key}) : super(key: key);

  @override
  State<OcrTest> createState() => _OcrTestState();
}

class _OcrTestState extends State<OcrTest> {
  dynamic parsedText = null;
  final apiKey = "QnlFZlFOR21SanpIVElRU0FFc2RaZmZlbXRhTnRrSW0="; // OCR API 키

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
          if (parsedText != null)
            Expanded(
              child: ListView.builder(
                itemCount: parsedText.images.length *
                    parsedText.images.first.fields.length,
                itemBuilder: (context, index) {
                  final imageIndex =
                      index ~/ parsedText.images.first.fields.length;
                  final fieldIndex =
                      index % parsedText.images.first.fields.length;
                  final field =
                      parsedText.images[imageIndex].fields[fieldIndex];
                  return Column(
                    children: [
                      // Text('Value Type: ${field.valueType}'),
                      Text('${field.inferText}'),
                      // Text(
                      //     'Infer Confidence: ${field.inferConfidence.toStringAsFixed(2)}'),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    // print('pikedFile : ');
    // print(pickedFile.path);
    final bytes = File(pickedFile.path).readAsBytesSync();
    final image64 = base64Encode(bytes);
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    var url =
        'https://pjz2waj74v.apigw.ntruss.com/custom/v1/25090/f0d9e8175108a40aa63f310f3e37669b8de04e970078648956ebe38c1ffd7285/general';

    var payload = {
      "version": "V1",
      "requestId": "test",
      "timestamp": timeStamp,
      "lang": "ko",
      "images": [
        {
          "format": "jpg",
          "url": null,
          "data": image64,
          "name": "test",
        }
      ],
      "enableTableDetection": false
    };

    // Dio 인스턴스 생성

    // Options 객체를 사용하여 headers 설정
    Options options = Options(
      headers: {
        "Content-Type": "application/json",
        "X-OCR-SECRET": apiKey,
      },
    );

    print(payload);
    var dio = Dio(BaseOptions(headers: options.headers));
    dynamic response = await dio.post(url, data: payload);
    print(response);

    if (response.statusCode == 200) {
      OCRResponse ocrResponse = OCRResponse.fromJson(response.data);

      // OCRResponse를 이용하여 원하는 데이터에 접근할 수 있습니다.
      print("Parsed Text:");
      ocrResponse.images.forEach((image) {
        image.fields.forEach((field) {
          print("Value Type: ${field.valueType}");
          print("Infer Text: ${field.inferText}");
          print("Infer Confidence: ${field.inferConfidence}");
        });
      });

      setState(() {
        parsedText = ocrResponse;
      });
      print("parsedtext:");
      print(parsedText);
    } else {
      print("Error: ${response.statusCode}");
      // 오류 처리 코드 추가
    }
  }
}

class OCRResponse {
  final String version;
  final String requestId;
  final int timestamp;
  final List<ImageData> images;

  OCRResponse({
    required this.version,
    required this.requestId,
    required this.timestamp,
    required this.images,
  });

  factory OCRResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesJson = json['images'];
    final List<ImageData> images =
        imagesJson.map((imageJson) => ImageData.fromJson(imageJson)).toList();

    return OCRResponse(
      version: json['version'],
      requestId: json['requestId'],
      timestamp: json['timestamp'],
      images: images,
    );
  }
}

class ImageData {
  final String uid;
  final String name;
  final String inferResult;
  final String message;
  final List<FieldValue> fields;

  ImageData({
    required this.uid,
    required this.name,
    required this.inferResult,
    required this.message,
    required this.fields,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fieldsJson = json['fields'];
    final List<FieldValue> fields =
        fieldsJson.map((fieldJson) => FieldValue.fromJson(fieldJson)).toList();

    return ImageData(
      uid: json['uid'],
      name: json['name'],
      inferResult: json['inferResult'],
      message: json['message'],
      fields: fields,
    );
  }
}

class FieldValue {
  final String valueType;
  final BoundingPoly boundingPoly;
  final String inferText;
  final double inferConfidence;

  FieldValue({
    required this.valueType,
    required this.boundingPoly,
    required this.inferText,
    required this.inferConfidence,
  });

  factory FieldValue.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> boundingPolyJson = json['boundingPoly'];
    final BoundingPoly boundingPoly = BoundingPoly.fromJson(boundingPolyJson);

    return FieldValue(
      valueType: json['valueType'],
      boundingPoly: boundingPoly,
      inferText: json['inferText'],
      inferConfidence: json['inferConfidence'],
    );
  }
}

class BoundingPoly {
  final List<Vertex> vertices;

  BoundingPoly({
    required this.vertices,
  });

  factory BoundingPoly.fromJson(Map<String, dynamic> json) {
    final List<dynamic> verticesJson = json['vertices'];
    final List<Vertex> vertices =
        verticesJson.map((vertexJson) => Vertex.fromJson(vertexJson)).toList();

    return BoundingPoly(
      vertices: vertices,
    );
  }
}

class Vertex {
  final double x;
  final double y;

  Vertex({
    required this.x,
    required this.y,
  });

  factory Vertex.fromJson(Map<String, dynamic> json) {
    return Vertex(
      x: json['x'],
      y: json['y'],
    );
  }
}
