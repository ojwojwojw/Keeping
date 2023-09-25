import 'package:flutter/material.dart';
import 'package:keeping/provider/piggy_provider.dart';
import 'package:keeping/screens/piggy_page/widgets/piggy_detail_chart.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/display_format.dart';
import 'package:provider/provider.dart';

const String type = 'PARENT';

class PiggyDetailInfo extends StatefulWidget {
  PiggyDetailInfo({
    super.key,
  });

  @override
  State<PiggyDetailInfo> createState() => _PiggyDetailInfoState();
}

class _PiggyDetailInfoState extends State<PiggyDetailInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8320E7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 40, bottom: 20),
            //   child: Text(
            //     context.watch<PiggyDetailProvider>().content!,
            //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  if (type == 'PARENT') _childTag(childName: '김첫째'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      roundedAssetImg(imgPath: 'assets/image/temp_image.jpg', size: 120),
                      Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              context.watch<PiggyDetailProvider>().content!,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Text(formattedMoney(context.watch<PiggyDetailProvider>().balance), style: TextStyle(fontSize: 40, color: Colors.white),),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            PiggyDetailChart(balance: 50, goalMoney: 100, createdDate: DateTime.parse('2020-10-10T14:58:04+09:00'),)
          ],
        ),
      ),
    );
  }
}

Widget _childTag({required String childName}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: _childTagStyle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text('$childName 저금통', style: TextStyle(fontSize: 18, color: Colors.white),),
      )
    ),
  );
}

BoxDecoration _childTagStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(50.0), // 둥근 테두리 반경 설정
    border: Border.all(
      color: Colors.white, // 테두리 색상 설정
      width: 1.0, // 테두리 두께 설정
    ),
  );
}