import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/allowance_ledger_page/select_ocr_text_page.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_double_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class SelectOCRImgPage extends StatefulWidget {
  final String imgPath;
  final int accountHistoryId;

  SelectOCRImgPage({
    super.key,
    required this.imgPath,
    required this.accountHistoryId,
  });

  @override
  State<SelectOCRImgPage> createState() => _SelectOCRImgPageState();
}

class _SelectOCRImgPageState extends State<SelectOCRImgPage> {
  String? _accessToken;
  String? _memberKey;

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '영수증 등록하기',
      ),
      body: Container(
        child: Image.file(File(widget.imgPath)),
      ),
      bottomNavigationBar: BottomDoubleBtn(
        firstText: '등록하기',
        firstAction: () async {
          final response = await _getOCRData(imgPath: widget.imgPath);
          List accountDetailList = response.data['images'][0]['receipt']['result']['subResults'][0]['items'].map((e) =>
            {
              "accountHistoryId": widget.accountHistoryId,
              "content": e['name']['formatted']['value'].toString(),
              "money": e['price']['price']['formatted']['value'],
              "smallCategory": null,
            }
          ).toList();
          final detailResponse = await createAccountDetail(
            accessToken: _accessToken, 
            memberKey: _memberKey, 
            accountDetailList: accountDetailList
          );
          if (detailResponse == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CompletedPage(
                          text: '상세 내용이\n등록되었습니다.',
                          button: ConfirmBtn(
                            action: AllowanceLedgerPage(),
                          ),
                        )));
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SelectOCRTextPage(response: response, accountHistoryId: accountHistoryId,)));
        },
        secondText: '다시하기',
        secondAction: () async {
          final imgPath = await _getFromGallery();
          if (imgPath == null) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SelectOCRImgPage(imgPath: imgPath, accountHistoryId: widget.accountHistoryId,)));
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
      url: '/document/receipt',
      data: {
        "version": "V2",
        "requestId": "test",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "images": [
          {
            "format": path.extension(imgPath).replaceAll('.', ''),
            "data": base64Encode(File(imgPath).readAsBytesSync()),
            "name": "test",
          }
        ],
      }
    );
    print('OCR 요청 응답 $response');
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Error: ${response.statusCode}");
      // 오류 처리 코드 추가
    }
    return null;
  } catch (e) {
    print('OCR 요청 에러 $e');
  }
}

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