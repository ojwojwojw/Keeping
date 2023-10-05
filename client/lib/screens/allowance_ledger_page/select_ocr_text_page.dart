// import 'package:flutter/material.dart';
// import 'package:keeping/provider/user_info.dart';
// import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
// import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
// import 'package:keeping/widgets/bottom_btn.dart';
// import 'package:keeping/widgets/completed_page.dart';
// import 'package:keeping/widgets/confirm_btn.dart';
// import 'package:keeping/widgets/header.dart';
// import 'package:keeping/widgets/rounded_modal.dart';
// import 'package:provider/provider.dart';

// class SelectOCRTextPage extends StatefulWidget {
//   dynamic response;
//   int accountHistoryId;

//   SelectOCRTextPage({
//     super.key,
//     required this.response,
//     required this.accountHistoryId,
//   });

//   @override
//   State<SelectOCRTextPage> createState() => _SelectOCRTextPageState();
// }

// class _SelectOCRTextPageState extends State<SelectOCRTextPage> {
//   List accountDetailList = [];
//   String? _accessToken;
//   String? _memberKey;

//   @override
//   void initState() {
//     super.initState();
//     accountDetailList =
//       widget.response.data['images'][0]['receipt']['result']['subResults'][0]['items'].map((e) =>
//         {
//           "accountHistoryId": widget.accountHistoryId,
//           "content": e['name']['formatted']['value'].toString(),
//           "money": e['price']['price']['formatted']['value'],
//           "smallCategory": null,
//         }
//       ).toList();
//     print(accountDetailList.toString());
//     _accessToken = context.read<UserInfoProvider>().accessToken;
//     _memberKey = context.read<UserInfoProvider>().memberKey;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyHeader(
//         text: '상세 내용 입력',
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: widget.response != null ? Column(
//             children: [
//               Text(widget.response.data['images'][0]['receipt']['result']['subResults'].toString(), style: TextStyle(fontSize: 10),),
//               Text('--------------------------------------------------------------'),
//               Text(widget.response.data['images'][0]['receipt']['result']['subResults'][0]['items'].toString(), style: TextStyle(fontSize: 10),),
//               Text('--------------------------------------------------------------'),
//               Text(widget.response.data['images'][0]['receipt']['result']['subResults'][0]['items'][0]['name']['formatted']['value'].toString(), style: TextStyle(fontSize: 10),),
//               Text(widget.response.data['images'][0]['receipt']['result']['subResults'][0]['items'][0]['price']['price']['formatted']['value'].toString(), style: TextStyle(fontSize: 10),),
//             ],
//           ) : null,
//         ),
//       ),
//       bottomSheet: BottomBtn(
//         text: '등록하기',
//         action: () async {
//           var response = await createAccountDetail(
//             accessToken: _accessToken, 
//             memberKey: _memberKey, 
//             accountDetailList: accountDetailList
//           );
//           if (response == 0) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => CompletedPage(
//                           text: '상세 내용이\n등록되었습니다.',
//                           button: ConfirmBtn(
//                             action: AllowanceLedgerPage(),
//                           ),
//                         )));
//           } else {
//             roundedModal(context: context, title: '문제가 발생했습니다. 다시 시도해주세요.');
//           }
//         },
//         isDisabled: false,
//       ),
//     );
//   }
// }