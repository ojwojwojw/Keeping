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
      child: Row(
        children: const [
          Icon(Icons.search)
        ],
      ),
    );
  }
}