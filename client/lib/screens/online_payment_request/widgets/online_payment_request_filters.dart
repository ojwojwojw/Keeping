import 'package:flutter/material.dart';

class OnlinePaymentRequestFilters extends StatefulWidget {
  Function setFuture;

  OnlinePaymentRequestFilters({
    super.key,
    required this.setFuture,
  });

  @override
  State<OnlinePaymentRequestFilters> createState() =>
      _OnlinePaymentRequestFiltersState();
}

class _OnlinePaymentRequestFiltersState
    extends State<OnlinePaymentRequestFilters> {
  int selectedBtnIdx = 0; // 선택된 버튼의 인덱스

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _OnlinePaymentRequestFilter(
              value: 0,
              text: '전체',
              isSelected: selectedBtnIdx == 0,
              onPressed: () {
                setState(() {
                  selectedBtnIdx = 0;
                });
                widget.setFuture(null);
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 1,
              text: '부탁 대기',
              isSelected: selectedBtnIdx == 1,
              onPressed: () {
                setState(() {
                  selectedBtnIdx = 1;
                });
                widget.setFuture('WAIT');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 2,
              text: '부탁 완료',
              isSelected: selectedBtnIdx == 2,
              onPressed: () {
                setState(() {
                  selectedBtnIdx = 2;
                });
                widget.setFuture('APPROVE');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 3,
              text: '부탁 거절',
              isSelected: selectedBtnIdx == 3,
              onPressed: () {
                setState(() {
                  selectedBtnIdx = 3;
                });
                widget.setFuture('REJECT');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlinePaymentRequestFilter extends StatelessWidget {
  final int value;
  final String text;
  final bool isSelected;
  final Function onPressed;

  _OnlinePaymentRequestFilter({
    super.key,
    required this.value,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: isSelected
              ? _selectedOnlinePaymentRequestFilterBtnStyle()
              : _unselectedOnlinePaymentRequestFilterBtnStyle(),
          child: Text(
            text,
            style: isSelected
                ? _selectedOnlinePaymentRequestFilterTextStyle()
                : _unselectedOnlinePaymentRequestFilterTextStyle(),
          ),
        ));
  }
}

ButtonStyle _unselectedOnlinePaymentRequestFilterBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        // color: const Color(0xFF8320E7), // 테두리 색상 설정
        color: const Color(0xFFB9B9B9),
        width: 1.0, // 테두리 두께 설정
      ),
    )),
  );
}

TextStyle _unselectedOnlinePaymentRequestFilterTextStyle() {
  return TextStyle(color: Color.fromARGB(255, 146, 146, 146));
}

ButtonStyle _selectedOnlinePaymentRequestFilterBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF3E6FF)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        // color: const Color(0xFF8320E7), // 테두리 색상 설정
        color: const Color(0xFF8320E7),
        width: 2.0, // 테두리 두께 설정
      ),
    )),
  );
}

TextStyle _selectedOnlinePaymentRequestFilterTextStyle() {
  return TextStyle(color: const Color(0xFF8320E7), fontWeight: FontWeight.bold);
}
