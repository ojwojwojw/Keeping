import 'package:flutter/material.dart';

class MissionInfoProvider with ChangeNotifier {
  String? missionTitle;
  String? missionDueDate;
  String? amount;
  String? childRequestComment;

  // TODO: 다른 데이터 필드 추가 시 여기에 추가

  void saveTodoData({String? todo, String? endDate}) {
    this.missionTitle = todo;
    this.missionDueDate = endDate;
    notifyListeners();
  }

  void saveMoneyData(String amt) {
    this.amount = amt;
    notifyListeners();
  }

  void setChildRequestComment(String comment) {
    this.childRequestComment = comment;
    notifyListeners();
  }

  // TODO: 필요한 메서드 추가 시 여기에 추가
}
