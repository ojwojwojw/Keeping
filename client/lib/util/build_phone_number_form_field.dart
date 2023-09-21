import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget BuildPhoneNumberFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required String? Function(String?) validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneNumberFormatter()], // Use custom formatter
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
      ),
      SizedBox(
        height: 16.0,
      )
    ],
  );
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Filter non-numeric characters
    final formattedText = formatPhoneNumber(text); // Format the phone number

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String formatPhoneNumber(String text) {
    if (text.isEmpty) {
      return '';
    }
    String formatted = text;
    if (text.length >= 3) {
      formatted = text.substring(0, 3) + '-';
      if (text.length >= 7) {
        formatted += text.substring(3, 7) + '-';
        if (text.length > 7) {
          formatted += text.substring(7);
        }
      } else {
        formatted += text.substring(3);
      }
    }
    return formatted;
  }
}
