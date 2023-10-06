import 'package:flutter/material.dart';

class OnlinePaymentRequestFormProvider with ChangeNotifier {
  String? _productName;
  String? _url;
  String? _content;
  int? _totalMoney;
  int? _childMoney;

  String? get productName => _productName;
  String? get url => _url;
  String? get content => _content;
  int? get totalMoney => _totalMoney;
  int? get childMoney => _childMoney;

  void setProductName(String productName) {
    _productName = productName;
  }

  void setUrl(String url) {
    _url = url;
  }

  void setContent(String content) {
    _content = content;
  }

  void setTotalMoney(String totalMoney) {
    if (totalMoney.isNotEmpty) {
      _totalMoney = int.parse(totalMoney);
    } else {
      _totalMoney = 0;
    }
  }

  void setChildMoney(String childMoney) {
    if (childMoney.isNotEmpty) {
      _childMoney = int.parse(childMoney);
    } else {
      _childMoney = 0;
    }
  }

  void removeOnlinePaymentRequestForm() {
    _productName = null;
    _url = null;
    _content = null;
    _totalMoney = null;
    _childMoney = null;
  }
}