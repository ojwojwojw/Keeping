import 'package:flutter/material.dart';

class OnlinePaymentRequestFormProvider with ChangeNotifier {
  String? _name;
  String? _url;
  String? _reason;
  int? _cost;
  int? _paidMoney;

  String? get name => _name;
  String? get url => _url;
  String? get reason => _reason;
  int? get cost => _cost;
  int? get paidMoney => _paidMoney;

  void setName(String name) {
    _name = name;
  }

  void setUrl(String url) {
    _url = url;
  }

  void removeOnlinePaymentRequestForm() {
    _name = null;
    _url = null;
    _reason = null;
    _cost = null;
    _paidMoney = null;
  }
}