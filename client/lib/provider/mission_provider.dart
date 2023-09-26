import 'package:flutter/material.dart';

class Mission with ChangeNotifier {
  List<Map<String, dynamic>> _missionArray = [];
  List<Map<String, dynamic>> get missionArray => _missionArray;

  void fatchData(List<Map<String, dynamic>> item) {
    _missionArray = item;
    notifyListeners();
  }
}
