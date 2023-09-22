import 'package:flutter/material.dart';
import 'package:keeping/provider/online_payment_request_provider.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class MakeOnlinePaymentRequestFirstPage extends StatefulWidget {
  MakeOnlinePaymentRequestFirstPage({
    super.key
  });

  @override
  State<MakeOnlinePaymentRequestFirstPage> createState() => _MakeOnlinePaymentRequestFirstPageState();
}

class _MakeOnlinePaymentRequestFirstPageState extends State<MakeOnlinePaymentRequestFirstPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  bool _nameValidate = false;
  bool _urlValidate = false;
  bool _reasonValidate = false;

  void _setNameValidate(bool val) {
    setState(() {
      _nameValidate = val;
    });
  }

  void _setUrlValidate(bool val) {
    setState(() {
      _urlValidate = val;
    });
  }

  void _setReasonValidate(bool val) {
    setState(() {
      _reasonValidate = val;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<OnlinePaymentRequestFormProvider>().removeOnlinePaymentRequestForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '온라인 결제 부탁하기',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              renderTextFormField(
                label: '어떤 걸 사고 싶나요?',
                hintText: '부탁하고 싶은 걸 적어주세요.',
                onSaved: (val) {
                  context.read<OnlinePaymentRequestFormProvider>().setName(val);
                },
                validator: (val) {
                  if (val.length < 1) {
                    return '한 글자 이상 입력해주세요.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1) {
                    _setNameValidate(false);
                  } else {
                    _setNameValidate(true);
                  }
                },
                controller: _nameController
              ),
              renderTextFormField(
                label: '어디서 팔고 있나요?',
                hintText: 'URL을 입력해 주세요.',
                onSaved: (val) {
                  context.read<OnlinePaymentRequestFormProvider>().setUrl(val);
                },
                validator: (val) {
                  if (val.length < 1) {
                    return '한 글자 이상 입력해주세요.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1) {
                    _setUrlValidate(false);
                  } else {
                    _setUrlValidate(true);
                  }
                },
                controller: _urlController
              ),
              renderBoxFormField(
                label: '왜 필요한가요?',
                hintText: '이 물건이 필요한 이유를 설명해주세요!',
                onSaved: (val) {
                  context.read<OnlinePaymentRequestFormProvider>().setReason(val);
                },
                validator: (val) {
                  if (val.length < 1) {
                    return '한 글자 이상 입력해주세요.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1) {
                    _setReasonValidate(false);
                  } else {
                    _setReasonValidate(true);
                  }
                },
                controller: _reasonController
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () async {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.push(context, MaterialPageRoute(builder: (_) => MakeOnlinePaymentRequestSecondPage()));
            print('저장완료');
          } else {
            print('저장실패');
            // 모달 띄우기
          }
        },
        isDisabled: _nameValidate && _urlValidate && _reasonValidate ? false : true,
      ),
    );
  }
}

const int _balance = 50000;

class MakeOnlinePaymentRequestSecondPage extends StatefulWidget {
  MakeOnlinePaymentRequestSecondPage({
    super.key
  });

  @override
  State<MakeOnlinePaymentRequestSecondPage> createState() => _MakeOnlinePaymentRequestSecondPageState();
}

class _MakeOnlinePaymentRequestSecondPageState extends State<MakeOnlinePaymentRequestSecondPage> {
  final _formKey = GlobalKey<FormState>();

  int _cost = 0;
  int _paidMoney = 0;

  final TextEditingController _costController = TextEditingController();
  final TextEditingController _paidMoneyController = TextEditingController();

  bool _costValidate = false;
  bool _paidMoneyValidate = false;

  void setCost(String cost) {
    setState(() {
      _cost = int.parse(cost);
    });
  }

  void setPaidMoney(String paidMoney) {
    setState(() {
      _paidMoney = int.parse(paidMoney);
    });
  }

  void _setCostValidate(bool val) {
    setState(() {
      _costValidate = val;
    });
  }

  void _setPaidMoneyValidate(bool val) {
    setState(() {
      _paidMoneyValidate = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '온라인 결제 부탁하기',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              renderTextFormField(
                isNumber: true,
                label: '얼마인가요?',
                hintText: '부탁하고 싶은 물건의 가격을 적어주세요.',
                onSaved: (val) {
                  context.read<OnlinePaymentRequestFormProvider>().setName(val);
                },
                validator: (val) {
                  if (val.length < 1) {
                    return '금액을 입력해주세요.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1) {
                    _setCostValidate(false);
                  } else {
                    _setCostValidate(true);
                  }
                },
                controller: _costController
              ),
              renderTextFormField(
                isNumber: true,
                label: '얼마를 낼까요?',
                hintText: '내가 낼 금액을 입력해주세요.',
                onSaved: (val) {
                  context.read<OnlinePaymentRequestFormProvider>().setUrl(val);
                },
                validator: (val) {
                  if (val.length < 1) {
                    return '금액을 입력해주세요.';
                  } else if (int.parse(val) > _balance) {
                    return '출금 가능 잔액을 초과했습니다.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1 || int.parse(val) > _balance) {
                    _setPaidMoneyValidate(false);
                  } else {
                    _setPaidMoneyValidate(true);
                  }
                },
                controller: _paidMoneyController
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: () {
          _makeOnlinePaymentRequest(
            accessToken: "dd",
            name: context.watch<OnlinePaymentRequestFormProvider>().name ?? '',
            url: context.watch<OnlinePaymentRequestFormProvider>().url ?? '',
            reason: context.watch<OnlinePaymentRequestFormProvider>().reason ?? '',
            cost: _cost,
            paidMoney: _paidMoney,
          );
        },
        isDisabled: _costValidate && _paidMoneyValidate ? false : true,
      ),
    );
  }
}

Future<dynamic> _makeOnlinePaymentRequest({
  required String accessToken, required String name, required String url, required String reason, required int cost, required int paidMoney 
}) async {
  final response = await dioPost(
    accessToken: accessToken,
    url: '/bank-service/online',
    data: {
      "name": name,
      "url": url,
      "reason": reason,
      "cost": cost,
      "paidMoney": paidMoney,
    }
  );
  if (response != null) {
    return response;
  } else {
    return null;
  }
}