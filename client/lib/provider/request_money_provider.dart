import 'package:flutter/material.dart';

class RequestMoneyProvider with ChangeNotifier {
  String _money = '';
  String _content = '';
  bool _isAccepted = false; // 두 개의 필드가 입력된 경우, true로 할 것
  bool _isMoney = false;
  bool _isContent = false;

  String get money => _money;
  String get content => _content;
  bool get isAccepted => _isAccepted;
  bool get isMoney => _isMoney;
  bool get isContent => _isContent;

  void updateRequestMoney({
    String? content,
    String? money,
    bool? isAccepted,
    bool? isMoney,
    bool? isContent,
  }) {
    if (content != null) {
      _content = content;
      _isContent = true;
      if (_isMoney && _isContent) {
        isAccepted = true;
      }
    }
    if (content == '') {
      _isContent = false;
      _isAccepted = false;
    }

    if (money != null) {
      _money = money;
      _isMoney = true;
      if (_isMoney && _isContent) {
        isAccepted = true;
      }
    }
    if (money == '') {
      _isMoney = false;
      _isAccepted = false;
    }

    if (_isContent == true && _isMoney == true) {
      isAccepted = true;
    } else {
      isAccepted = false;
    }
    if (isAccepted) {
      _isAccepted = isAccepted;
    }
    notifyListeners();
  }
}
