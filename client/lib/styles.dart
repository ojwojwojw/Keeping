import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// 저금통, 용돈기입장 등 은은한 회색 배경
BoxDecoration lightGreyBgStyle() {
  return BoxDecoration(
    color: const Color(0xFFFAFAFA),
  );
}

// 은은한 그림자 있는 둥근 하얀 상자 스타일
BoxDecoration roundedBoxWithShadowStyle({
  Color bgColor = Colors.white, double borderRadius = 20, bool shadow = true, bool border = false, Color? borderColor, double borderWidth = 2, double blurRadius = 5
}) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(borderRadius),
    border: border ?
      Border.all(
        color: borderColor!,
        width: borderWidth
      ) : null,
    boxShadow: shadow ?
      [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          spreadRadius: 0,
          blurRadius: blurRadius,
          offset: Offset(0, 0),
        ),
      ] : null,
  );
}

// 둥근 카테고리 이미지
ClipOval categoryImg(String imgPath, {double size = 60}) {
  return ClipOval(
    child: SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover
      ),
    ),
  );
}

// 둥근 에셋 이미지(프로젝트 파일 안에 저장된 이미지)
ClipOval roundedAssetImg({required String imgPath, double size = 60}) {
  return ClipOval(
    child: SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover,
      ),
    ),
  );
}

// 둥근 파일 이미지(base64로 보내주는 이미지)
ClipOval roundedMemoryImg({required String img, double size = 100}) {
  return ClipOval(
    child: SizedBox(
      width: size,
      height: size,
      child: Image.memory(
        Base64Decoder().convert(img),
        fit: BoxFit.cover
      ),
    ),
  );
}

// 텍스트 필드 라벨 스타일 (ex. 무엇을 구매했나요?)
TextStyle labelStyle() {
  return TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold
  );
}

// 메인페이지 배경 스타일
BoxDecoration bgStyle() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Color(0xFF1C0038),
        Color(0xFF401C64)
      ]
    )
  );
}