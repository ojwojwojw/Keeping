import 'package:flutter/material.dart';

class MissionFilters extends StatefulWidget {
  Function setFilter;
  Function setIdx;
  int Idx;

  MissionFilters({
    super.key,
    required this.setFilter,
    required this.setIdx,
    required this.Idx,
  });

  @override
  State<MissionFilters> createState() =>
      _MissionFiltersState();
}

class _MissionFiltersState
    extends State<MissionFilters> {
  // int selectedBtnIdx = 0; // 선택된 버튼의 인덱스

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
              isSelected: widget.Idx == 0,
              onPressed: () {
                widget.setIdx(0);
                widget.setFilter('ALL');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 1,
              text: '진행 중',
              isSelected: widget.Idx == 1,
              onPressed: () {
                widget.setIdx(1);
                widget.setFilter('YET');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 2,
              text: '미션 대기',
              isSelected: widget.Idx == 2,
              onPressed: () {
                widget.setIdx(2);
                widget.setFilter('CREATE_WAIT');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 3,
              text: '미션 완료',
              isSelected: widget.Idx == 3,
              onPressed: () {
                widget.setIdx(3);
                widget.setFilter('FINISH_WAIT');
              },
            ),
            _OnlinePaymentRequestFilter(
              value: 4,
              text: '이전 미션',
              isSelected: widget.Idx == 4,
              onPressed: () {
                widget.setIdx(4);
                widget.setFilter('FINISH');
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
