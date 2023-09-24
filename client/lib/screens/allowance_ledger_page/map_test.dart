import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

/// 중심좌표 변경 이벤트 등록하기
/// https://apis.map.kakao.com/web/sample/addMapCenterChangedEvent/
class MapTest extends StatefulWidget {
  const MapTest({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MapTest> createState() =>
      _MapTestState();
}

class _MapTestState extends State<MapTest> {
  late KakaoMapController mapController;

  String message = '';

  void _onMapCreated(KakaoMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // AuthRepository.initialize(appKey: 'b2768527932bfa91c8d7012e1da2f8bb');
    AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_API_KEY']!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: ((controller) async {
              mapController = controller;
            }),
            currentLevel: 8,
            onCenterChangeCallback: ((latlng, zoomLevel) {
              message = '지도 레벨은 $zoomLevel 이고\n';
              message +=
                  '중심 좌표는 위도 ${latlng.latitude},\n경도 ${latlng.longitude} 입니다';

              setState(() {});
            }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.white,
              child: Text(message),
            ),
          )
        ],
      ),
    );
  }
}