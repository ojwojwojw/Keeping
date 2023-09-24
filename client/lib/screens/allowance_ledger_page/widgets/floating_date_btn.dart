import 'package:flutter/material.dart';
import 'package:keeping/util/display_format.dart';

// 자녀 소비경로 페이지에서 날짜를 넘길 수 있는 버튼
class FloatingDateBtn extends StatefulWidget {


  FloatingDateBtn({super.key});

  @override
  State<FloatingDateBtn> createState() => _FloatingDateBtnState();
}

class _FloatingDateBtnState extends State<FloatingDateBtn> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      child: Container(
        width: 170,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 그림자 색상
              spreadRadius: 2, // 그림자 전파 반경
              blurRadius: 5, // 그림자 흐림 반경
              offset: Offset(0, 2), // 그림자의 X, Y 오프셋
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.arrow_left, size: 35),
            InkWell(
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  locale: const Locale('ko', 'KR'),
                );
                if (newDate != null ) {
                  setState(() {
                    selectedDate = newDate;
                  });
                  // 새로 소비 경로 불러오는 함수 호출??
                }
              },
              child: Text(formattedMDDate(selectedDate), style: TextStyle(fontSize: 20))
            ),
            Icon(Icons.arrow_right, size: 35,),
          ],
        ),
      ),
    );
  }
}