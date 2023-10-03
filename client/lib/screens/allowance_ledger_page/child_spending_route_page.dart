import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/child_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_page.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/floating_date_btn.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class ChildSpendingRoutePage extends StatefulWidget {
  const ChildSpendingRoutePage({super.key});

  @override
  State<ChildSpendingRoutePage> createState() => _ChildSpendingRoutePageState();
}

class _ChildSpendingRoutePageState extends State<ChildSpendingRoutePage> {
  KakaoMapController? mapController;

  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _accountNumber;
  String? _childKey;
  String? _childAccountNumber;
  // String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime _date = DateTime.now();

  void _setDate(val) {
    setState(() {
      // _date = DateFormat('yyyy-MM-dd').format(val);
      _date = val;
    });
  }

  void _onMapCreated(KakaoMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_API_KEY']!);
    _parent = context.read<UserInfoProvider>().parent;
    _accessToken = context.read<UserInfoProvider>().accessToken;
    _memberKey = context.read<UserInfoProvider>().memberKey;
    _accountNumber = context.read<AccountInfoProvider>().accountNumber;
    _childKey = context.read<ChildInfoProvider>().memberKey;
    _childAccountNumber = context.read<ChildInfoProvider>().accountNumber;
  }

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
      theme: ThemeData(
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: const Color(0xFF8320E7),
          todayBorder: BorderSide(color: Colors.white),
          todayBackgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
          dayOverlayColor: MaterialStateProperty.all<Color>(const Color(0xFF8320E7)),
          // surfaceTintColor: const Color(0xFF8320E7),
        ),
      ),
      home: Scaffold(
        appBar: MyHeader(
          text: '소비경로',
          bgColor: const Color(0xFF8320E7),
          elementColor: Colors.white,
          backPath: AllowanceLedgerPage(),
        ),
        body: FutureBuilder(
          future: getAccountListByDate(
            accessToken: _accessToken, 
            memberKey: _memberKey,
            targetKey: _parent != null && _parent! ? _childKey : _memberKey,
            accountNumber: _parent != null && _parent! ? _childAccountNumber : _accountNumber, 
            date: DateFormat('yyyy-MM-dd').format(_date),
          ),
          builder: (context, snapshot) {
            mapController?.clear();
            if (snapshot.hasData) {
              print('소비경로 페이지 ${snapshot.data}');
              var response = snapshot.data;
              if (response['resultBody'].isEmpty) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    KakaoMap(
                      onMapCreated: ((controller) async {
                        controller.clear();
                        _onMapCreated(controller);
                      }),
                    ),
                  FloatingDateBtn(setDate: _setDate, selectedDate: _date,)  // 커스텀 위젯
                  ]
                );
              }
              print('소비지도 응답값 ${response['resultBody'].values.first}');
              mapController?.setCenter(
                LatLng(response['resultBody'].values.first[0]['latitude'] as double, response['resultBody'].values.first[0]['longitude'] as double)
              );
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  KakaoMap(
                    onMapCreated: ((controller) async {
                      controller.clear();
                      _onMapCreated(controller);
                    }),
                    markers: [
                      ...response['resultBody'].values.first.map(
                        (e) => Marker(
                          markerId: e['storeName'] as String,
                          latLng: LatLng(
                            e['latitude'] as double,
                            e['longitude'] as double,
                          ),
                          // markerImageSrc: 'assets/image/category/${e['largeCategory']}.png'
                        ),
                      ),
                    ],
                    customOverlays: [
                      ...response['resultBody'].values.first.map(
                        (e) => CustomOverlay(
                          customOverlayId: e['storeName'], 
                          latLng: LatLng(
                            // double.parse((e['latitude']+0.0005).toString()),
                            e['latitude'],
                            e['longitude'],
                          ), 
                          yAnchor: 1.6,
                          content: '<div style="height: 60px; padding: 10px; display: flex; align-items: center; border-radius: 20px; border: 2px solid #F0F0F0; background: #FFF;"><div><span style="font-size: 18px; font-weight: 500;">${e['storeName']}</span></br><span style="color: #696969; font-size: 15px;">${formattedTime(DateTime.parse(e['createdDate']))}</span></div></div>'
                          // content: '<div style="height: 60px; padding: 10px; display: flex; align-items: center; border-radius: 20px; border: 2px solid #F0F0F0; background: #FFF;"><div><div><img src="assets/image/category/${e['largeCategory']}.png" alt="예시 이미지" height="50"></div><div><span style="font-size: 18px; font-weight: 500;">${e['storeName']}</span></br><span style="color: #696969; font-size: 15px;">${formattedTime(DateTime.parse(e['createdDate']))}</span></div></div></div>'

                        )
                      )
                    ],
                    polylines: [
                      Polyline(
                        polylineId: _date.toString(),
                        points: [...response['resultBody'].values.first.map((e) => LatLng(e['latitude'] as double , e['longitude'] as double))],
                        strokeColor: const Color(0xFF8320E7),
                        strokeStyle: StrokeStyle.dashDot
                      )
                    ],
                    zoomControl: true,
                  ),
                  FloatingDateBtn(setDate: _setDate, selectedDate: _date,)  // 커스텀 위젯
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  KakaoMap(
                    onMapCreated: ((controller) async {
                      controller.clear();
                      _onMapCreated(controller);
                    }),
                  ),
                  FloatingDateBtn(setDate: _setDate, selectedDate: _date,)  // 커스텀 위젯
                ]
              );
            }
          }
        )
      ),
    );
  }
}

// '''
// <div style="height: 60px; padding: 10px; display: flex; align-items: center; border-radius: 20px; border: 2px solid #F0F0F0; background: #FFF;">
//   <div>
//     <div>
//       <img src="assets/image/category/${e['largeCategory']}.png" alt="예시 이미지" height="50">
//     </div>
//     <div>
//       <span style="font-size: 18px; font-weight: 500;">${e['storeName']}</span>
//       </br>
//       <span style="color: #696969; font-size: 15px;">${formattedTime(DateTime.parse(e['createdDate']))}</span>
//     </div>
//   </div>
// </div>'
// '''

// <div style="height: 60px; padding: 10px; display: flex; align-items: center; border-radius: 20px; border: 2px solid #F0F0F0; background: #FFF;"><div><div><img src="assets/image/category/${e['largeCategory']}.png" alt="예시 이미지" height="50"></div><div><span style="font-size: 18px; font-weight: 500;">${e['storeName']}</span></br><span style="color: #696969; font-size: 15px;">${formattedTime(DateTime.parse(e['createdDate']))}</span></div></div></div>'