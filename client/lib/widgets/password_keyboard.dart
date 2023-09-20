import 'package:flutter/material.dart';
import 'package:keeping/widgets/number_keyboard_key.dart';

class PasswordKeyboard extends StatefulWidget {
  final onNumberPress;
  final onBackspacePress;
  final onClearPress;

  PasswordKeyboard({
    super.key,
    this.onNumberPress,
    this.onBackspacePress,
    this.onClearPress,
  });
  
  @override
  State<PasswordKeyboard> createState() => _PasswordKeyboardState();
}

class _PasswordKeyboardState extends State<PasswordKeyboard> {
  late List<List<dynamic>> keys;
  // late String amount;

  @override
  void initState() {
    super.initState();
    keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['취소', '0', Icon(Icons.keyboard_backspace)],
    ];
    // amount = '';
  }

  // onNumberPress(val) {
  //   if (val == '0' && amount.isEmpty) {
  //     return;
  //   }

  //   setState(() {
  //     amount = amount + val;
  //   });
  // }

  // onBackspacePress() {
  //   if (amount.isEmpty) {
  //     return;
  //   }

  //   setState(() {
  //     amount = amount.substring(0, amount.length - 1);
  //   });
  // }

  renderPasswordKeyboard() {
    return keys
      .map((key) => Row(
        children: key.map((k) {
          return Expanded(
            child: NumberKeyboardKey(
              label: k, 
              onTap: (val) {
                if (val is Widget) {
                  widget.onBackspacePress();
                } else if (val == '취소') {
                  widget.onClearPress();
                } else {
                  widget.onNumberPress(val);
                }
              },
              value: k,
            ),
          );
        }).toList(),
      ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...renderPasswordKeyboard(),
      ]
    );
  }
}