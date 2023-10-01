// import 'package:flutter/material.dart';
// import 'package:keeping/screens/mission_detail_page/mission_detail_page.dart';

// // 미션박스 클래스
// class MissionBox extends StatefulWidget {
//   final Map<String, dynamic> mission;
//   MissionBox({required this.mission});
//   @override
//   State<MissionBox> createState() => _MissionBoxState();
// }

// // 미션박스 스테이트 클래스
// class _MissionBoxState extends State<MissionBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         style: ButtonStyle(
//           fixedSize: MaterialStateProperty.all(Size(350.0, 100.0)),
//           // backgroundColor: MaterialStateProperty.all(Color(0xFF8320E7)),
//           backgroundColor: MaterialStateProperty.resolveWith<Color>(
//               (Set<MaterialState> states) {
//             if (widget.mission["completed"] == "YET") {
//               return Color(0xFF8320E7);
//             } else if (widget.mission["completed"] == "LOADING") {
//               return Colors.red;
//             } else if (widget.mission["completed"] == "COMPLETE") {
//               return Colors.green;
//             } else {
//               return Colors.grey; // 기본값 설정
//             }
//           }),
//         ),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       MissionDetailPage(mission: widget.mission)));
//         },
//         child: Row(
//           children: [
//             Text(widget.mission["id"].toString() + "|",
//                 style: TextStyle(color: Colors.white, fontSize: 10)),
//             Text(widget.mission["todo"] + "|",
//                 style: TextStyle(color: Colors.white, fontSize: 10)),
//             Text(widget.mission["money"].toString() + "|",
//                 style: TextStyle(color: Colors.white, fontSize: 10)),
//             Text(widget.mission["deadline"] + "|",
//                 style: TextStyle(color: Colors.white, fontSize: 10)),
//             Text(widget.mission["completed"] + "|",
//                 style: TextStyle(color: Colors.white, fontSize: 10)),
//           ],
//         ),
//       ),
//     );
//   }
// }
