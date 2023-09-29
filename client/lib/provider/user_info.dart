import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  String _name = '';
  String _profileImage = '';
  List<Map<String, dynamic>> _childrenList = [];
  bool _parent = true;
  String _fcmToken = '';
  String _accessToken = '';
  String _memberKey = '';

  String get name => _name;
  String get profileImage => _profileImage;
  List<Map<String, dynamic>> get childrenList => _childrenList;
  bool get parent => _parent;
  String get fcmToken => _fcmToken;
  String get accessToken => _accessToken;
  String get memberKey => _memberKey;

  void updateUserInfo({
    String? name,
    String? profileImage,
    List<Map<String, dynamic>>? childrenList,
    bool? parent,
  }) {
    print(childrenList);
    if (name != null) {
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
    print('여기까지 옴');
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
