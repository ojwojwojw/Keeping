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

  void setReason(String reason) {
    _reason = reason;
  }

  void setCost(String cost) {
    if (cost.isNotEmpty) {
      _cost = int.parse(cost);
    } else {
      _cost = 0;
    }
  }

  void setPaidMoney(String paidMoney) {
    if (paidMoney.isNotEmpty) {
      _paidMoney = int.parse(paidMoney);
    } else {
      _paidMoney = 0;
    }
  }

  void removeOnlinePaymentRequestForm() {
    _name = null;
    _url = null;
    _reason = null;
    _cost = null;
    _paidMoney = null;
  }
}