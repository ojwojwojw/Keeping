import 'package:flutter/material.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/online_payment_request/online_payment_request_page.dart';
import 'package:keeping/screens/online_payment_request/utils/online_payment_request_future_methods.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class RejectOnlinePaymentRequestPage extends StatefulWidget {
  final int onlineId;

  RejectOnlinePaymentRequestPage({
    super.key,
    required this.onlineId,
  });

  @override
  State<RejectOnlinePaymentRequestPage> createState() => _RejectOnlinePaymentRequestPageState();
}

class _RejectOnlinePaymentRequestPageState extends State<RejectOnlinePaymentRequestPage> {
  String? _accessToken;
  String? _memberKey;
  String? _childKey;

  final _formKey = GlobalKey<FormState>();

  String _comment = '';
  bool _commentValidate = false;

  void _setComment(val) {
    setState(() {
      _comment = val;
    });
  } 

  void _setCommentValidate(val) {
    setState(() {
      _commentValidate = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _childKey = context.read<ChildInfoProvider>().memberKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '부탁 거절하기',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10,),
              renderBoxFormField(
                label: '거절 이유가 무엇인가요?',
                hintText: '자녀가 이해할 수 있도록 이유를 적어주세요.',
                maxLines: 5,
                validator: (val) {
                  if (val.length < 1) {
                    return '이유를 입력해주세요.';
                  }
                  return null;
                },
                onChange: (val) {
                  if (val.length < 1) {
                    _setComment('');
                    _setCommentValidate(false);
                  } else {
                    _setComment(val);
                    _setCommentValidate(true);
                  }
                }
              )
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '거절하기',
        action: () async {
          var response = await approveOnlinePaymentRequest(
            accessToken: _accessToken, 
            memberKey: _memberKey, 
            onlineId: widget.onlineId, 
            childKey: _childKey,
            comment: _comment,
          );
          print('온라인 결제 거절 결과 $response');
          if (response == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CompletedPage(
              text: '부탁이\n거절되었습니다.',
              button: ConfirmBtn(
                action: OnlinePaymentRequestPage(),
              ),
            )));
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
        },
        isDisabled: !_commentValidate,
      ),
    );
  }
}