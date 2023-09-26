import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

dynamic parsedText = null;

class CameraTest extends StatefulWidget {
  @override
  _CameraTestState createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    // CameraTest 위젯이 생성될 때 _takePhoto 함수를 자동으로 호출
    _takePhoto();
  }

  Future<void> _takePhoto() async {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null && value.path != null) {
        print("저장경로 : ${value.path}");

        GallerySaver.saveImage(value.path).then((value) {
          print("사진이 저장되었습니다");
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          highlightColor: const Color(0xFFEA6357),
          backgroundColor: const Color(0xFFFDF5EC),
          canvasColor: const Color(0xFFFDF5EC),
          textTheme: TextTheme(
            headline5: ThemeData.light()
                .textTheme
                .headline5!
                .copyWith(color: const Color(0xFFEA6357)),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFEA6357),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFFEA6357)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFEA6357),
              ),
              side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Color(0xFFEA6357))),
            ),
          )),
      home: const HomePage(title: 'Image Cropping'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: BodyWidget()),
        ],
      ),
    );
  }

  Widget BodyWidget() {
    if (_croppedFile != null || _pickedFile != null) {
      return ImageCardWiget();
    } else {
      return UploaderCardWidget();
    }
  }

  /**
   * ImageCard Widget
   */
  Widget ImageCardWiget() {
    if (parsedText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ImageWidget(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          MenuWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: parsedText.images.length *
                  parsedText.images.first.fields.length,
              itemBuilder: (context, index) {
                final imageIndex =
                    index ~/ parsedText.images.first.fields.length;
                final fieldIndex =
                    index % parsedText.images.first.fields.length;
                final field = parsedText.images[imageIndex].fields[fieldIndex];
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
      );
    } else {
      // parsedText가 null인 경우 이미지만 표시
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ImageWidget(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          MenuWidget(),
        ],
      );
    }
  }

  /**
   * 실제 이미지 Widget
   */
  Widget ImageWidget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /**
   * 이미지 카드 위젯 내 버튼
   */
  Widget MenuWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            fn_clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        if (_croppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                fn_cropImage();
              },
              backgroundColor: const Color(0xFFEA6357),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          )
      ],
    );
  }

  /*
  * Image Upload Widget
  * */
  Widget UploaderCardWidget() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    fn_uploadImage();
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/**
 * 수정된 이미지를 받아서 기존 변수 _croppedFile에 수정된 이미지로 덮어씌움.
 */
  Future<void> fn_cropImage() async {
    final apiKey = "QnlFZlFOR21SanpIVElRU0FFc2RaZmZlbXRhTnRrSW0="; // OCR API 키

    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
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
          _croppedFile = croppedFile;
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

  /**
   * 이미지 업로드 함수
   */
  Future<void> fn_uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void fn_clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
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
