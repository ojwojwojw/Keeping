import 'package:flutter/material.dart';

class PiggyProvider with ChangeNotifier {
  List<Map>? _piggyInfos;
  List<Map>? get piggyInfos => _piggyInfos;

  void initPiggy(List<Map> piggyInfos) {
    _piggyInfos = piggyInfos;

    notifyListeners();
  }

  void removePiggy() {
    _piggyInfos = null;

    notifyListeners();
  }
}

class PiggyDetailProvider with ChangeNotifier {
  int? _id;
  String? _childKey;
  String? _accountNumber;
  String? _content;
  int? _goalMoney;
  int? _balance;
  String? _savedImage;
  String? _completed;

  int? get id => _id;
  String? get childKey => _childKey;
  String? get accountNumber => _accountNumber;
  String? get content => _content;
  int? get goalMoney => _goalMoney;
  int? get balance => _balance;
  String? get savedImage => _savedImage;
  String? get completed => _completed;

  initPiggyDetail(dynamic piggyDetail) {
    _id = piggyDetail['id'];
    _childKey = piggyDetail['childKey'];
    _accountNumber = piggyDetail['accountNumber'];
    _content = piggyDetail['content'];
    _goalMoney = piggyDetail['goalMoney'];
    _balance = piggyDetail['balance'];
    _savedImage = piggyDetail['savedImg'];
    _completed = piggyDetail['completed'];
  }

  void removePiggyDetail() {
    _childKey = null;
    _accountNumber = null;
    _content = null;
    _goalMoney = null;
    _balance = null;
    _savedImage = null;
    _completed = null;
  }
}

class AddPiggyProvider with ChangeNotifier {
  String? _content;
  double? _goalMoney;
  String? _imgPath;

  String? get content => _content;
  double? get goalMoney => _goalMoney;
  String? get imgPath => _imgPath;

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void setGoalMoney(double goalMoney) {
    _goalMoney = goalMoney;
    notifyListeners();
  }

  void setImgPath(String imgPath) {
    _imgPath = imgPath;
    notifyListeners();
  }

  void addPiggyInfo(String content, double goalMoney, String? imgPath) {
    _content = content;
    _goalMoney = goalMoney;
    _imgPath = imgPath;

    notifyListeners();
  }

  void removeAddPiggyInfo() {
    _content = null;
    _goalMoney = null;
    _imgPath = null;
  }
}