// import 'package:flutter/material.dart';
// import 'package:keeping/provider/request_money_provider.dart';
// import 'package:keeping/widgets/render_field.dart';
// import 'package:provider/provider.dart';

// Widget requestMoneyContent(BuildContext context) {
//   TextEditingController _content = TextEditingController();

//   void handleRequestMoneyContent(dynamic value) {
//     if (value is String) {
//       Provider.of<RequestMoneyProvider>(context, listen: false)
//           .updateRequestMoney(content: value, isContent: true);
//       print('하고 싶은 말 수정 중: $value');
//     } else {
//       Provider.of<RequestMoneyProvider>(context, listen: false)
//           .updateRequestMoney(isContent: false, content: value);
//     }
//   }

//   return Container(
//     child: Column(
//       children: [
//         // Text('얼마를 조를까요?'),
//         Builder(
//           builder: (BuildContext context) {
//             // Builder를 사용하여 새로운 빌드 컨텍스트를 얻습니다.
//             return renderBoxFormField(
//               label: '하고 싶은 말을 적어보세요!',
//               controller: _content,
//               onChange: handleRequestMoneyContent,
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }
