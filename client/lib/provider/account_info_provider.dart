import 'package:flutter/material.dart';

class AccountInfoProvider with ChangeNotifier {
  String _accountNumber = '';
  int _balance = 0;
  DateTime _createdDate = DateTime.now();

  String get accountNumber => _accountNumber;
  int get balance => _balance;
  DateTime get createdDate => _createdDate;

  void setAccountInfo(dynamic accountInfo) {
    _accountNumber = accountInfo['accountNumber'];
    _balance = accountInfo['balance'];
    _createdDate = DateTime.parse(accountInfo['createdDate']);
  }

  void setNewAccountInfo(dynamic accountInfo) {
    _accountNumber = accountInfo['accountNumber'];
    _balance = 0;
    _createdDate = DateTime.parse(accountInfo['createdDate']);
  }
  
}

class AccountDetailProvider with ChangeNotifier {
  DateTime _date = DateTime.now();
  String _storeName = '';
  int _money = 0;
  int _balance = 0;
  int _accountHistoryId = -2;
  bool? _type;
  String _largeCategory = '';
  List<Map<String, dynamic>> _accountDetailList = [];

  DateTime get date => _date;
  String get storeName => _storeName;
  int get money => _money;
  int get balance => _balance;
  int get accountHistoryId => _accountHistoryId;
  bool? get type => _type;
  String get largeCategory => _largeCategory;
  List<Map<String, dynamic>> get accountDetailList => _accountDetailList;

  void setAccountDetail(dynamic accountDetail) {
    _date = accountDetail['createdDate'];
    _storeName = accountDetail['storeName'];
    _money = accountDetail['money'];
    _balance = accountDetail['balance'];
    _accountHistoryId = accountDetail['id'];
    _type = accountDetail['type'];
    _largeCategory = accountDetail['largeCategory'];
  }

  void addAccountDetail(Map<String, dynamic> accountDetail) {
    _accountDetailList.add(accountDetail);
  }

  void initAccountDetail() {
    _date = DateTime.now();
    _storeName = '';
    _money = 0;
    _balance = 0;
    _accountHistoryId = -2;
    _type;
    _largeCategory = '';
    _accountDetailList = [];
  }
}