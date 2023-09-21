import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/category_dropdown_btn.dart';
import 'package:keeping/styles.dart';

Padding renderTextFormField({
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
  required TextEditingController controller,
  isNumber = false
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: SizedBox(
        width: 340,
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
              textInputAction: TextInputAction.next,
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : null,
              inputFormatters: isNumber ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : null
            )
          ],
        )
      )
    )
  );
}

Padding renderCategoryField(Function selectCategory, String selectedCategory) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: SizedBox(
        width: 340,
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
            SizedBox(height: 20,),
            CategoryDropdownBtn(
              selectedCategory: selectedCategory,
              selectCategory: selectCategory
            )
          ],
        ),
      )
    ),
  );
}