import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_records_date.dart';
import 'package:keeping/widgets/bottom_double_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

final Map<String, String> _categories = {
  "MART": "마트",
  "CONVENIENCE": "편의점",
  "FOOD": "음식",
  "SCHOOL": "학교",
  "CAFE": "카페",
  "CLOTH": "옷",
  "CULTURE": "문화생활",
  "PLAY": "놀이",
  "SUBWAY": "지하철",
  "BUS": "버스",
  "TAXI": "택시",
  "DIGGING": "취미",
  "GIFT": "선물",
  "OTT": "OTT",
  "CONTENT": "VOD",
  "ACADEMY": "학원",
  "TOUR": "여행",
  "BANK": "은행",
  "HOSPITAL": "병원",
  "PHARMACY": "약국",
  "ETC": "기타",
};

class AllowanceLedgerDetailCreatePage extends StatefulWidget {
  AllowanceLedgerDetailCreatePage({
    super.key,
  });

  @override
  State<AllowanceLedgerDetailCreatePage> createState() =>
      _AllowanceLedgerDetailCreatePageState();
}

class _AllowanceLedgerDetailCreatePageState
    extends State<AllowanceLedgerDetailCreatePage> {
  String? _accessToken;
  String? _memberKey;

  DateTime _date = DateTime.now();
  String _storeName = '';
  int _money = 0;
  int _balance = 0;
  int _accountHistoryId = -2;
  bool? _type;
  String _largeCategory = '';
  List<Map<String, dynamic>> _accountDetailList = [];

  String _newContent = '';
  int _newMoney = 0;
  String _newCategory = '';

  bool _newContentResult = false;
  bool _newMoneyResult = false;

  void _setContent(String val) {
    if (val.isNotEmpty) {
      setState(() {
        _newContent = val;
      });
    }
  }

  void _setMoney(String val) {
    if (val.isNotEmpty) {
      setState(() {
        _newMoney = int.parse(val);
      });
    }
  }

  void _setCategory(String selectedCategory) {
    if (selectedCategory.isNotEmpty) {
      setState(() {
        _newCategory = selectedCategory;
      });
    }
  }

  void setContentResult(bool val) {
    _newContentResult = val;
  }

  void setMoneyResult(bool val) {
    _newMoneyResult = val;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _newCategory = context.read<AccountDetailProvider>().largeCategory;

    _date = DateTime.now();
    _storeName = context.read<AccountDetailProvider>().storeName;
    _money = context.read<AccountDetailProvider>().money;
    _balance = context.read<AccountDetailProvider>().balance;
    _accountHistoryId = context.read<AccountDetailProvider>().accountHistoryId;
    _type = context.read<AccountDetailProvider>().type;
    _largeCategory = context.read<AccountDetailProvider>().largeCategory;
    _accountDetailList =
        context.read<AccountDetailProvider>().accountDetailList;
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
                  date: _date,
                ),
                MoneyRecord(
                  date: _date,
                  storeName: _storeName,
                  money: _money,
                  balance: _balance,
                  accountHistoryId: _accountHistoryId,
                  type: false,
                  largeCategory: _largeCategory,
                ),
                // Text(_accountDetailList.toString())
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
                      if (val.length < 1) {
                        setContentResult(false);
                      } else {
                        setContentResult(true);
                      }
                      _setContent(val);
                    },
                  ),
                  renderCategoryField(_setCategory, _newCategory),
                  renderTextFormField(
                      label: '얼마인가요?',
                      validator: (val) {
                        if (val.length < 1) {
                          return '금액을 입력해주세요.';
                        } else if (int.parse(val) > _money) {
                          return '금액을 초과했습니다.';
                        }
                        return null;
                      },
                      onChange: (val) {
                        if (val.length < 1 || int.parse(val) > _money) {
                          setMoneyResult(false);
                        } else {
                          setMoneyResult(true);
                        }
                        _setMoney(val);
                      },
                      isNumber: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomDoubleBtn(
        firstText: '추가하기',
        firstAction: () async {
          Provider.of<AccountDetailProvider>(context, listen: false)
              .addAccountDetail({
            "accountHistoryId": _accountHistoryId,
            "content": _newContent,
            "money": _newMoney,
            "smallCategory": _newCategory
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => AllowanceLedgerDetailCreatePage()));
        },
        secondText: '등록하기',
        secondAction: () async {
          var response = await createAccountDetail(
            accessToken: _accessToken,
            memberKey: _memberKey,
            accountDetailList: [
              ..._accountDetailList,
              {
                "accountHistoryId": _accountHistoryId,
                "content": _newContent,
                "money": _newMoney,
                "smallCategory": _newCategory
              }
            ],
          );
          Provider.of<AccountDetailProvider>(context, listen: false)
              .initAccountDetail();
          if (response['resultStatus']['resultCode'] == "") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CompletedPage(
                          text: '상세 내용이\n등록되었습니다.',
                          button: ConfirmBtn(
                            action: AllowanceLedgerPage(),
                          ),
                        )));
          } else if (response['resultStatus']['resultCode'] == "400") {
            roundedModal(context: context, title: '입력 금액이 남은 금액을 초과했습니다. 다시 한 번 확인해주세요.');
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
        },
        isDisabled: _newContentResult && _newMoneyResult ? false : true,
      ),
      // bottomSheet: BottomBtn(
      //   text: '등록하기',
      //   action: () async {
      //     var response = await createAccountDetail(
      //       accessToken: _accessToken!,
      //       memberKey: _memberKey!,
      //       accountHistoryId: widget.accountHistoryId,
      //       content: _newContent,
      //       money: _newMoney,
      //       smallCategory: _newCategory,
      //     );
      //     if (response == 0) {
      //       Navigator.push(context, MaterialPageRoute(builder: (_) => CompletedPage(
      //         text: '상세 내용이\n등록되었습니다.',
      //         button: ConfirmBtn(
      //           action: AllowanceLedgerPage(),
      //         ),
      //       )));
      //     } else {
      //       roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
      //     }
      //   },
      //   isDisabled: _newContentResult && _newMoneyResult ? false : true,
      // ),
    );
  }
}
