import 'package:flutter/material.dart';
import 'package:keeping/widgets/bottom_nav.dart';

class ParentMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(),
          Row(
            children: [
              Container(),
              Container()
            ],
          ),
          Row(
            children: [
              Container(),
              Container()
            ],
          ),
          Container()
        ],
      ),
      bottomNavigationBar: BottomNav()
    );
  }
}