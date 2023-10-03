import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/rounded_modal.dart';

class SelectTypeBtn extends StatelessWidget {
  final Widget path;
  final String name;
  final String text;
  final String emoji;
  final bool parent;

  SelectTypeBtn({
    super.key,
    required this.path,
    required this.name,
    required this.text,
    required this.emoji,
    this.parent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => path));
        },
        child: Container(
          height: 172,
          decoration: roundedBoxWithShadowStyle(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name, 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: Color(0xFF9A9A9A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(emoji, style: TextStyle(fontSize: 50),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}