// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';


// Widget authenticationBtn() {
//   return ElevatedButton(
//     onPressed: () async {
//       final response = await validatePhoneNumber(
//         '/member-service/phone',
//         {'Authorization': 'yoon.ye.ji'}
//       );
//     },
//     style: authenticationBtnStyle(),
//     child: Text('인증번호'),
//   );
// }

// ButtonStyle authenticationBtnStyle() {
//   return ButtonStyle(
//     backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//     foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
//     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//       RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(
//           color: const Color(0xFF8320E7), // 테두리 색상 설정
//           width: 2.0, // 테두리 두께 설정
//         ),
//       )
//     ),
//     fixedSize: MaterialStateProperty.all<Size>(
//       Size(90, 40)
//     )
//   );
// }

// Future<List<dynamic>?> validatePhoneNumber(String url, Map<String, String>? headers) async {
//   try {
//     var response = await http.post(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body);
//       return result;
//     } else {
//       print('HTTP Request Failed with status code: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error during HTTP request: $e');
//     return null;
//   }
// }