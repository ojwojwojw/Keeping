import 'package:flutter/material.dart';

class PiggyFilters extends StatefulWidget {
  PiggyFilters({super.key});

  @override
  State<PiggyFilters> createState() => _PiggyFiltersState();
}

class _PiggyFiltersState extends State<PiggyFilters> {
  int selectedBtnIdx = 0;  // 선택된 버튼의 인덱스

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          PiggyFilter(
            value: 0, 
            text: '전체', 
            isSelected: selectedBtnIdx == 0,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 0;
              });
            },
          ),
          PiggyFilter(
            value: 1, 
            text: '혼자',
            isSelected: selectedBtnIdx == 1,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 1;
              });
            },
          ),
          PiggyFilter(
            value: 2, 
            text: '같이',
            isSelected: selectedBtnIdx == 2,
            onPressed: () {
              setState(() {
                selectedBtnIdx = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}

class PiggyFilter extends StatelessWidget {
  final int value;
  final String text;
  final bool isSelected;
  final Function onPressed;

  PiggyFilter({
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
        style: isSelected ? selectedPiggyFilterBtnStyle() : unselectedPiggyFilterBtnStyle(),
        child: Text(
          text,
          style: isSelected ? selectedPiggyFilterTextStyle() : unselectedPiggyFilterTextStyle(),
        ),
      )
    );
  }
}

ButtonStyle unselectedPiggyFilterBtnStyle() {
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
      )
    ),
  );
}

TextStyle unselectedPiggyFilterTextStyle() {
  return TextStyle(
    color: Color.fromARGB(255, 146, 146, 146)
  );
}

ButtonStyle selectedPiggyFilterBtnStyle() {
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
      )
    ),
  );
}

TextStyle selectedPiggyFilterTextStyle() {
  return TextStyle(
    color: const Color(0xFF8320E7),
    fontWeight: FontWeight.bold
  );
}