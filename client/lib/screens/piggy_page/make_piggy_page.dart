import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/piggy_page/enter_auth_password_page.dart';
import 'package:keeping/screens/piggy_page/widgets/add_piggy_img_btn.dart';
import 'package:keeping/util/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

// 임시. 실제로는 프로바이더에서 가져오려나?
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWppIiwiYXV0aCI6IlVTRVIiLCJuYW1lIjoi7JiI7KeAIiwicGhvbmUiOiIwMTAtMDAwMC0wMDAwIiwiZXhwIjoxNjk1ODgyMDcxfQ.XgYC2up60frNzdg8TMJ3nC3JRRwFFZiBFXTE0XRTmS4';

class MakePiggyPage extends StatefulWidget {
  MakePiggyPage({
    super.key,
  });

  @override
  State<MakePiggyPage> createState() => _MakePiggyPageState();
}

class _MakePiggyPageState extends State<MakePiggyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _goalMoneyController = TextEditingController();
  
  String? authPassword;
  // String? imgPath;

  // setImgPath(String newImgPath) {
  //   setState(() {
  //     imgPath = newImgPath;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통 만들기',
      ),
      body: Column(
        children: [
          AddPiggyImgBtn(),
          // AddPiggyImgBtn(setImgPath: setImgPath),
          // imgPath == null ? AddPiggyImgBtn(setImgPath: setImgPath) : addedPiggyImg(setImgPath, imgPath, context),
          // if (imgPath != null) Text(imgPath!),
          Form(
            key: _formKey,
            child: Column(
              children: [
                renderTextFormField(
                  label: '저금통 이름',
                  onSaved: (val) {
                    context.read<AddPiggyProvider>().setContent(val);
                  },
                  validator: (val) {
                    if (val.length < 1) {
                      return '저금통 이름을 입력해주세요.';
                    }
                    return null;
                  },
                  controller: _contentController
                ),
                renderTextFormField(
                  label: '목표 금액',
                  onSaved: (val) {
                    context.read<AddPiggyProvider>().setGoalMoney(double.parse(val));
                  },
                  validator: (val) {
                    if (val.length < 1) {
                      return '목표 금액을 입력해주세요.';
                    }
                    return null;
                  },
                  controller: _goalMoneyController,
                  isNumber: true
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        // action: EnterAuthPasswordPage(),
        action: () async {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.push(context, MaterialPageRoute(builder: (_) => EnterAuthPasswordPage()));
            print('저장완료');
          } else {
            print('저장실패');
            // 모달 띄우기
          }
        },
      ),
    );
  }
}

// Center addedPiggyImg(setImgPath, imgPath, context) {
//   var imagPath = context.watch<AddPiggyProvider>().imgPath;

//   return Center(
//     child: InkWell(
//       onTap: () async {
//         final imgPath = await _getFromGallery();
//         context.read<PiggyDetailProvider>().setImgPath(imgPath);
//         // setImgPath(imgPath);
//       },
//       child: Container(
//         width: 200,
//         height: 200,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: FileImage(File(imagPath))
//           )
//         ),
//       )
//     )
//   );
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

Future<dynamic> _patchPiggyImage(dynamic headers, dynamic baseUri, dynamic data) async {
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