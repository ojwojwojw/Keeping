import 'package:flutter/material.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/money_record.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:provider/provider.dart';

class MoneyRecordWithDetail extends StatefulWidget {
  final DateTime date;
  final String storeName;
  final int money;
  final int balance;
  final int accountHistoryId;
  final String largeCategory;
  final List<dynamic> detail;
  final bool type;

  MoneyRecordWithDetail({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    required this.accountHistoryId,
    required this.largeCategory,
    required this.detail,
    required this.type,
  });

  @override
  State<MoneyRecordWithDetail> createState() => _MoneyRecordWithDetail();
}

class _MoneyRecordWithDetail extends State<MoneyRecordWithDetail> {
  bool? _parent;

  @override
  void initState() {
    super.initState();
    _parent = context.read<UserInfoProvider>().parent;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: _parent != null && _parent! ? null : () {
        bottomModal(
          context: context,
          title: '상세 내역 쓰기',
          content: moneyRecordModalContent(
            context, widget.date, widget.storeName, widget.money, widget.balance, widget.accountHistoryId, widget.type, widget.largeCategory
          ),
          button: moneyRecordModalBtns(context, widget.accountHistoryId),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
        child: Center(
          child: Container(
            decoration: roundedBoxWithShadowStyle(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _mainMoneyRecord(
                    widget.storeName, widget.date, widget.money, widget.balance, widget.type, widget.largeCategory
                  ),
                  _detailMoneyRecords(widget.detail, widget.type),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _mainMoneyRecord(String storeName, DateTime date, num money, num balance, bool type, String largeCategory) {
  return Container(
    height: 90,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: categoryImg('assets/image/category/$largeCategory.png'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 170,
                    child: Text(
                      storeName, 
                      style: bigStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formattedTime(date),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${type?'+':'-'}${formattedMoney(money)}', style: bigStyle(),),
              Text(formattedMoney(balance))
            ],
          )
        ),
      ],
    ),
  );
}

Widget _detailMoneyRecords(List<dynamic> detail, bool type) {
  return Container(
    color: Color.fromARGB(255, 242, 242, 242),
    child: Column(
      children: detail.map((e) => 
        _detailMoneyRecord(
          e['content'], e['money'], type, e['smallCategory']
        )
      ).toList()
    ),
  );
}

Widget _detailMoneyRecord(String content, int money, bool type, String smallCategory) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Container(
      height: 90,
      alignment: Alignment.center,
      color: Colors.transparent,
      // decoration: moneyRecordStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: categoryImg('assets/image/category/$smallCategory.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 170,
                      child: Text(
                        content, 
                        style: bigStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${type?'+':'-'}${formattedMoney(money)}', style: bigStyle(),),
              ],
            )
          ),
        ],
      ),
    )
  );
}