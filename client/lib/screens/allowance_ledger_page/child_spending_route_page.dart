import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/floating_date_btn.dart';
import 'package:keeping/widgets/header.dart';

class ChildSpendingRoutePage extends StatefulWidget {
  const ChildSpendingRoutePage({super.key});

  @override
  State<ChildSpendingRoutePage> createState() => _ChildSpendingRoutePageState();
}

class _ChildSpendingRoutePageState extends State<ChildSpendingRoutePage> {
  late KakaoMapController mapController;

  // 임시 더미데이터 
  final _places = [
    {
      "date": "2023-09-07",
      'store_name': '싸피',
      'latitude': 35.205472,
      'longitude': 126.811582,
    },
    {
      "date": "2023-09-07",
      'store_name': '컴포즈 커피',
      'latitude': 35.200478,
      'longitude': 126.814354,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.203040,
      'longitude': 126.818698,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.204040,
      'longitude': 126.818698,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.205040,
      'longitude': 126.818698,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.206040,
      'longitude': 126.818698,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.207040,
      'longitude': 126.818698,
    },
    {
      "date": "2023-09-07",
      'store_name': '스타벅스',
      'latitude': 35.208040,
      'longitude': 126.818698,
    },
    // {
    //   "date": "2023-09-07",
    //   'store_name': '스타벅스',
    //   'latitude': 35.209040,
    //   'longitude': 126.818698,
    // },
    // {
    //   "date": "2023-09-07",
    //   'store_name': '스타벅스',
    //   'latitude': 35.210040,
    //   'longitude': 126.818698,
    // },
    // {
    //   "date": "2023-09-07",
    //   'store_name': '스타벅스',
    //   'latitude': 35.211040,
    //   'longitude': 126.818698,
    // },
    // {
    //   "date": "2023-09-07",
    //   'store_name': '스타벅스',
    //   'latitude': 35.212040,
    //   'longitude': 126.818698,
    // },
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeKakaoMap();
  // }

  // // 카카오맵 초기화 및 설정
  // void _initializeKakaoMap() async {
  //   await dotenv.load(fileName: 'assets/env/.env');
  //   final appKey = dotenv.env['KAKAO_APP_KEY'] ?? '';

  //   AuthRepository.initialize(appKey: 'b2768527932bfa91c8d7012e1da2f8bb');
  // }

  final markers = <Marker>{};

  void _onMapCreated(KakaoMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_API_KEY']!);
    markers.addAll(
      _places.map(
        (e) => Marker(
          markerId: e['store_name'] as String,
          latLng: LatLng(
            e['latitude'] as double,
            e['longitude'] as double,
          ),
          // infoWindowContent: '<div>안녕</div>',
          infoWindowContent: '''
            <div
              style="border: 2px solid black; border-radius: 10px; padding: 10px;
            >
              ${e['store_name']}
            </div>
          ''',
          infoWindowFirstShow: true,
          // infoWindowRemovable: true,
        ),
      ),
    );
    super.initState();
  }

  final String storeName = '싸피';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR')
      ],
      home: Scaffold(
          appBar: MyHeader(
            text: '소비경로',
            bgColor: Colors.purple,
            elementColor: Colors.white,
          ),
          body: FutureBuilder(
            future: getAccountListByDate(accessToken: 'accessToken', memberKey: 'memberKey', accountNumber: 'accountNumber', date: '2023-01-01'),
            builder: (context, snapshot) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  KakaoMap(
                    onMapCreated: ((controller) async {
                      mapController = controller;
                    }),
                    center: LatLng(_places.first['latitude'] as double, _places.first['longitude'] as double),
                    // markers: markers.toList(),
                    markers: [
                      Marker(
                        markerId: '싸피',
                        latLng: LatLng(
                          35.205472,
                          126.811582,
                        ),
                        infoWindowContent: '<div style="border: 2px solid red; border-radius: 10px; padding: 10px;">$storeName</div>',
                        // infoWindowContent: '''
                        //   <div
                        //     style="border: 2px solid black; border-radius: 10px; padding: 10px;"
                        //   >
                        //     $storeName
                        //   </div>
                        // ''',
                        infoWindowFirstShow: true,
                        // infoWindowRemovable: true,
                      ),
                    ],
                    polylines: [
                      Polyline(
                        polylineId: '9월 1일',
                        points: _places.map((e) => LatLng(e['latitude'] as double, e['longitude'] as double)).toList(),
                        strokeColor: Colors.blue,
                        strokeStyle: StrokeStyle.dashDot
                      )
                    ],
                    zoomControl: true,
                  ),
                  FloatingDateBtn()  // 커스텀 위젯
                ],
              );
            }
          )
      ),
    );
  }
}