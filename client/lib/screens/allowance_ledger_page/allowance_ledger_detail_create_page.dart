import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class AllowanceLedgerDetailCreatePage extends StatefulWidget {
  // 카테고리 따라 사진 다르게 설정, 지출 입금 따라 -/+ 기호 추가
  final DateTime date;
  final String storeName;
  final int money;
  final int balance;
  final int accountHistoryId;
  final Map<String, dynamic>? detail;

  AllowanceLedgerDetailCreatePage(
      {super.key,
      required this.date,
      required this.storeName,
      required this.money,
      required this.balance,
      required this.accountHistoryId,
      this.detail});

  @override
  State<AllowanceLedgerDetailCreatePage> createState() =>
      _AllowanceLedgerDetailCreatePageState();
}

class _AllowanceLedgerDetailCreatePageState
    extends State<AllowanceLedgerDetailCreatePage> {
  bool? _parent;
  String? _accessToken;
  String? _memberKey;

  TextEditingController contentControlloer = TextEditingController();
  TextEditingController moneyControlloer = TextEditingController();
  TextEditingController categoryIdxControlloer = TextEditingController();

  String _content = '';
  int _money = 0;
  String _category = '';

  bool _contentResult = false;
  bool _moneyResult = false;
  bool _categoryResult = true;

  void _setContent(String val) {
    if (val.isNotEmpty) {
      setState(() {
        _content = val;
      });
    }
  }

  void _setMoney(String val) {
    if (val.isNotEmpty) {
      setState(() {
        _money = int.parse(val);
      });
    }
  }

  void _setCategory(String selectedCategory) {
    if (selectedCategory.isNotEmpty) {
      setState(() {
        _category = selectedCategory;
      });
    }
  }

  void setContentResult(bool val) {
    _contentResult = val;
  }

  void setMoneyResult(bool val) {
    _moneyResult = val;
  }

  void setCategoryResult(bool val) {
    _categoryResult = val;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

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
                MoneyRecordsDate(
                  date: widget.date,
                ),
                MoneyRecord(
                  date: widget.date,
                  storeName: widget.storeName,
                  money: widget.money,
                  balance: widget.balance,
                  accountHistoryId: widget.accountHistoryId,
                  type: true,
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  renderTextFormField(
                      label: '무엇을 구매했나요?',
                      validator: (val) {
                        if (val.length < 1) {
                          return '물품명을 입력해주세요.';
                        }
                        return null;
                      },
                      onChange: (val) {
                        _setContent(val);
                      },
                      controller: contentControlloer),
                  renderCategoryField(_setCategory, _category),
                  renderTextFormField(
                      label: '얼마인가요?',
                      validator: (val) {
                        if (val.length < 1) {
                          return '금액을 입력해주세요.';
                        } else if (int.parse(val) > widget.money) {
                          return '금액을 초과했습니다.';
                        }
                        return null;
                      },
                      onChange: (val) {
                        _setMoney(val);
                      },
                      controller: moneyControlloer,
                      isNumber: true),
                ],
              ),
            ),
            Column(
              children: [
                Text(_content),
                Text(_money.toString()),
                Text(_category)
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '등록하기',
        action: () async {
          var response = await createAccountDetail(
            accessToken: _accessToken!,
            memberKey: _memberKey!,
            accountHistoryId: widget.accountHistoryId,
            content: _content,
            money: _money,
          );
          if (response == 0) {
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
        },
        isDisabled:
            _contentResult && _categoryResult && _moneyResult ? false : true,
      ),
    );
  }
}
