import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

class ColorInfoDetailCard extends StatefulWidget {

  ColorInfoDetailCard({
    super.key,
  });

  @override
  State<ColorInfoDetailCard> createState() => _ColorInfoDetailCardState();
}

class _ColorInfoDetailCardState extends State<ColorInfoDetailCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => widget.path));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Container(
          width: 300,
          decoration: roundedBoxWithShadowStyle(borderRadius: 30, shadow: false, border: true, borderColor: const Color(0xFFFFDDDD)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                colorInfoCardStatus(300),
                colorInfoDetailCardContents(
                  Column(
                    children: [
                      colorInfoDetailCardContent('금액'),
                      colorInfoDetailCardContent('구매 URL', box: false),
                      colorInfoDetailCardContent('안녕하세요'),
                      colorInfoDetailCardContent('금액'),
                      colorInfoDetailCardContent('구매 URL'),
                      colorInfoDetailCardContent('안녕하세요'),
                      colorInfoDetailCardContent('금액'),
                      colorInfoDetailCardContent('구매 URL'),
                      colorInfoDetailCardContent('안녕하세요'),
                    ],
                  )
                ),
              ],
            ),
          ) 
        ),
      ),
    );
  }
}