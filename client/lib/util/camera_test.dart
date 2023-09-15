// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// // 전역변수
// late String image64;
// String parsedtext = '';
// // 전역변수

// class CameraTest extends StatelessWidget {
//   final CameraDescription camera;

//   CameraTest({required this.camera});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('카메라 앱')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // 버튼이 눌릴 때 TakePictureScreen으로 이동합니다.
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => TakePictureScreen(
//                   camera: camera,
//                 ),
//               ),
//             );
//           },
//           child: Text('카메라 열기'),
//         ),
//       ),
//     );
//   }
// }

// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({
//     Key? key,
//     required this.camera,
//   }) : super(key: key);

//   final CameraDescription camera;

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // 현재 카메라 출력을 보기 위해 CameraController를 생성합니다.
//     _controller = CameraController(
//       // 사용 가능한 카메라 목록 중에서 특정 카메라를 선택합니다.
//       widget.camera,
//       // 사용할 해상도를 정의합니다.
//       ResolutionPreset.medium,
//     );

//     // 다음으로, 컨트롤러를 초기화합니다. 이것은 Future를 반환합니다.
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // 위젯이 해제될 때 컨트롤러를 해제합니다.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('사진 찍기')),
//       // 카메라 프리뷰를 표시하기 전에 컨트롤러가 초기화될 때까지 기다립니다.
//       // 컨트롤러가 초기화될 때까지 로딩 스피너를 표시하기 위해 FutureBuilder를 사용합니다.
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // Future가 완료된 경우 프리뷰를 표시합니다.
//             return CameraPreview(_controller);
//           } else {
//             // 그렇지 않으면 로딩 인디케이터를 표시합니다.
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         // onPressed 콜백을 제공합니다.
//         onPressed: () async {
//           // try / catch 블록에서 사진을 촬영합니다. 오류가 발생하면 오류를 처리합니다.
//           try {
//             // 카메라가 초기화되었는지 확인합니다.
//             await _initializeControllerFuture;

//             // 사진을 찍고 파일 'image'에 저장합니다.
//             final image = await _controller.takePicture();
//             print(image);
//             // base64 형식으로 변환하기

//             var bytes = File(image.path).readAsBytesSync();

//             image64 = base64Encode(bytes);

//             if (!mounted) return;

//             // OCR 결과를 얻기 위해 _getFromCamera 함수를 호출합니다.
//             await _getFromCamera(); // OCR 함수 호출
//             print(parsedtext);
//             // 사진이 찍힌 경우, 새로운 화면에 이미지를 표시합니다.
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   // 자동으로 생성된 경로를 DisplayPictureScreen 위젯에 전달합니다.
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//           } catch (e) {
//             // 오류가 발생하면 콘솔에 오류를 기록합니다.
//             print(e);
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }

//   _getFromCamera() async {
//     var url = 'https://api.ocr.space/parse/image';
//     var payload = {
//       "base64Image": "data:image/jpg;base64,${image64.toString()}",
//       "language": "kor"
//     };
//     var header = {"apikey": "K87454900488957"};

//     var post = await http.post(Uri.parse(url), body: payload, headers: header);

//     var result = jsonDecode(post.body);
//     print(result);
//     setState(() {
//       // parsedtext = result['ParsedResults'][0]['ParsedText'];
//       parsedtext = result['ParsedResults'][0]['ParsedText'];
//     });
//   }
// }

// class DisplayPictureScreen extends StatefulWidget {
//   final String imagePath;

//   const DisplayPictureScreen({Key? key, required this.imagePath})
//       : super(key: key);

//   @override
//   _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
// }

// class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('사진 표시')),
//       // 이미지는 기기에 파일로 저장됩니다. `Image.file` 생성자를 사용하여 이미지를 표시합니다.
//       body: Column(
//         children: [
//           Image.file(File(widget.imagePath)),
//           Text(parsedtext), // OCR 결과를 표시
//         ],
//       ),
//     );
//   }
// }
