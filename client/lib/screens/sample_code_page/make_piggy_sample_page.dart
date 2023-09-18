import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/widgets/header.dart';

// 임시 통신 주소 로그인 키
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1OTQ3NTc3fQ.DCRGwyr_pSBSuyJA-21G8giFcozG9GVlD03fC9J6asU';

class MakePiggySamplePage extends StatefulWidget {
  MakePiggySamplePage({super.key});

  @override
  _MakePiggySamplePageState createState() => _MakePiggySamplePageState();
}

class _MakePiggySamplePageState extends State<MakePiggySamplePage> {
  String uploadImgResult = '이미지X';
  String makePiggyResult = '생성X';

  String baseUri = 'https://14c6-121-178-98-20.ngrok-free.app';

  Map<String, dynamic> headers = {
    'Authorization': 'Bearer $accessToken',
  };

  Map<String, dynamic> requestBody = {
    "content": "아디다스 삼바 내꺼야",
    "goalMoney": 140000,
    "authPassword": "123456",
  };

  late FormData data;

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
            final response = await patchPiggyImage(headers, baseUri, data);
            if (response != null) {
              setState(() {
                makePiggyResult = '생성 성공';
              });
            } else {
              setState(() {
                makePiggyResult = '생성 실패';
              });
            }
          },
          style: authenticationBtnStyle(),
          child: Text('저금통 만들기'),
        ),
        SizedBox(height: 15,),
        Text(makePiggyResult),
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
        await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
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
    print("프로필 사진 서버에 업로드");
    var dio = Dio();
    try {
      dio.options.baseUrl = baseUri;
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.connectTimeout = Duration(seconds: 5);
      dio.options.receiveTimeout = Duration(seconds: 3);

      dio.options.headers = headers;
      var response = await dio.post(
        '/bank-service/piggy/yoonyeji',
        data: data
      );
      print('업로드 성공');
      return response.data;
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }