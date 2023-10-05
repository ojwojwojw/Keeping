import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/color_info_detail_card.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/request_info_detail_card.dart';
import 'package:provider/provider.dart';

class ChildRequestMoneyDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ChildRequestMoneyDetailPage({Key? key, required this.data})
      : super(key: key);

  @override
  State<ChildRequestMoneyDetailPage> createState() =>
      _ChildRequestMoneyDetailPageState();
}

class _ChildRequestMoneyDetailPageState
    extends State<ChildRequestMoneyDetailPage> {
  late Map<String, dynamic> data;
  late String _name; // 변수를 여기로 이동

  @override
  void initState() {
    super.initState();
    _name = context.read<UserInfoProvider>().name; // _name 변수 초기화
    data = widget.data; // 이전 페이지에서 전달된 데이터를 저장
  }

  @override
  Widget build(BuildContext context) {
    final content = data['content'] ?? '';
    final money = data['money'] ?? 0;
    final approve = data['approve'] ?? '';
    final createdDate = data['createdDate'] is String
        ? DateTime.tryParse(data['createdDate'] ?? '') ?? DateTime.now()
        : DateTime.now();

    return Scaffold(
      appBar: MyHeader(text: '조르기 모아보기'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RequestInfoDetailCard(
              name: _name,
              money: money,
              reason: content,
              status: approve,
              createdDate: createdDate,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '확인',
        isDisabled: false,
      ),
    );
  }
}
