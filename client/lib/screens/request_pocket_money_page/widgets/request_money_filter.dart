import 'package:flutter/material.dart';

class RequestMoneyFilters extends StatefulWidget {
  RequestMoneyFilters({super.key});

  @override
  State<RequestMoneyFilters> createState() => _RequestMoneyFiltersState();
}

class _RequestMoneyFiltersState extends State<RequestMoneyFilters> {
  int selectedBtnIdx = 0; // 선택된 버튼의 인덱스

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          _RequestMoneyFilter(
            value: 0,
            text: '전체',
            isSelected: selectedBtnIdx == 0,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 0;
              });
            },
          ),
          _RequestMoneyFilter(
            value: 1,
            text: '대기중',
            isSelected: selectedBtnIdx == 1,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 1;
              });
            },
          ),
          _RequestMoneyFilter(
            value: 2,
            text: '승인',
            isSelected: selectedBtnIdx == 2,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 2;
              });
            },
          ),
          _RequestMoneyFilter(
            value: 3,
            text: '거부',
            isSelected: selectedBtnIdx == 3,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 3;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _RequestMoneyFilter extends StatelessWidget {
  final int value;
  final String text;
  final bool isSelected;
  final Function onPressed;

  _RequestMoneyFilter({
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
              ? _selectedRequestMoneyFilterBtnStyle()
              : _unselectedRequestMoneyFilterBtnStyle(),
          child: Text(
            text,
            style: isSelected
                ? _selectedRequestMoneyFilterTextStyle()
                : _unselectedRequestMoneyFilterTextStyle(),
          ),
        ));
  }
}

ButtonStyle _unselectedRequestMoneyFilterBtnStyle() {
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

TextStyle _unselectedRequestMoneyFilterTextStyle() {
  return TextStyle(color: Color.fromARGB(255, 146, 146, 146));
}

ButtonStyle _selectedRequestMoneyFilterBtnStyle() {
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

TextStyle _selectedRequestMoneyFilterTextStyle() {
  return TextStyle(color: const Color(0xFF8320E7), fontWeight: FontWeight.bold);
}
