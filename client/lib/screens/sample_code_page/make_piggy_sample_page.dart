import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:keeping/widgets/header.dart';

// 임시 통신 주소 로그인 키
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

class MakePiggySamplePage extends StatefulWidget {
  MakePiggySamplePage({super.key});

  @override
  _MakePiggySamplePageState createState() => _MakePiggySamplePageState();
}

class _MakePiggySamplePageState extends State<MakePiggySamplePage> {
  String uploadImgResult = '이미지X';
  String makePiggyResult = '생성X';

  String baseUri = 'https://e8aa-121-178-98-20.ngrok-free.app/bank-service/piggy/yoonyeji';

  Map<String, dynamic> headers = {
    'Authorization': 'Bearer $accessToken',
  };

  Map<String, dynamic> requestBody = {
    "content": "아디다스 삼바 내꺼야",
    "goalMoney": 140000,
    "authPassword": "123456",
  };

  late final data;

  Widget makePiggyBtn() {
    return Column(
      children: [
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: _getFromGallery,
          child: Text('사진 업로드')
        ),
        SizedBox(height: 15,),
        Text(uploadImgResult),
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: () async {
            patchPiggyImage(headers, baseUri, data);
          },
          style: authenticationBtnStyle(),
          child: Text('저금통 만들기'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '저금통 만들기'),
      body: makePiggyBtn(),
    );
  }

  Future<void> _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() {
        uploadImgResult = '업로드 실패';
      });
      return;
    }
    dynamic imgPath = pickedFile.path;
    final tempData = FormData.fromMap({
      ...requestBody,
      'uploadImage': await MultipartFile.fromFile(imgPath)
    });
    setState(() {
      data = tempData;
      uploadImgResult = data.toString();
    });
  }
}

Future<dynamic> patchPiggyImage(dynamic headers, dynamic baseUri, dynamic data) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = new Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = headers;
      var response = await dio.patch(
        baseUri,
        data: data
      );
      print('성공적으로 업로드했습니다');
      return response.data;
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }


ButtonStyle authenticationBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: const Color(0xFF8320E7), // 테두리 색상 설정
          width: 2.0, // 테두리 두께 설정
        ),
      )
    ),
    fixedSize: MaterialStateProperty.all<Size>(
      Size(180, 40)
    )
  );
}