import 'package:flutter/material.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/category_dropdown_btn.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';

class AllowanceLedgerDetailCreatePage extends StatefulWidget {
  // 카테고리 따라 사진 다르게 설정, 지출 입금 따라 -/+ 기호 추가
  final DateTime date;
  final String storeName;
  final num money;
  final num balance;
  final Map<String, dynamic>? detail;

  AllowanceLedgerDetailCreatePage({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    this.detail
  });

  @override
  State<AllowanceLedgerDetailCreatePage> createState() => _AllowanceLedgerDetailCreatePageState();
}

class _AllowanceLedgerDetailCreatePageState extends State<AllowanceLedgerDetailCreatePage> {
  TextEditingController contentControlloer = TextEditingController();
  TextEditingController moneyControlloer = TextEditingController();
  TextEditingController categoryIdxControlloer = TextEditingController();

  String content = '';
  num money = 0;
  String category = '';

  selectCategory(String selectedCategory) {
    setState(() {
      category = selectedCategory;
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '상세 내역 쓰기',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                MoneyRecordsDate(date: widget.date,),
                MoneyRecord(date: widget.date, storeName: widget.storeName, money: widget.money, balance: widget.balance)
              ],
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  _renderTextFormField(
                    label: '무엇을 구매했나요?', 
                    onSaved: (val) {
                      setState(() {
                        content = val;
                      });
                    }, 
                    validator: (val) {
                      if (val.length < 1) {
                        return '물품명을 입력해주세요.';
                      }
                      return null;
                    },
                    controller: contentControlloer
                  ),
                  _renderCategoryField(selectCategory, category),
                  _renderTextFormField(
                    label: '얼마인가요?', 
                    onSaved: (val) {
                      setState(() {
                        money = num.parse(val);
                      });
                    }, 
                    validator: (val) {
                      if (val.length < 1) {
                        return '제대로 입력해라..';
                      }
                      return null;
                    },
                    controller: moneyControlloer,
                    isNumber: true
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(content),
                Text(money.toString()),
                Text(category)
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '등록하기',
        action: () async {
          if (formKey.currentState != null && formKey.currentState!.validate()) {
            formKey.currentState!.save();
            print('저장완료');
          } else {
            print('저장실패');
          }
        }
      ),
    );
  }
}

Padding _renderTextFormField({
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
            )
          ],
        )
      )
    )
  );
}

Padding _renderCategoryField(Function selectCategory, String selectedCategory) {
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