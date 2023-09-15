import 'package:flutter/material.dart';

//로그인, 회원가입과 같이 유효성 검사가 필요한 곳에 사용하세요. form과 함께 사용하면 됩니다.
Widget BuildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required String? Function(String?) validator, // 유효성 검사시 이용
  bool obscureText = false, // 비밀번호와 같이 가려져야 하는 필드의 경우 true로 설정
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(labelText: labelText, hintText: hintText),
      ),
      SizedBox(
        height: 16.0,
      )
    ],
  );
}
