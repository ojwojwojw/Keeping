import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/request_pocket_money_page/child_request_money_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';

final _requestKey = GlobalKey<FormState>();

class RequestPocketMoneySecondPage extends StatefulWidget {
  @override
  _RequestPocketMoneySecondPageState createState() =>
      _RequestPocketMoneySecondPageState();
}

class _RequestPocketMoneySecondPageState
    extends State<RequestPocketMoneySecondPage> {
  TextEditingController _money = TextEditingController();
  TextEditingController _content = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _money = TextEditingController();
    _content = TextEditingController();
  }

  @override
  void dispose() {
    _money.dispose();
    _content.dispose();
    super.dispose();
  }

  void _updateButtonDisabledState() {
    setState(() {
      if (_money.text.isNotEmpty && _content.text.isNotEmpty) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기'),
      body: Center(
        child: Form(
          key: _requestKey,
          child: Column(
            children: [
              requestMoneyHowMuch(),
              requestMoneyContent(),
            ],
          ),
        ),
      ),
      bottomSheet: BottomBtn(
        text: '조르기 요청하기',
        action: () {
          requestMoney(context);
        },
        isDisabled: _isButtonDisabled,
      ),
    );
  }

  Future<void> requestMoney(BuildContext context) async {
    print('Money: ${_money.text}');
    print('Content: ${_content.text}');
    final data = {
      'content': _content.text,
      'money': _money.text,
    };
    print(data);
    String accessToken =
        Provider.of<UserInfoProvider>(context, listen: false).accessToken;
    String memberKey =
        Provider.of<UserInfoProvider>(context, listen: false).memberKey;
    print(memberKey);
    final response = await dioPost(
      url: '/bank-service/api/$memberKey/allowance',
      accessToken: accessToken,
      data: data,
    );
    print(response);
    if (response['resultStatus']['successCode'] == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedPage(
                text: '조르기 요청 완료!',
                button: ConfirmBtn(
                  action: ChildRequestMoneyPage(),
                ))),
      );
    }
  }

  void showRequestMoneyResult(BuildContext context) {
    bottomModal(
      context: context,
      title: '용돈 조르기 완료',
      content: requestMoneyResult(),
      button: acceptBtn(context),
    );
  }

  Widget requestMoneyResult() {
    return Text(
      '용돈을 졸랐어요!',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800]),
    );
  }

  Widget requestMoneyHowMuch() {
    return Container(
      child: Column(
        children: [
          renderTextFormField(
            label: '얼마를 조를까요?',
            controller: _money,
            onChange: (_) {
              _updateButtonDisabledState();
            },
            isNumber: true,
            validator: (val) {
              if (val.isEmpty) {
                return '금액을 입력해주세요.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget requestMoneyContent() {
    return Container(
      child: Column(
        children: [
          renderBoxFormField(
            label: '하고 싶은 말을 적어보세요!',
            controller: _content,
            onChange: (_) {
              _updateButtonDisabledState();
            },
          )
        ],
      ),
    );
  }

  Widget acceptBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildRequestMoneyPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8320E7),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // 모서리 둥글기 조절
            ),
            minimumSize: Size(200, 50), // 가로로 더 길게 조절
          ),
          child: Text('확인'),
        ),
      ],
    );
  }
}
