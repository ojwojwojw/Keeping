import 'package:flutter/material.dart';

class UserLinkProvider with ChangeNotifier {
  String _myCode = '';
  String _oppCode = '';

  String get myCode => _myCode;
  String get oppCode => _oppCode;

  void updateUserCode({
    String? myCode,
    String? oppCode,
  }) {
    if (myCode != null) {
      _myCode = myCode;
    }
    if (oppCode != null) {
      _oppCode = oppCode;
    }
    notifyListeners();
  }
}
