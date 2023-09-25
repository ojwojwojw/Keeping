// import 'package:flutter/material.dart';
// import 'package:keeping/widgets/password_keyboard.dart';

// class EnterAuthPassword extends StatefulWidget {
//   EnterAuthPassword({
//     super.key,
//   });

//   @override
//   State<EnterAuthPassword> createState() => _EnterAuthPasswordState();
// }

// class _EnterAuthPasswordState extends State<EnterAuthPassword> {
//   String? authPassword;

//   setAuthPassword(String value) {
//     setState(() {
//       authPassword = value;
//     });
//   }

//   onNumberPress(val) {
//     if (authPassword != null && authPassword!.length >= 6) {
//       return;
//     } else if (authPassword == null) {
//       setState(() {
//         authPassword = val;
//       });
//     } else {
//       setState(() {
//         authPassword = authPassword! + val;
//       });
//     }

//   }

//   onBackspacePress() {
//     if (authPassword == null || authPassword!.isEmpty) {
//       return;
//     }

//     setState(() {
//       authPassword = authPassword!.substring(0, authPassword!.length - 1);
//     });
//   }

//   onClearPress() {
//     setState(() {
//       authPassword = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 60,),
//           child: Column(
//             children: [
//               Text('비밀번호 입력', style: TextStyle(fontSize: 27),),
//               SizedBox(height: 7,),
//               Text('결제 비밀번호를 입력해 주세요.', style: TextStyle(fontSize: 15, color: Colors.black54),),
//               passwordCircles(authPassword != null ? authPassword!.length : 0),
//               Text(authPassword.toString())
//             ],
//           ),
//         ),
//         PasswordKeyboard(
//           onNumberPress: onNumberPress,
//           onBackspacePress: onBackspacePress,
//           onClearPress: onClearPress
//         ),
//       ],
//     );
//   }
// }

// Widget passwordCircles(int inputLen) {
//   return Center(
//     child: Padding(
//       padding: EdgeInsets.only(top: 40),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           passwordCircle(1, inputLen),
//           passwordCircle(2, inputLen),
//           passwordCircle(3, inputLen),
//           passwordCircle(4, inputLen),
//           passwordCircle(5, inputLen),
//           passwordCircle(6, inputLen),
//         ],
//       ),
//     ),
//   );
// }

// Widget passwordCircle(int order, int inputLen) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 10),
//     child: Container(
//       width: 15,
//       height: 15,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: order > inputLen ? Colors.black26 : const Color(0xFF8320E7),
//       ),
//     ),
//   );
// }

