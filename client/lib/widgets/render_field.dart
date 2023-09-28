import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/category_dropdown_btn.dart';
import 'package:keeping/styles.dart';

Padding renderTextFormField({
  required String label,
  String? hintText,
  FormFieldSetter? onSaved,
  FormFieldValidator? validator,
  TextEditingController? controller,
  FormFieldSetter? onChange,
  isPassword = false,
  isNumber = false,
  double width = 340,
}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
          child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: labelStyle(),
                      )
                    ],
                  ),
                  TextFormField(
                      onSaved: onSaved,
                      validator: validator,
                      onChanged: onChange,
                      textInputAction: TextInputAction.next,
                      controller: controller,
                      keyboardType: isNumber ? TextInputType.number : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Color(0xFF8320E7),
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8320E7)),
                        ),
                      ),
                      obscureText: isPassword,
                      inputFormatters: isNumber
                          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                          : null)
                ],
              ))));
}

Padding renderBoxFormField({
  required String label,
  String? hintText,
  FormFieldSetter? onSaved,
  FormFieldValidator? validator,
  TextEditingController? controller,
  FormFieldSetter? onChange,
  double width = 340,
}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
          child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: labelStyle(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 340,
                      decoration: roundedBoxWithShadowStyle(
                        bgColor: Color(0xFFF0F0F0),
                        shadow: false,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 15),
                        child: TextFormField(
                          onSaved: onSaved,
                          validator: validator,
                          onChanged: onChange,
                          textInputAction: TextInputAction.next,
                          controller: controller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 3,
                          style: TextStyle(height: 1.5),
                          cursorColor: Color(0xFF8320E7),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: TextStyle(),
                            border: InputBorder.none,
                          ),
                        ),
                      ))
                ],
              ))));
}

Padding renderPhoneNumberFormField({
  required String label,
  String? hintText,
  FormFieldSetter? onSaved,
  FormFieldValidator? validator,
  TextEditingController? controller,
  FormFieldSetter? onChange,
  double width = 340,
}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
          child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: labelStyle(),
                      )
                    ],
                  ),
                  TextFormField(
                      onSaved: onSaved,
                      validator: validator,
                      onChanged: onChange,
                      textInputAction: TextInputAction.next,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Color(0xFF8320E7),
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8320E7)),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만
                        NumberFormatter(), // 자동하이픈
                        LengthLimitingTextInputFormatter(13)
                      ])
                ],
              ))));
}

Padding renderBirthdayFormField({
  required String label,
  String? hintText,
  FormFieldSetter? onSaved,
  FormFieldValidator? validator,
  TextEditingController? controller,
  FormFieldSetter? onChange,
  double width = 340,
}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
          child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: labelStyle(),
                      )
                    ],
                  ),
                  TextFormField(
                      onSaved: onSaved,
                      validator: validator,
                      onChanged: onChange,
                      textInputAction: TextInputAction.next,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Color(0xFF8320E7),
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8320E7)),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만
                        BirthdayFormatter(), // 자동하이픈
                        LengthLimitingTextInputFormatter(10)
                      ])
                ],
              ))));
}

Padding renderCategoryField(Function selectCategory, String selectedCategory,
    {double width = 340}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
        child: SizedBox(
      width: width,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '어떤 종류인가요?',
                style: labelStyle(),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CategoryDropdownBtn(
            selectedCategory: selectedCategory,
            selectCategory: selectCategory
          )
        ],
      ),
    )),
  );
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

class BirthdayFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 4) {
        if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 6 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 5) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}