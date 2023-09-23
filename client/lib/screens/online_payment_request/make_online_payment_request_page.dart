import 'package:flutter/material.dart';
import 'package:keeping/provider/online_payment_request_provider.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  bool _nameValidate = false;
  bool _urlValidate = false;
  bool _reasonValidate = false;

  String _val = '';
  _setVal(String val) {
    setState(() {
      _val = val;
    });
  }

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
    context
        .read<OnlinePaymentRequestFormProvider>()
        .removeOnlinePaymentRequestForm();
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
                  onSaved: (val) {
                    context
                        .read<OnlinePaymentRequestFormProvider>()
                        .setName(val);
                  },
                  validator: (val) {
                    if (val.length < 1) {
                      return '부탁하고 싶은 걸 적어주세요.';
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
                  controller: _nameController),
              renderTextFormField(
                  label: '어디서 팔고 있나요?',
                  onSaved: (val) {
                    context
                        .read<OnlinePaymentRequestFormProvider>()
                        .setUrl(val);
                  },
                  validator: (val) {
                    if (val.length < 1) {
                      return 'URL을 적어주세요.';
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
                  controller: _urlController),
              renderBoxFormField(
                label: '상자 폼',
              ),
              renderBirthdayFormField(label: '생년월일')
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '다음',
        action: MakeOnlinePaymentRequestSecondPage(),
        isDisabled: _nameValidate && _urlValidate ? false : true,
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

class _MakeOnlinePaymentRequestSecondPageState
    extends State<MakeOnlinePaymentRequestSecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '온라인 결제 부탁하기',
      ),
      body: Container(),
      bottomNavigationBar: BottomBtn(
        text: '다음',
      ),
    );
  }
}
