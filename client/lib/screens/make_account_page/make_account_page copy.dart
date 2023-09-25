//   Widget makeAccountBtn() {
//     return ElevatedButton(
//       onPressed: () async {
//         final response = await dioPost(
//           accessToken: accessToken,
//           url: '/bank-service/account/yoonyeji',
//           data: {
//             'authPassword': '123456'
//           }
//         );  // 3분 30초
//         if (response != null) {
//           setState(() {
//             // makeAccountResult = response.toString();
//           });
//         } else {
//           setState(() {
//             // makeAccountResult = '개설 실패';
//           });
//         }
//       },
//       style: authenticationBtnStyle(),
//       child: Text('개설하기'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyHeader(text: '계좌 만들기'),
//       body: Form(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(child: renderPhoneVerificationText()),
//                       verificationBtn(),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   makeAccountBtn(),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomBtn(
//         text: '다음',
//         action: () {},
//         isDisabled: false,
//       ),
//     );
//   }
// }

// Widget renderPhoneVerificationText() {
//   return BuildTextFormField(
//     controller: _phoneVerification,
//     labelText: '인증 번호',
//     hintText: '인증 번호를 입력해 주세요.',
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return '인증 번호를 입력해 주세요.';
//       }
//       return null;
//     }
//   );
// }

// Widget BuildTextFormField({
//   required TextEditingController controller,
//   required String labelText,
//   required String hintText,
//   required String? Function(String?) validator,
//   bool obscureText = false,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         validator: validator,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         decoration: InputDecoration(
//           labelText: labelText,
//           hintText: hintText
//         ),
//       ),
//       SizedBox(height: 16,)
//     ],
//   );
// }
