import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/mission_detail_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';

class MissionColorInfoCard extends StatefulWidget {
  final String status;
  final DateTime createdDate;
  final dynamic todo;
  final dynamic item;

  MissionColorInfoCard({
    super.key,
    required this.status,
    required this.createdDate,
    required this.todo,
    required this.item,
  });

  @override
  State<MissionColorInfoCard> createState() => _MissionColorInfoCardState();
}

class _MissionColorInfoCardState extends State<MissionColorInfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MissionDetailPage(item: widget.item),
            // builder: (context) => ParentMissionDetailPage(item: widget.item),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Text(formattedMDDate(widget.createdDate))
              ],
            ),
            SizedBox(height: 4,),
            Container(
                height: 110,
                decoration: roundedBoxWithShadowStyle(borderRadius: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    children: [
                      _requestStatus(widget.status),
                      _requestContent(widget.todo),
                    ],
                  ),
                )),
          ],
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
    decoration: BoxDecoration(color: missionRequestStatusBgColor(status)),
    child: Text(
      missionRequestStatusText(status),
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _requestContent(String name) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          categoryImg('assets/image/temp_image.jpg'),
          SizedBox(
            width: 250,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}
