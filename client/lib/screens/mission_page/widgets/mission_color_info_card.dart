import 'package:flutter/material.dart';
import 'package:keeping/screens/mission_page/mission_detail_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/color_info_card_elements.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final _baseUrl = dotenv.env['BASE_URL'];

class MissionColorInfoCard extends StatefulWidget {
  final String status;
  final DateTime createdDate;
  final dynamic todo;
  final dynamic item;
  final dynamic profileImage;
  final Function onMissionDeleted;

  MissionColorInfoCard({
    super.key,
    required this.status,
    required this.createdDate,
    required this.todo,
    required this.item,
    required this.profileImage,
    required this.onMissionDeleted,
  });

  @override
  State<MissionColorInfoCard> createState() => _MissionColorInfoCardState();
}

class _MissionColorInfoCardState extends State<MissionColorInfoCard> {
  String setImgPath(status) {
    if (status == 'YET') {
      return 'assets/image/face/face1.png';
    } else if (status == 'FINISH_WAIT') {
      return 'assets/image/face/face2.png';
    } else if (status == 'FINISH') {
      return 'assets/image/face/face4.png';
    } else {
      return 'assets/image/face/face3.png';
    }
  }

  ///미션 삭제 함수
  _deleteMission(int missionId) async {
    // 로그인한 유저의 멤버키 및 액세스 토큰 가져오기
    var userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    var memberKey = userProvider.memberKey;
    var accessToken = userProvider.accessToken;

    // Dio 객체 생성
    final dio = Dio();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.delete(
        Uri.parse("$_baseUrl/mission-service/api/$memberKey/$missionId"),
        headers: headers,
      );


      if (response.statusCode == 200) {
        print("미션 삭제 성공");
        print(missionId);
        // 댓글 목록을 업데이트하려면 setState를 호출합니다.
        setState(() {});
        widget.onMissionDeleted();
      } else {
        print("미션 삭제 실패: ");
      }
    } catch (error) {
      print("미션 삭제 중 오류 발생: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // 꾸욱 누르면 삭제 확인 모달 표시
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('미션 삭제'),
            content: Text('미션을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  _deleteMission(widget.item['id']); // 미션 삭제 함수 호출
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: InkWell(
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
                children: [Text(formattedMDDate(widget.createdDate))],
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                  height: 110,
                  decoration: roundedBoxWithShadowStyle(borderRadius: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Column(
                      children: [
                        _requestStatus(widget.status),
                        _requestContent(widget.todo, setImgPath(widget.status)),
                      ],
                    ),
                  )),
            ],
          ),
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
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          roundedAssetImg(
              imgPath: profileImage,
              size: 64),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),
        ],
      ),
    ),
  );
}
