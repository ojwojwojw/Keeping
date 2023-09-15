import 'package:flutter/material.dart';
import 'package:keeping/widgets/number_keyboard_key.dart';

class NumberKeyboard extends StatefulWidget {
  @override
  _NumberKeyboardState createState() => _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> {
  late List<List<dynamic>> keys;
  late String amount;

  @override
  void initState() {
    super.initState();
    keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['00', '0', Icon(Icons.keyboard_backspace)],
    ];
    amount = '';
  }


  onNumberPress(val) {
    if (val == '0' && amount.isEmpty) {
      return;
    }

    setState(() {
      amount = amount + val;
    });
  }

  onBackspacePress() {
    if (amount.isEmpty) {
      return;
    }

    setState(() {
      amount = amount.substring(0, amount.length - 1);
    });
  }

  renderNumberKeyboard() {
    return keys
      .map((key) => Row(
        children: key.map((k) {
          return Expanded(
            child: NumberKeyboardKey(
              label: k, 
              onTap: (val) {
                if (val is Widget) {
                  onBackspacePress();
                } else {
                  onNumberPress(val);
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
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...renderNumberKeyboard(),
      ]
    );
  }
}