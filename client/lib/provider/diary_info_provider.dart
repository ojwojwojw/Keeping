import 'package:flutter/material.dart';

class DiaryInfoProvider with ChangeNotifier {
  Map<String, dynamic>? diaryData;

  // TODO: 다른 데이터 필드 추가 시 여기에 추가

  void saveData(Map<String, dynamic>? data) {
    this.diaryData = data;
    notifyListeners();
  }

  // TODO: 필요한 메서드 추가 시 여기에 추가
}
