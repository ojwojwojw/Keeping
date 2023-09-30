import 'package:flutter/material.dart';

// 하단 네모난 버튼 클래스
class BottomDoubleBtn extends StatelessWidget {
  final String firstText;
  final Color firstBgColor;
  final Color firstTextColor;
  final double firstTextSize;
  final dynamic firstAction;
  final String secondText;
  final Color secondBgColor;
  final Color secondTextColor;
  final double secondTextSize;
  final dynamic secondAction;
  final bool isDisabled;

  BottomDoubleBtn({
    super.key,
    this.firstText = '취소',
    this.firstBgColor = const Color(0xFFF0F0F0),
    this.firstTextColor = const Color(0xFF8320E7),
    this.firstTextSize = 22,
    this.firstAction,
    this.secondText = '확인',
    this.secondBgColor = const Color(0xFF8320E7),
    this.secondTextColor = Colors.white,
    this.secondTextSize = 22,
    this.secondAction,
    this.isDisabled = true,
  });

  // 특정 페이지로 가던지, 데이터를 보내던지, 이전 페이지로 돌아가던지 구분해서 로직 짜기

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        // height: 70,
        width: double.infinity,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: 70,
                color: isDisabled ? Colors.black38 : firstBgColor,
                child: TextButton(
                  onPressed: () {
                    if (!isDisabled) {
                      if (firstAction is Widget) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => firstAction));
                      } else if (firstAction is Function) {
                        firstAction();
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: _bottomBtnStyle(firstTextColor),
                  child: Text(firstText, style: TextStyle(fontSize: firstTextSize),),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                height: 70,
                color: isDisabled ? Colors.black38 : secondBgColor,
                child: TextButton(
                  onPressed: () {
                    if (!isDisabled) {
                      if (secondAction is Widget) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => secondAction));
                      } else if (secondAction is Function) {
                        secondAction();
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: _bottomBtnStyle(secondTextColor),
                  child: Text(secondText, style: TextStyle(fontSize: secondTextSize),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 버튼 스타일
ButtonStyle _bottomBtnStyle(Color textColor) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color>(textColor),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: 25.0, color: textColor),
    ),
  );
}
