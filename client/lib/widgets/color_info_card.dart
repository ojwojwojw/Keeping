import 'package:flutter/material.dart';
import 'package:keeping/styles.dart';
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
  });

  @override
  State<ColorInfoCard> createState() => _ColorInfoCardState();
}

class _ColorInfoCardState extends State<ColorInfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget.path));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Container(
          width: 360,
          height: 120,
          decoration: roundedBoxWithShadowStyle(borderRadius: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Column(
              children: [
                _requestStatus(widget.status),
                _requestContent(widget.name),
              ],
            ),
          ) 
        ),
      ),
    );
  }
}

Widget _requestStatus(String status) {
  return Container(
    width: 360,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: requestStatusBgColor(status)
    ),
    child: Text(
      requestStatusText(status), 
      style: TextStyle(color: requestStatusTextColor(status), fontWeight: FontWeight.bold),
    ),
  );
}

Widget _requestContent(String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
      Text('을(를) 부탁했어요!')
    ]
  );
}