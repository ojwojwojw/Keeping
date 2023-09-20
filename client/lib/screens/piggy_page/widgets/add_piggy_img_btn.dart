import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:provider/provider.dart';

class AddPiggyImgBtn extends StatefulWidget {
  // final setImgPath;

  AddPiggyImgBtn({
    super.key,
    // this.setImgPath,
  });

  @override
  State<AddPiggyImgBtn> createState() => _AddPiggyImgBtnState();
}

class _AddPiggyImgBtnState extends State<AddPiggyImgBtn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          final imgPath = await _getFromGallery();
          context.read<AddPiggyProvider>().setImgPath(imgPath!);
          // widget.setImgPath(imgPath);
        },
        child: context.watch<AddPiggyProvider>().imgPath == null ?
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFECECEC),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_rounded, size: 40, color: Color(0xFF545454),),
                Text('사진 등록', style: TextStyle(fontSize: 30, color: Color(0xFF545454), fontWeight: FontWeight.bold),)
              ],
            ),
          ) :
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(context.watch<AddPiggyProvider>().imgPath!))
              )
            ),
          )
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