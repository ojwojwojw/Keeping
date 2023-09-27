import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:provider/provider.dart';

class AddPiggyImgBtn extends StatefulWidget {
  final setUploadImage;
  final setUploadImageResult;

  AddPiggyImgBtn({
    super.key,
    required this.setUploadImage,
    required this.setUploadImageResult,
  });

  @override
  State<AddPiggyImgBtn> createState() => _AddPiggyImgBtnState();
}

class _AddPiggyImgBtnState extends State<AddPiggyImgBtn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35, bottom: 20),
        child: InkWell(
          onTap: () async {
            final imgPath = await _getFromGallery();
            if (imgPath != null) {
              context.read<AddPiggyProvider>().setImgPath(imgPath!);
              widget.setUploadImage(imgPath);
              widget.setUploadImageResult(true);
            } else {
              context.read<AddPiggyProvider>().setImgPath('');
              widget.setUploadImage('');
              widget.setUploadImageResult(false);
            }
            // widget.setImgPath(imgPath);
          },
          child: ClipOval(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFECECEC),
              ),
              child: context.watch<AddPiggyProvider>().imgPath == null ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_rounded, size: 40, color: Color(0xFF545454),),
                    Text('사진 등록', style: TextStyle(fontSize: 30, color: Color(0xFF545454), fontWeight: FontWeight.bold),)
                  ],
                ) :
                Image.file(
                  File(context.watch<AddPiggyProvider>().imgPath!),
                  fit: BoxFit.cover,
                )
            ),
          )
        ),
      )
    );
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