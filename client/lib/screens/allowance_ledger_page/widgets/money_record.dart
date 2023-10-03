import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keeping/provider/account_info_provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:keeping/screens/allowance_ledger_page/allowance_ledger_detail_create_page.dart';
import 'package:keeping/screens/allowance_ledger_page/select_ocr_img_page.dart';
import 'package:keeping/styles.dart';
import 'package:keeping/util/camera_test2.dart';
import 'package:keeping/util/display_format.dart';
import 'package:keeping/util/ocr_test.dart';
import 'package:keeping/widgets/bottom_modal.dart';
import 'package:provider/provider.dart';

class MoneyRecord extends StatefulWidget {
  final DateTime date;
  final String storeName;
  final int money;
  final int balance;
  final int accountHistoryId;
  final String largeCategory;
  final Map<String, dynamic>? detail;
  final bool onlyTime;
  final bool type;

  MoneyRecord({
    super.key,
    required this.date,
    required this.storeName,
    required this.money,
    required this.balance,
    required this.accountHistoryId,
    required this.largeCategory,
    this.detail,
    this.onlyTime = true,
    required this.type,
  });

  @override
  State<MoneyRecord> createState() => _MoneyRecordState();
}

class _MoneyRecordState extends State<MoneyRecord> {
  bool? parent;

  @override
  void initState() {
    super.initState();
    parent = context.read<UserInfoProvider>().parent;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: parent != null && parent! ? null : () {
        bottomModal(
          context: context,
          title: '상세 내역 쓰기',
          content: moneyRecordModalContent(
            context, widget.date, widget.storeName, widget.money, widget.balance, widget.accountHistoryId, widget.type, widget.largeCategory
          ),
          button: moneyRecordModalBtns(context, widget.accountHistoryId),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          width: 360,
          height: 90,
          alignment: Alignment.center,
          decoration: roundedBoxWithShadowStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: categoryImg('assets/image/temp_image.jpg'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.storeName,
                        style: bigStyle(),
                      ),
                      Text(
                        widget.onlyTime
                            ? formattedTime(widget.date)
                            : formattedFullDate(widget.date),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.type?'+':'-'}${formattedMoney(widget.money)}',
                        style: bigStyle(),
                      ),
                      Text(formattedMoney(widget.balance))
                    ],
                  )),
            ],
          ),
            
        )
      )
    );
  }
}

// 용돈기입장 내역 큰 글씨
TextStyle bigStyle() {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
}

// 용돈기입장 내역 작고 옅은 글씨
TextStyle smallStyle() {
  return TextStyle(color: const Color(0xFF696969));
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어갈 내용
Widget moneyRecordModalContent(
  BuildContext context, DateTime date, String storeName, int money, int balance, int accountHistoryId, bool? type, String largeCategory
) {

  Provider.of<AccountDetailProvider>(context, listen: false).setAccountDetail({
    'createdDate': date,
    'storeName' : storeName,
    'money' : money,
    'balance': balance,
    'id': accountHistoryId,
    'type': type,
    'largeCategory': largeCategory,
  });


  return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 236, 236, 236), // 위쪽 테두리 색상
            width: 2.0, // 위쪽 테두리 두께
          ),
          bottom: BorderSide(
            color: Color.fromARGB(255, 236, 236, 236), // 아래쪽 테두리 색상
            width: 2.0, // 아래쪽 테두리 두께
          ),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(formattedMDDate(date)),
              ]),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    storeName,
                    style: bigStyle(),
                  ),
                  Text(
                    formattedMoney(money).toString(),
                    style: bigStyle(),
                  )
                ],
              )
            ],
          )));
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어갈 버튼(2개)
Row moneyRecordModalBtns(BuildContext context, int accountHistoryId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      moneyRecordModalBtn(
        '🧾', 
        '영수증 찍기', 
        context, 
        'camera',
        accountHistoryId
      ),
      SizedBox(width: 16,),
      moneyRecordModalBtn(
        '🖊️',
        '직접 쓰기',
        context,
        AllowanceLedgerDetailCreatePage(),
        accountHistoryId
      )
    ],
  );
}

// 용돈기입장 내역 클릭시 나오는 모달에 들어가는 버튼 한 개
Widget moneyRecordModalBtn(
    String icon, String text, BuildContext context, dynamic path, int accountHistoryId) {
  return Expanded(
    child: InkWell(
        onTap: path is Widget ?
          () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => path));
          }
        :
          () {
            Navigator.pop(context);
            bottomModal(
              context: context, 
              title: '영수증 찍기', 
              content: _selectCameraOrGallery(context, accountHistoryId),
              button: Container()
            );
          },
        child: Container(
          width: 150,
          height: 150,
          decoration: _moneyRecordModalBtnStyle(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 4,),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        )),
  );
}

// 용돈기입장 내역 클릭시 나오는 모달 버튼 스타일
BoxDecoration _moneyRecordModalBtnStyle() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: Color.fromARGB(255, 236, 236, 236), // 테두리 색상
      width: 2.0, // 테두리 두께
    ),
  );
}

void _takePhoto() async {
  ImagePicker().pickImage(source: ImageSource.camera).then((value) {
    if (value != null && value.path != null) {
      print("저장경로 : ${value.path}");

      GallerySaver.saveImage(value.path).then((value) {
        print("사진이 저장되었습니다");
      });
    }
  });
}

Widget _selectCameraOrGallery(BuildContext context, int accountHistoryId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: InkWell(
          onTap: () async {
            final file = await ImagePicker().pickImage(source: ImageSource.camera);
            if (file == null) return;
            Navigator.push(context, MaterialPageRoute(builder: (_) => SelectOCRImgPage(imgPath: file.path, accountHistoryId: accountHistoryId,)));
          },
          child: Container(
            height: 150,
            decoration: _moneyRecordModalBtnStyle(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '📷',
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(height: 4,),
                Text(
                  '촬영하기',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
      SizedBox(width: 16,),
      Expanded(
        child: InkWell(
          onTap: () async {
            final imgPath = await _getFromGallery();
            if (imgPath == null) return;
            Navigator.push(context, MaterialPageRoute(builder: (_) => SelectOCRImgPage(imgPath: imgPath, accountHistoryId: accountHistoryId,)));
          },
          child: Container(
            height: 150,
            decoration: _moneyRecordModalBtnStyle(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '🖼️',
                  style: TextStyle(fontSize: 50),
                ),
                SizedBox(height: 4,),
                Text(
                  '선택하기',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Future<dynamic> _getFromGallery() async {
  final pickedFile =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
  if (pickedFile == null) {
    return null;
  }
  dynamic imgPath = pickedFile.path;

  return imgPath;
}