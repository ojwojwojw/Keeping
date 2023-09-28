import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/mission_provider.dart';
import 'package:keeping/provider/ocr_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

dynamic parsedText = null;
List<String> textList = [];

class CameraTest extends StatefulWidget {
  @override
  _CameraTestState createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _takePhoto(context);
  }

  // Missing build method added
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a Photo')),
      body: Center(
        child: Text('Take a photo using the camera.'),
      ),
    );
  }
}

Future<void> _takePhoto(context) async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
  if (image != null && image.path != null) {
    print("저장경로 : ${image.path}");
    GallerySaver.saveImage(image.path).then((value) {
      print("사진이 저장되었습니다");
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCropAndOCRWidget(pickedFile: image),
      ),
    );
  }
}

class ImageCropAndOCRWidget extends StatefulWidget {
  final XFile? pickedFile;

  ImageCropAndOCRWidget({this.pickedFile});

  @override
  _ImageCropAndOCRWidgetState createState() => _ImageCropAndOCRWidgetState();
}

class _ImageCropAndOCRWidgetState extends State<ImageCropAndOCRWidget> {
  XFile? _croppedFile;
  late Future<void> _cropAndOcrFuture; // <-- 상태 변수 추가

  @override
  void initState() {
    super.initState();
    _croppedFile = widget.pickedFile;
    _cropAndOcrFuture = fn_cropImage(); // <-- Future 초기화
  }

  Future<void> fn_cropImage() async {
    final apiKey = "QnlFZlFOR21SanpIVElRU0FFc2RaZmZlbXRhTnRrSW0="; // OCR API 키

    if (_croppedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _croppedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = widget.pickedFile;
        });

        final temporaryDirectory = await getTemporaryDirectory();
        final temporaryFilePath =
            '${temporaryDirectory.path}/cropped_image.jpg';

        // croppedFile을 복사하여 temporaryFile을 생성
        await File(croppedFile.path).copy(temporaryFilePath);

        // 일시적인 파일을 갤러리에 저장
        await GallerySaver.saveImage(temporaryFilePath);

        // 일시적인 파일을 삭제 (선택 사항)
        File(temporaryFilePath).delete();

        final bytes = File(croppedFile.path).readAsBytesSync();
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
        print('Response:');
        print(response);

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
              //provider에 저장
              Provider.of<OcrProvider>(context, listen: false).textList =
                  textList;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Crop and OCR')),
      body: FutureBuilder<void>(
        future: _cropAndOcrFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _croppedFile == null
                ? Center(child: Text('No cropped image selected.'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: parsedText.images.length *
                              parsedText.images.first.fields.length,
                          itemBuilder: (context, index) {
                            final imageIndex =
                                index ~/ parsedText.images.first.fields.length;
                            final fieldIndex =
                                index % parsedText.images.first.fields.length;
                            final field = parsedText
                                .images[imageIndex].fields[fieldIndex];
                            return Column(
                              children: [
                                // Text('Value Type: ${field.valueType}'),
                                Text('${field.inferText}'),
                                // Text('Infer Confidence: ${field.inferConfidence.toStringAsFixed(2)}'),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
