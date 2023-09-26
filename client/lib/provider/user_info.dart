import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  String _type = '';
  String _name = '';
  String _phoneNumber = '';
  String _birthDate = '';
  String _profileImage = '';
  String _questionTime = '';
  String _fcmToken = '';

  String get type => _type;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get birthDate => _birthDate;
  String get profileImage => _profileImage;
  String get questionTime => _questionTime;
  String get fcmToken => _fcmToken;

  void login(Map<String, dynamic> userData) {
    _type = userData['type'] ?? '';
    _name = userData['name'] ?? '';
    _phoneNumber = userData['phoneNumber'] ?? '';
    _birthDate = userData['birthDate'] ?? '';
    _profileImage = userData['profileImage'] ?? '';
    _questionTime = userData['questionTime'] ?? '';
    _fcmToken = userData['fcmToken'] ?? '';
    notifyListeners();
  }
}
