// import 'package:flutter/material.dart';

// class PiggyNameMarquee extends StatefulWidget {
//   final List<Widget> items;
//   final Duration moveDuration;

//   PiggyNameMarquee({
//     super.key,
//     required this.items,
//     this.moveDuration = const Duration(milliseconds: 100),
//   });

//   @override
//   State<PiggyNameMarquee> createState() => _PiggyNameMarqueeState();
// }

// class _PiggyNameMarqueeState extends State<PiggyNameMarquee> {
//   ScrollController? _scrollController;
//   double _position = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       Future.doWhile(_scroll);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       child: ListView.builder(
//           itemBuilder: (context, index) {
//             return Center(
//               child: widget.items[index % widget.items.length]
//             );
//           },
//           scrollDirection: Axis.horizontal,
//           controller: _scrollController,
//           physics: NeverScrollableScrollPhysics(), // not allow the user to scroll.
//       ),
//     );
//   }

//   @override
//   void dispose(){
//     _scrollController!.dispose();
//     super.dispose();
//   }

//   Future<bool> _scroll() async {
//     double _moveDistance = 10.0;

//     _position += _moveDistance;
//     _scrollController!.animateTo(_position, duration: widget.moveDuration, curve: Curves.linear);

//     await Future.delayed(widget.moveDuration);
//     return true;
//   }
// }