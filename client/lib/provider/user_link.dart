import 'package:flutter/material.dart';

class UserLinkProvider with ChangeNotifier {
  String _myCode = '';
  String _oppCode = '';
  int _expire = 86400;
  String get myCode => _myCode;
  String get oppCode => _oppCode;
  int get expire => _expire;
  void updateUserCode({String? myCode, String? oppCode, int? expire}) {
    if (myCode != null) {
      _myCode = myCode;
    }
    if (oppCode != null) {
      _oppCode = oppCode;
    }
    if (expire != null) {
      _expire = expire;
    }
    notifyListeners();
  }
}
