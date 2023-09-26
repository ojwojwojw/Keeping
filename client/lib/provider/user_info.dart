import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  String _name = '';
  String _profileImage = '';
  String _childrenList = '';
  bool _parent = true;
  String _fcmToken = '';
  String _accessToken = '';
  String _memberKey = '';

  String get name => _name;
  String get profileImage => _profileImage;
  String get childrenList => _childrenList;
  bool get parent => _parent;
  String get fcmToken => _fcmToken;
  String get accessToken => _accessToken;
  String get memberkey => _memberKey;

  void updateUserInfo({
    String? name,
    String? profileImage,
    String? childrenList,
    bool? parent,
  }) {
    if (name != null) {
      print(name);
      _name = name;
    }
    if (profileImage != null) {
      _profileImage = profileImage;
    }
    if (childrenList != null) {
      _childrenList = childrenList;
    }
    if (parent != null) {
      _parent = parent;
    }
    notifyListeners();
  }

  void updateFcmToken({
    String? fcmToken,
  }) {
    if (fcmToken != null) {
      _fcmToken = fcmToken;
    }
    notifyListeners();
  }

  void updateTokenMemberKey({
    String? accessToken,
    String? memberKey,
  }) {
    if (accessToken != null) {
      _accessToken = accessToken;
    }
    if (memberKey != null) {
      _memberKey = memberKey;
    }
    notifyListeners();
  }
}