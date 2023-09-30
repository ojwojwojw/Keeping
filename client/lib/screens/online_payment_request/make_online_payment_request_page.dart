import 'package:flutter/material.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/online_payment_request_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/utils/online_payment_request_future_methods.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class MakeOnlinePaymentRequestFirstPage extends StatefulWidget {
  MakeOnlinePaymentRequestFirstPage({super.key});

  @override
  State<MakeOnlinePaymentRequestFirstPage> createState() =>
      _MakeOnlinePaymentRequestFirstPageState();
}

class _MakeOnlinePaymentRequestFirstPageState
    extends State<MakeOnlinePaymentRequestFirstPage> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _urlController = TextEditingController();
  // final TextEditingController _reasonController = TextEditingController();

  bool _productNameValidate = false;
  bool _urlValidate = false;
  bool _reasonValidate = false;

  void _setProductNameValidate(bool val) {
    setState(() {
      _productNameValidate = val;
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
                    context.read<OnlinePaymentRequestFormProvider>().setProductName(val);
                  },
                  validator: (val) {
                    if (val.length < 1) {
                      return '한 글자 이상 입력해주세요.';
                    }
                    return null;
                  },
                  onChange: (val) {
                    if (val.length < 1) {
                      _setProductNameValidate(false);
                    } else {
                      _setProductNameValidate(true);
                    }
                  },
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
                ),
              renderBoxFormField(
                  label: '왜 필요한가요?',
                  hintText: '이 물건이 필요한 이유를 설명해주세요!',
                  onSaved: (val) {
                    context.read<OnlinePaymentRequestFormProvider>().setContent(val);
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
            roundedModal(
              context: context, 
              title: '문제가 발생했습니다. 다시 시도해주세요.'
            );
          }
        },
        isDisabled: _productNameValidate && _urlValidate && _reasonValidate ? false : true,
      ),
    );
  }
}

class MakeOnlinePaymentRequestSecondPage extends StatefulWidget {
  MakeOnlinePaymentRequestSecondPage({super.key});

  @override
  State<MakeOnlinePaymentRequestSecondPage> createState() =>
      _MakeOnlinePaymentRequestSecondPageState();
}

class _MakeOnlinePaymentRequestSecondPageState extends State<MakeOnlinePaymentRequestSecondPage> {
  String? _accessToken;
  String? _memberKey;
  int _balance = 0;

  final _formKey = GlobalKey<FormState>();

  int _totalMoney = 0;
  int _childMoney = 0;

  bool _totalMoneyValidate = false;
  bool _childMoneyValidate = false;

  void _setTotalMoney(val) {
    setState(() {
      _totalMoney = int.parse(val);
    });
  }

  void _setChildMoney(val) {
    setState(() {
      _childMoney = int.parse(val);
    });
  }

  void _setTotalMoneyValidate(bool val) {
    setState(() {
      _totalMoneyValidate = val;
    });
  }

  void _setChildMoneyValidate(bool val) {
    setState(() {
      _childMoneyValidate = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _balance = context.read<AccountInfoProvider>().balance;
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
                  validator: (val) {
                    if (val.length < 1) {
                      return '금액을 입력해주세요.';
                    }
                    return null;
                  },
                  onChange: (val) {
                    if (val.length < 1) {
                      _setTotalMoney(0);
                      _setTotalMoneyValidate(false);
                    } else {
                      _setTotalMoney(val);
                      _setTotalMoneyValidate(true);
                    }
                  },
                ),
              renderTextFormField(
                  isNumber: true,
                  label: '얼마를 낼까요?',
                  hintText: '내가 낼 금액을 입력해주세요.',
                  validator: (val) {
                    if (val.length < 1) {
                      return '금액을 입력해주세요.';
                    } else if (int.parse(val) > _balance) {
                      return '출금 가능 잔액을 초과했습니다.';
                    } else if (_totalMoney < int.parse(val)) {
                      return '물건 금액을 초과했습니다.';
                    }
                    return null;
                  },
                  onChange: (val) {
                    if (val.length < 1) {
                      _setChildMoney('0');
                      _setChildMoneyValidate(false);
                    } else if (int.parse(val) > _balance) {
                      _setChildMoney(val);
                      _setChildMoneyValidate(false);
                    } else {
                      _setChildMoney(val);
                      _setChildMoneyValidate(true);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '부탁하기',
        action: () async {
          var response = await createOnlinePaymentRequest(
            accessToken: _accessToken, 
            memberKey: _memberKey, 
            productName: Provider.of<OnlinePaymentRequestFormProvider>(context, listen: false).productName, 
            url: Provider.of<OnlinePaymentRequestFormProvider>(context, listen: false).url, 
            content: Provider.of<OnlinePaymentRequestFormProvider>(context, listen: false).content, 
            totalMoney: _totalMoney, 
            childMoney: _childMoney
          );
          print('온라인 결제 요청 결과 $response');
          if (response == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CompletedPage(
              text: '부탁이\n완료되었습니다.',
              button: ConfirmBtn(
                action: OnlinePaymentRequestPage(),
              ),
            )));
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
        },
        isDisabled: _totalMoneyValidate && _childMoneyValidate ? false : true,
      ),
    );
  }
}
