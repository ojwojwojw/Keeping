import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/utils/allowance_ledger_future_methods.dart';
import 'package:keeping/screens/allowance_ledger_page/widgets/floating_date_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:provider/provider.dart';

class ChildSpendingRoutePage extends StatefulWidget {
  const ChildSpendingRoutePage({super.key});

  @override
  State<ChildSpendingRoutePage> createState() => _ChildSpendingRoutePageState();
}

class _ChildSpendingRoutePageState extends State<ChildSpendingRoutePage> {
  late KakaoMapController mapController;

  bool? _parent;
  String? _accessToken;
  String? _memberKey;
  String? _childKey;
  String? _accountNumber;
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void _setDate(val) {
    setState(() {
      _date = DateFormat('yyyy-MM-dd').format(val);
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
    // _balance = context.read<UserInfoProvider>().balance;
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
      home: Scaffold(
          appBar: MyHeader(
            text: '소비경로',
            bgColor: Colors.purple,
            elementColor: Colors.white,
          ),
          body: FutureBuilder(
            future: getAccountListByDate(
              accessToken: _accessToken, 
              memberKey: _memberKey,
              targetKey: _parent != null && _parent! ? _childKey : _memberKey,
              accountNumber: _accountNumber, 
              date: _date,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('소비경로 페이지 ${snapshot.data}');
                var response = snapshot.data;
                if (response['resultBody'].isEmpty) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      KakaoMap(
                        onMapCreated: ((controller) async {
                          _onMapCreated(controller);
                        }),
                      ),
                    FloatingDateBtn(setDate: _setDate)  // 커스텀 위젯
                    ]
                  );
                }
                print('소비지도 응답값 ${response['resultBody'].values.first}');
                mapController.setCenter(
                  LatLng(response['resultBody'].values.first[0]['latitude'] as double, response['resultBody'].values.first[0]['longitude'] as double)
                );
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    KakaoMap(
                      onMapCreated: ((controller) async {
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
                          ),
                        ),
                      ],
                      polylines: [
                        Polyline(
                          polylineId: _date.toString(),
                          points: [...response['resultBody'].values.first.map((e) => LatLng(e['latitude'] as double, e['longitude'] as double))],
                          strokeColor: Colors.blue,
                          strokeStyle: StrokeStyle.dashDot
                        )
                      ],
                      zoomControl: true,
                    ),
                    FloatingDateBtn(setDate: _setDate)  // 커스텀 위젯
                  ],
                );
              } else {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    KakaoMap(
                      onMapCreated: ((controller) async {
                        _onMapCreated(controller);
                      }),
                    ),
                    FloatingDateBtn(setDate: _setDate)  // 커스텀 위젯
                  ]
                );
              }
            }
          )
      ),
    );
  }
}