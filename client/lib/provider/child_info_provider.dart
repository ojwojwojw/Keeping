import 'package:flutter/material.dart';

class ChildInfoProvider with ChangeNotifier {
  String? _memberKey;
  String? _name;
  String? _profileImage;
  String _accountNumber = '';
  int? _balance;
  DateTime? _createdDate;

  String? get memberKey => _memberKey;
  String? get name => _name;
  String? get profileImage => _profileImage;
  String get accountNumber => _accountNumber;
  int? get balance => _balance;
  DateTime? get createdDate => _createdDate;

  void setChildInfo(Map<String, dynamic>? childInfo) {
    if (childInfo == null) {
      return;
    }
    _memberKey = childInfo['memberKey'];
    _name = childInfo['name'];
    _profileImage = childInfo['profileImage'];
  }

  void setChildAccount(Map<String, dynamic>? childAccount) {
    if (childAccount == null) {
      return;
    }
    _accountNumber = childAccount['accountNumber'];
    _balance = childAccount['balance'];
    _createdDate = DateTime.parse(childAccount['createdDate']);
  }

  void initChildInfo() {
    _memberKey = null;
    _name = null;
    _profileImage = null;
    _accountNumber = '';
    _balance = null;
    _createdDate = null;
  }
}