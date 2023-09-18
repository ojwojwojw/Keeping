import 'package:flutter/material.dart';

class AllowSearchBar extends StatefulWidget {
  AllowSearchBar({super.key});

  @override
  State<AllowSearchBar> createState() => _AllowSearchBarState();
}

class _AllowSearchBarState extends State<AllowSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.search, size: 35,),
            Text('1개월 전체 최신')
          ],
        ),
      )
    );
  }
}