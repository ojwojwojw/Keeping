import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

class ColorInfoCard extends StatefulWidget {
  final String name;
  final String url;
  final String reason;
  final int cost;
  final int paidMoney;
  final String status;
  final DateTime createdDate;
  final Widget path;
  final String profileImage;

  ColorInfoCard({
    super.key,
    required this.name,
    required this.url,
    required this.reason,
    required this.cost,
    required this.paidMoney,
    required this.status,
    required this.createdDate,
    required this.path,
    required this.profileImage,
  });

  @override
  State<ColorInfoCard> createState() => _ColorInfoCardState();
}

class _ColorInfoCardState extends State<ColorInfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        noEffectTransition(context, widget.path);
        // Navigator.push(context, MaterialPageRoute(builder: (_) => widget.path));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 24),
        child: Container(
            height: 110,
            decoration: roundedBoxWithShadowStyle(borderRadius: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Column(
                children: [
                  _requestStatus(widget.status),
                  _requestContent(widget.name, widget.profileImage),
                ],
              ),
            )),
      ),
    );
  }
}

Widget _requestStatus(String status) {
  return Container(
    width: 360,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: requestStatusBgColor(status)),
    child: Text(
      requestStatusText('부탁', status),
      style: TextStyle(
          color: requestStatusTextColor(status), fontWeight: FontWeight.bold),
    ),
  );
}

Widget _requestContent(String name, String profileImage) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          categoryImg(profileImage),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '을(를) 부탁했어요!',
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                )
              ]
            ),
          ),
        ],
      ),
    ),
  );
}
