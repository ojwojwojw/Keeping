import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/piggy_page/piggy_page.dart';
import 'package:keeping/screens/piggy_page/utils/piggy_future_methods.dart';
import 'package:keeping/screens/piggy_page/widgets/add_piggy_img_btn.dart';
import 'package:keeping/widgets/completed_page.dart';
import 'package:keeping/widgets/confirm_btn.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/rounded_modal.dart';
import 'package:provider/provider.dart';

class MakePiggyPage extends StatefulWidget {
  MakePiggyPage({
    super.key,
  });

  @override
  State<MakePiggyPage> createState() => _MakePiggyPageState();
}

class _MakePiggyPageState extends State<MakePiggyPage> {
  String? _accessToken;
  String? _memberKey;

  String? _uploadImage = '';
  String? _content = '';
  int? _goalMoney = 0;

  bool _uploadImageResult = false;
  bool _contentResult = false;
  bool _goalMoneyResult = false;

  void _setUploadImage(val) {
    if (val.isNotEmpty) {
      setState(() {
        _uploadImage = val;
      });
    }
  }

  void _setContent(val) {
    if (val.isNotEmpty) {
      setState(() {
        _content = val;
      });
    }
  }

  void _setGoalMoney(val) {
    if (val.isNotEmpty) {
      setState(() {
        _goalMoney = int.parse(val);
      });
    }
  }

  void _setUploadImageResult(val) {
    setState(() {
      _uploadImageResult = val;
    });
  }

  void _setContentResult(val) {
    setState(() {
      _contentResult = val;
    });
  }

  void _setGoalMoneyResult(val) {
    setState(() {
      _goalMoneyResult = val;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<AddPiggyProvider>().removeAddPiggyInfo();
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _goalMoneyController = TextEditingController();
  
  String? authPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(
        text: '저금통 만들기',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AddPiggyImgBtn(
              setUploadImage: _setUploadImage,
              setUploadImageResult: _setUploadImageResult
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  renderTextFormField(
                    label: '저금통 이름',
                    // onSaved: (val) {
                    //   context.read<AddPiggyProvider>().setContent(val);
                    // },
                    validator: (val) {
                      if (val.length < 1) {
                        return '저금통 이름을 입력해주세요.';
                      }
                      return null;
                    },
                    onChange: (val) {
                      if (val.length < 1) {
                        _setContent('');
                        _setContentResult(false);
                      } else {
                        _setContent(val);
                        _setContentResult(true);
                      }
                    },
                    controller: _contentController
                  ),
                  renderTextFormField(
                    label: '목표 금액',
                    // onSaved: (val) {
                    //   context.read<AddPiggyProvider>().setGoalMoney(double.parse(val));
                    // },
                    validator: (val) {
                      if (val.length < 1) {
                        return '목표 금액을 입력해주세요.';
                      }
                      return null;
                    },
                    onChange: (val) {
                      if (val.length < 1) {
                        _setGoalMoney('0');
                        _setGoalMoneyResult(false);
                      } else {
                        _setGoalMoney(val);
                        _setGoalMoneyResult(true);
                      }
                    },
                    controller: _goalMoneyController,
                    isNumber: true
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '만들기',
        action: () async {
          var response = await makePiggy(
            accessToken: _accessToken, 
            memberKey: _memberKey, 
            content: _content, 
            goalMoney: _goalMoney, 
            uploadImage: _uploadImage,
          );
          print('저금통 만들기 결과 $response');
          if (response == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CompletedPage(
              text: '저금통이\n생성되었습니다.',
              button: ConfirmBtn(
                action: PiggyPage(),
              ),
            )));
          } else {
            roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
          }
        },
        isDisabled: _uploadImageResult && _contentResult && _goalMoneyResult ? false : true,
      ),
    );
  }
}